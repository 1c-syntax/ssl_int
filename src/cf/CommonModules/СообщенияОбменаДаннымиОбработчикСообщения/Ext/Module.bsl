﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает список обработчиков сообщений, которые обрабатывает данная подсистема.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений.
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Обработчики) Экспорт
	
	ДобавитьОбработчикКаналаСообщений("ОбменДанными\ПрикладноеПриложение\СозданиеОбмена",                 СообщенияОбменаДаннымиОбработчикСообщения, Обработчики);
	ДобавитьОбработчикКаналаСообщений("ОбменДанными\ПрикладноеПриложение\УдалениеОбмена",                 СообщенияОбменаДаннымиОбработчикСообщения, Обработчики);
	ДобавитьОбработчикКаналаСообщений("ОбменДанными\ПрикладноеПриложение\УстановитьПрефиксОбластиДанных", СообщенияОбменаДаннымиОбработчикСообщения, Обработчики);
	
КонецПроцедуры

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений.
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор канала сообщений, из которого получено сообщение.
//  ТелоСообщения  - Произвольный - Тело сообщения, полученное из канала, которое подлежит обработке.
//  Отправитель    - ПланОбменаСсылка.ОбменСообщениями - Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(КаналСообщений, ТелоСообщения, Отправитель) Экспорт
	
	Попытка
		
		УстановитьОбластьДанных(ТелоСообщения.ОбластьДанных);
		
		Если КаналСообщений = "ОбменДанными\ПрикладноеПриложение\СозданиеОбмена" Тогда
			
			СоздатьОбменДаннымиВИнформационнойБазе(
									Отправитель,
									ТелоСообщения.Настройки,
									ТелоСообщения.НастройкаОтборовНаУзле,
									ТелоСообщения.ЗначенияПоУмолчаниюНаУзле,
									ТелоСообщения.КодЭтогоУзла,
									ТелоСообщения.КодНовогоУзла);
			
		ИначеЕсли КаналСообщений = "ОбменДанными\ПрикладноеПриложение\УдалениеОбмена" Тогда
			
			УдалитьОбменДаннымиВИнформационнойБазе(Отправитель, ТелоСообщения.ИмяПланаОбмена, ТелоСообщения.КодУзла);
			
		ИначеЕсли КаналСообщений = "ОбменДанными\ПрикладноеПриложение\УстановитьПрефиксОбластиДанных" Тогда
			
			УстановитьПрефиксОбластиДанных(ТелоСообщения.Префикс);
			
		КонецЕсли;
		
	Исключение
		ОтменитьУстановкуОбластиДанных();
		ВызватьИсключение;
	КонецПопытки;
	
	ОтменитьУстановкуОбластиДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для совместимости, если корреспондент имеет БСП версии ниже БСП 2.1.2
