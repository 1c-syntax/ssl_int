﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыАдминистрирования, ТекущееЗначениеБлокировки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	Если ЭтоФайловаяБаза Или Не ЭтоАдминистраторСистемы Тогда
		Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Или Не ЭтоАдминистраторСистемы Тогда
		Элементы.КодДляРазблокировки.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьНачальныйСтатусЗапретаРаботыПользователей();
	ОбновитьСтраницуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КлиентПодключенЧерезВебСервер = ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер();
	Если СоединенияИБКлиент.РаботаПользователейЗавершается() Тогда
		Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаСостоянияБлокировки;
		ОбновитьСтраницуСостояния(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ИнформацияОБлокирующихСеансах = СоединенияИБ.ИнформацияОБлокирующихСеансах(НСтр("ru = 'Блокировка не установлена.'"));
	
	Если ИнформацияОБлокирующихСеансах.ИмеютсяБлокирующиеСеансы Тогда
		ВызватьИсключение ИнформацияОБлокирующихСеансах.ТекстСообщения;
	КонецЕсли;
	
	КоличествоСеансов = ИнформацияОБлокирующихСеансах.КоличествоСеансов;
	
	// Проверки возможности установки блокировки.
	Если Объект.НачалоДействияБлокировки > Объект.ОкончаниеДействияБлокировки 
		И ЗначениеЗаполнено(Объект.ОкончаниеДействияБлокировки) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата окончания блокировки не может быть меньше даты начала блокировки. Блокировка не установлена.'"),,
			"Объект.ОкончаниеДействияБлокировки",,Отказ);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.НачалоДействияБлокировки) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не указана дата начала блокировки.'"),, "Объект.НачалоДействияБлокировки",,Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершениеРаботыПользователей" Тогда
		КоличествоСеансов = Параметр.КоличествоСеансов;
		ОбновитьСостояниеБлокировки(ЭтотОбъект);
		Если Параметр.Статус = "Готово" Тогда
			Закрыть();
		ИначеЕсли Параметр.Статус = "Ошибка" Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Не удалось завершить работу всех активных пользователей.
				|Подробности см. в Журнале регистрации.'"), 30);
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АктивныеПользователи(Команда)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	ОчиститьСообщения();
	
	Объект.ЗапретитьРаботуПользователей = Не НачальныйСтатусЗапретаРаботыПользователейЗначение;
	Если Объект.ЗапретитьРаботуПользователей Тогда
		
		КоличествоСеансов = 1;
		Попытка
			Если Не ПроверитьПредусловияБлокировки() Тогда
				Возврат;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиент.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		ЗаголовокВопроса = НСтр("ru = 'Блокировка работы пользователей'");
		Если КоличествоСеансов > 1 И Объект.НачалоДействияБлокировки < ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60 Тогда
			ТекстВопроса = НСтр("ru = 'Указано слишком близкое время начала действия блокировки, к которому пользователи могут не успеть сохранить все свои данные и завершить работу.
				|Рекомендуется установить время начала на 5 минут относительно текущего времени.'");
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Заблокировать через 5 минут'"));
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Заблокировать сейчас'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
			Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "СлишкомБлизкоеВремяБлокировки");
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,,, ЗаголовокВопроса);
		ИначеЕсли Объект.НачалоДействияБлокировки > ОбщегоНазначенияКлиент.ДатаСеанса() + 60 * 60 Тогда
			ТекстВопроса = НСтр("ru = 'Указано слишком большое время начала действия блокировки (более, чем через час).
				|Запланировать блокировку на указанное время?'");
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Запланировать'"));
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Заблокировать сейчас'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
			Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "СлишкомБольшоеВремяБлокировки");
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,,, ЗаголовокВопроса);
		Иначе
			Если Объект.НачалоДействияБлокировки - ОбщегоНазначенияКлиент.ДатаСеанса() > 15*60 Тогда
				ТекстВопроса = НСтр("ru = 'Завершение работы всех активных пользователей будет произведено в период с %1 по %2.
					|Продолжить?'");
			Иначе
				ТекстВопроса = НСтр("ru = 'Сеансы всех активных пользователей будут завершены к %2.
					|Продолжить?'");
			КонецЕсли;
			Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "Подтверждение");
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Объект.НачалоДействияБлокировки - 900, Объект.НачалоДействияБлокировки);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена,,, ЗаголовокВопроса);
		КонецЕсли;
		
	Иначе
		
		Оповещение = Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект, "Подтверждение");
		ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.ОК);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьЗавершение(Ответ, Вариант) Экспорт
	
	Если Вариант = "СлишкомБлизкоеВремяБлокировки" Тогда
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.НачалоДействияБлокировки = ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60;
		ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Вариант = "СлишкомБольшоеВремяБлокировки" Тогда
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.НачалоДействияБлокировки = ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60;
		ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Вариант = "Подтверждение" Тогда
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ВведеныКорректныеПараметрыАдминистрирования И ЭтоАдминистраторСистемы И Не ЭтоФайловаяБаза
		И ТекущееЗначениеБлокировки <> Объект.ЗапретитьРаботуРегламентныхЗаданий Тогда
		
		Попытка
			УстановитьБлокировкуРегламентныхЗаданийНаСервере(ПараметрыАдминистрирования);
		Исключение
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СоединенияИБКлиент.СобытиеЖурналаРегистрации(), "Ошибка",
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),, Истина);
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
	Если Не ЭтоФайловаяБаза И Не ВведеныКорректныеПараметрыАдминистрирования И СеансЗапущенБезРазделителей Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрированияПриБлокировке", ЭтотОбъект);
		ЗаголовокФормы = НСтр("ru = 'Управление блокировкой сеансов'");
		ПоясняющаяНадпись = НСтр("ru = 'Для управления блокировкой сеансов необходимо ввести
			|параметры администрирования кластера серверов и информационной базы'");
		СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина,
			Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
		
	Иначе
		
		ПослеПолученияПараметровАдминистрированияПриБлокировке(Истина, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	Если Не ЭтоФайловаяБаза И Не ВведеныКорректныеПараметрыАдминистрирования И СеансЗапущенБезРазделителей Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрированияПриОтменеБлокировки", ЭтотОбъект);
		ЗаголовокФормы = НСтр("ru = 'Управление блокировкой сеансов'");
		ПоясняющаяНадпись = НСтр("ru = 'Для управления блокировкой сеансов необходимо ввести
			|параметры администрирования кластера серверов и информационной базы'");
		СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина,
			Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
		
	Иначе
		
		ПослеПолученияПараметровАдминистрированияПриОтменеБлокировки(Истина, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАдминистрирования(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрирования", ЭтотОбъект);
	ЗаголовокФормы = НСтр("ru = 'Управление блокировкой регламентных заданий'");
	ПоясняющаяНадпись = НСтр("ru = 'Для управления блокировкой регламентных заданий необходимо
		|ввести параметры администрирования кластера серверов и информационной базы'");
	СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина,
		Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Запрещено'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Запланировано'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Истекло'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗаблокированныйРеквизитЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачальныйСтатусЗапретаРаботыПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусЗапретаРаботыПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Разрешено'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаФормы);

КонецПроцедуры

&НаСервере
Функция ПроверитьПредусловияБлокировки()
	
	Возврат ПроверитьЗаполнение();

КонецФункции

&НаСервере
Функция УстановитьСнятьБлокировку()
	
	Попытка
		РеквизитФормыВЗначение("Объект").ВыполнитьУстановку();
		Элементы.ГруппаОшибка.Видимость = Ложь;
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБ.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если ЭтоАдминистраторСистемы Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	
	УстановитьНачальныйСтатусЗапретаРаботыПользователей();
	КоличествоСеансов = СоединенияИБ.КоличествоСеансовИнформационнойБазы();
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ОтменитьБлокировку()
	
	Попытка
		РеквизитФормыВЗначение("Объект").ОтменитьБлокировку();
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБ.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если ЭтоАдминистраторСистемы Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	
	УстановитьНачальныйСтатусЗапретаРаботыПользователей();
	Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаНастройки;
	ОбновитьСтраницуНастройки();
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьСтраницуНастройки()
	
	Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.Доступность = Истина;
	Элементы.КомандаПрименить.Видимость = Истина;
	Элементы.КомандаПрименить.КнопкаПоУмолчанию = Истина;
	Элементы.КомандаОстановить.Видимость = Ложь;
	Элементы.КомандаПрименить.Заголовок = ?(Объект.ЗапретитьРаботуПользователей,
		НСтр("ru = 'Снять блокировку'"), НСтр("ru = 'Установить блокировку'"));
	Элементы.ЗапретитьРаботуРегламентныхЗаданий.Заголовок = ?(Объект.ЗапретитьРаботуРегламентныхЗаданий,
		НСтр("ru = 'Оставить блокировку работы регламентных заданий'"), НСтр("ru = 'Также запретить работу регламентных заданий'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтраницуСостояния(Форма)
	
	Форма.Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.Доступность = Ложь;
	Форма.Элементы.КомандаОстановить.Видимость = Истина;
	Форма.Элементы.КомандаПрименить.Видимость = Ложь;
	Форма.Элементы.КомандаЗакрыть.КнопкаПоУмолчанию = Истина;
	ОбновитьСостояниеБлокировки(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеБлокировки(Форма)
	
	Если Форма.КоличествоСеансов = 0 Тогда
		
		ТекстСостояния = НСтр("ru = 'Ожидается установка блокировки...
			|Работа пользователей в программе будет запрещена в указанное время'");
		
	Иначе
		
		ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Пожалуйста, подождите...
			|Работа пользователей завершается. Осталось активных сеансов: %1'"),
			Форма.КоличествоСеансов);
			
	КонецЕсли;
	
	Форма.Элементы.Состояние.Заголовок = ТекстСостояния;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПараметрыБлокировки()
	Обработка = РеквизитФормыВЗначение("Объект");
	Попытка
		Обработка.ПолучитьПараметрыБлокировки();
		Элементы.ГруппаОшибка.Видимость = Ложь;
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБ.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если ЭтоАдминистраторСистемы Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецЕсли;
	КонецПопытки;
	
	ЗначениеВРеквизитФормы(Обработка, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНачальныйСтатусЗапретаРаботыПользователей()
	
	ПолучитьПараметрыБлокировки();
	
	НачальныйСтатусЗапретаРаботыПользователейЗначение = Объект.ЗапретитьРаботуПользователей;
	Если Объект.ЗапретитьРаботуПользователей Тогда
		Если ТекущаяДатаСеанса() < Объект.НачалоДействияБлокировки Тогда
			НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru = 'Работа пользователей в программе будет запрещена в указанное время'");
			СтатусЗапретаРаботыПользователей = "Запланировано";
		ИначеЕсли ТекущаяДатаСеанса() > Объект.ОкончаниеДействияБлокировки И Объект.ОкончаниеДействияБлокировки <> '00010101' Тогда
			НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru = 'Работа пользователей в программе разрешена (истек срок запрета)'");;
			СтатусЗапретаРаботыПользователей = "Истекло";
		Иначе
			НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru = 'Работа пользователей в программе запрещена'");
			СтатусЗапретаРаботыПользователей = "Запрещено";
		КонецЕсли;
	Иначе
		НачальныйСтатусЗапретаРаботыПользователей = НСтр("ru = 'Работа пользователей в программе разрешена'");
		СтатусЗапретаРаботыПользователей = "Разрешено";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрирования(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		ПараметрыАдминистрирования = Результат;
		ВведеныКорректныеПараметрыАдминистрирования = Истина;
		
		Попытка
			Объект.ЗапретитьРаботуРегламентныхЗаданий = БлокировкаРегламентныхЗаданийИнформационнойБазыНаСервере(ПараметрыАдминистрирования);
			ТекущееЗначениеБлокировки = Объект.ЗапретитьРаботуРегламентныхЗаданий;
		Исключение;
			ВведеныКорректныеПараметрыАдминистрирования = Ложь;
			ВызватьИсключение;
		КонецПопытки;
		
		Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.ТекущаяСтраница = Элементы.ГруппаУправлениеРегламентнымиЗаданиями;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрированияПриБлокировке(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		ПараметрыАдминистрирования = Результат;
		ВведеныКорректныеПараметрыАдминистрирования = Истина;
		ВключитьУправлениеБлокировкойРегламентныхЗаданий();
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	ИначеЕсли ТипЗнч(Результат) = Тип("Булево") И ВведеныКорректныеПараметрыАдминистрирования Тогда
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	КонецЕсли;
	
	Если Не УстановитьСнятьБлокировку() Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Блокировка работы пользователей'"),
		"e1cib/app/Обработка.БлокировкаРаботыПользователей",
		?(Объект.ЗапретитьРаботуПользователей, НСтр("ru = 'Блокировка установлена.'"), НСтр("ru = 'Блокировка снята.'")),
		БиблиотекаКартинок.Информация32);
	СоединенияИБКлиент.УстановитьРежимЗавершенияРаботыПользователей(Объект.ЗапретитьРаботуПользователей);
	
	Если Объект.ЗапретитьРаботуПользователей Тогда
		Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаСостоянияБлокировки;
		ОбновитьСтраницуСостояния(ЭтотОбъект);
	Иначе
		Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаНастройки;
		ОбновитьСтраницуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрированияПриОтменеБлокировки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		ПараметрыАдминистрирования = Результат;
		ВведеныКорректныеПараметрыАдминистрирования = Истина;
		ВключитьУправлениеБлокировкойРегламентныхЗаданий();
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	ИначеЕсли ТипЗнч(Результат) = Тип("Булево") И ВведеныКорректныеПараметрыАдминистрирования Тогда
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	КонецЕсли;
	
	Если Не ОтменитьБлокировку() Тогда
		Возврат;
	КонецЕсли;
	
	СоединенияИБКлиент.УстановитьРежимЗавершенияРаботыПользователей(Ложь);
	ПоказатьПредупреждение(,НСтр("ru = 'Завершение работы активных пользователей отменено.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьУправлениеБлокировкойРегламентныхЗаданий()
	
	Объект.ЗапретитьРаботуРегламентныхЗаданий = БлокировкаРегламентныхЗаданийИнформационнойБазыНаСервере(ПараметрыАдминистрирования);
	ТекущееЗначениеБлокировки = Объект.ЗапретитьРаботуРегламентныхЗаданий;
	Элементы.ГруппаЗапретитьРаботуРегламентныхЗаданий.ТекущаяСтраница = Элементы.ГруппаУправлениеРегламентнымиЗаданиями;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБлокировкуРегламентныхЗаданийНаСервере(ПараметрыАдминистрирования)
	
	АдминистрированиеКластера.УстановитьБлокировкуРегламентныхЗаданийИнформационнойБазы(
		ПараметрыАдминистрирования, Неопределено, Объект.ЗапретитьРаботуРегламентныхЗаданий);
	
КонецПроцедуры

&НаСервере
Функция БлокировкаРегламентныхЗаданийИнформационнойБазыНаСервере(ПараметрыАдминистрирования)
	
	Возврат АдминистрированиеКластера.БлокировкаРегламентныхЗаданийИнформационнойБазы(ПараметрыАдминистрирования);
	
КонецФункции

#КонецОбласти