//
Процедура СоздатьОбменДаннымиВИнформационнойБазе(Отправитель, Настройки, НастройкаОтборовНаУзле, ЗначенияПоУмолчаниюНаУзле, КодЭтогоУзла, КодНовогоУзла)
	
	// Создаем каталог обмена сообщениями (при необходимости)
	Каталог = Новый Файл(Настройки.FILEКаталогОбменаИнформацией);
	
	Если Не Каталог.Существует() Тогда
		
		Попытка
			СоздатьКаталог(Каталог.ПолноеИмя);
		Исключение
			
			// Отмечаем в управляющем приложении ошибку выполнения операции
			ОтправитьСообщениеОшибкаПриСозданииОбмена(Число(КодЭтогоУзла), Число(КодНовогоУзла), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), Отправитель);
			
			ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ОбластьДанныхКорреспондента = Число(КодНовогоУзла);
		ИмяПланаОбмена              = Настройки.ИмяПланаОбмена;
		КодКорреспондента           = ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(ОбластьДанныхКорреспондента);
		НаименованиеКорреспондента  = Настройки.НаименованиеВторойБазы;
		НастройкаОтборовНаУзле      = Новый Структура;
		КодЭтогоПриложения          = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
		НаименованиеЭтогоПриложения = ОбменДаннымиВМоделиСервиса.СформироватьНаименованиеПредопределенногоУзла();
		
		КонечнаяТочкаКорреспондента = ОбменДаннымиВМоделиСервиса.МенеджерПланаОбменаКонечныхТочек().НайтиПоКоду(
			Настройки.КонечнаяТочкаКорреспондента);
		
		Если КонечнаяТочкаКорреспондента.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'"),
				Настройки.КонечнаяТочкаКорреспондента);
		КонецЕсли;
		
		// Создаем настройку обмена в этой базе
		НастройкиПодключения = Новый Структура;
		НастройкиПодключения.Вставить("ИмяПланаОбмена",              ИмяПланаОбмена);
		НастройкиПодключения.Вставить("КодКорреспондента",           КодКорреспондента);
		НастройкиПодключения.Вставить("НаименованиеКорреспондента",  НаименованиеКорреспондента);
		НастройкиПодключения.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
		НастройкиПодключения.Вставить("Настройки",                   НастройкаОтборовНаУзле);
		НастройкиПодключения.Вставить("Префикс",                     "");
		НастройкиПодключения.Вставить("Корреспондент"); // выходной параметр
		
		ОбменДаннымиВМоделиСервиса.СоздатьНастройкуОбмена(
			НастройкиПодключения,
			,
			Истина);
			
		Корреспондент = НастройкиПодключения.Корреспондент;
		
		// Сохраняем настройки транспорта сообщений обмена для текущей области данных
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Корреспондент", Корреспондент);
		СтруктураЗаписи.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
		СтруктураЗаписи.Вставить("КаталогОбменаИнформацией", Настройки.FILEОтносительныйКаталогОбменаИнформацией);
		
		РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.ОбновитьЗапись(СтруктураЗаписи);
		
		// Регистрируем все данные к выгрузке в этой базе
		ОбменДаннымиСервер.ЗарегистрироватьДанныеДляНачальнойВыгрузки(Корреспондент);
		
		// Отмечаем успешное выполнение операции в управляющем приложении
		ОтправитьСообщениеУспешноеВыполнениеОперации(Число(КодЭтогоУзла), Число(КодНовогоУзла), Отправитель);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		// Отмечаем в управляющем приложении ошибку выполнения операции
		ОтправитьСообщениеОшибкаПриСозданииОбмена(Число(КодЭтогоУзла), Число(КодНовогоУзла), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), Отправитель);
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Для совместимости, если корреспондент имеет БСП версии ниже БСП 2.1.2
//
Процедура УдалитьОбменДаннымиВИнформационнойБазе(Отправитель, ИмяПланаОбмена, КодУзла)
	
	// Поиск узла по формату кода узла "S00000123"
	УзелИнформационнойБазы = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(Число(КодУзла)));
	
	Если УзелИнформационнойБазы.Пустая() Тогда
		
		// Поиск узла по формату кода узла "0000123" (старый формат)
		УзелИнформационнойБазы = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(КодУзла);
		
	КонецЕсли;
	
	КодЭтогоУзла = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	КодЭтогоУзла = ОбменДаннымиСлужебный.НомерОбластиИзКодаУзлаПланаОбмена(КодЭтогоУзла);
	
	Если УзелИнформационнойБазы.Пустая() Тогда
		
		// Отмечаем успешное выполнение операции в управляющем приложении
		ОтправитьСообщениеУспешноеВыполнениеОперации(КодЭтогоУзла, Число(КодУзла), Отправитель);
		
		Возврат; // настройка обмена не найдена (возможно, была удалена ранее)
	КонецЕсли;
	
	// Удаляем каталог обмена информацией
	НастройкиТранспорта = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспорта(УзелИнформационнойБазы);
	
	Если НастройкиТранспорта <> Неопределено
		И НастройкиТранспорта.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		Если Не ПустаяСтрока(НастройкиТранспорта.FILEОбщийКаталогОбменаИнформацией)
			И Не ПустаяСтрока(НастройкиТранспорта.ОтносительныйКаталогОбменаИнформацией) Тогда
			
			АбсолютныйКаталогОбменаИнформацией = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
				НастройкиТранспорта.FILEОбщийКаталогОбменаИнформацией,
				НастройкиТранспорта.ОтносительныйКаталогОбменаИнформацией);
			
			АбсолютныйКаталог = Новый Файл(АбсолютныйКаталогОбменаИнформацией);
			
			Попытка
				УдалитьФайлы(АбсолютныйКаталог.ПолноеИмя);
			Исключение
				ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
					УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Удаляем узел
	Попытка
		УзелИнформационнойБазы.ПолучитьОбъект().Удалить();
	Исключение
		
		СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		// Отмечаем в управляющем приложении ошибку выполнения операции
		ОтправитьСообщениеОшибкаПриУдаленииОбмена(КодЭтогоУзла, Число(КодУзла), СтрокаСообщенияОбОшибке, Отправитель);
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
		Возврат;
	КонецПопытки;
	
	// Отмечаем успешное выполнение операции в управляющем приложении
	ОтправитьСообщениеУспешноеВыполнениеОперации(КодЭтогоУзла, Число(КодУзла), Отправитель);
	
КонецПроцедуры

Процедура УстановитьПрефиксОбластиДанных(Знач Префикс)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
	
		УстановитьПривилегированныйРежим(Истина);
		
		МенеджерКонстанты = Константы["ПрефиксОбластиДанных"];
		
		Если ПустаяСтрока(МенеджерКонстанты.Получить()) Тогда
			
			МенеджерКонстанты.Установить(Формат(Префикс, "ЧЦ=2; ЧВН=; ЧГ=0"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОбластьДанных(Знач ОбластьДанных)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	
КонецПроцедуры

Процедура ОтменитьУстановкуОбластиДанных()
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
	
КонецПроцедуры

Процедура ОтправитьСообщениеУспешноеВыполнениеОперации(Код1, Код2, КонечнаяТочка)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульОбменСообщениями = ОбщегоНазначения.ОбщийМодуль("ОбменСообщениями");
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("Код1, Код2", Код1, Код2);
		
		МодульОбменСообщениями.ОтправитьСообщение("ОбменДанными\ПрикладноеПриложение\Ответ\УспешноеВыполнениеОперации", ТелоСообщения, КонечнаяТочка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииОтправкаСообщений(),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтправитьСообщениеОшибкаПриСозданииОбмена(Код1, Код2, СтрокаОшибки, КонечнаяТочка)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульОбменСообщениями = ОбщегоНазначения.ОбщийМодуль("ОбменСообщениями");
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("Код1, Код2, СтрокаОшибки", Код1, Код2, СтрокаОшибки);
		
		МодульОбменСообщениями.ОтправитьСообщение("ОбменДанными\ПрикладноеПриложение\Ответ\ОшибкаПриСозданииОбмена", ТелоСообщения, КонечнаяТочка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииОтправкаСообщений(),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтправитьСообщениеОшибкаПриУдаленииОбмена(Код1, Код2, СтрокаОшибки, КонечнаяТочка)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульОбменСообщениями = ОбщегоНазначения.ОбщийМодуль("ОбменСообщениями");
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("Код1, Код2, СтрокаОшибки", Код1, Код2, СтрокаОшибки);
		
		МодульОбменСообщениями.ОтправитьСообщение("ОбменДанными\ПрикладноеПриложение\Ответ\ОшибкаПриУдаленииОбмена", ТелоСообщения, КонечнаяТочка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииОтправкаСообщений(),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьОбработчикКаналаСообщений(Канал, ОбработчикКанала, Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Канал = Канал;
	Обработчик.Обработчик = ОбработчикКанала;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрацииОтправкаСообщений()
	
	Возврат НСтр("ru = 'Отправка сообщений'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти
