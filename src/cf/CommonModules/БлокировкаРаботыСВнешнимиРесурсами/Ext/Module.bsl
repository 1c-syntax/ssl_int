﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Механизм блокировки работы с внешними ресурсами:
// - выполняет отключение регламентных заданий, работающих с внешними ресурсами;
// - при наличии подсистемы Обсуждения отключает базу от сервера взаимодействия.
// Блокировка может возникать в случае:
// - входа пользователя в систему;
// - старта выполнения регламентного задания, отмеченного как работающее с внешними ресурсами.
// Блокировка всегда выполняется в автоматическом режиме.
// Администратору предлагается подтвердить блокировку или разблокировать базу.
//
// ПередНачаломРаботыСистемы или ПриНачалеВыполненияРегламентногоЗадания выполняется
// получение параметра сеанса РаботаСВнешнимиРесурсамиЗаблокирована,
// вызывает событие ПриУстановкеПараметровСеанса где выполняется блокировка, если окружение изменилось.
//
// Отключение регламентных заданий происходит в ПриНачалеВыполненияРегламентногоЗадания если
// параметр сеанса был установлен в состояние заблокировано.
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция РаботаСВнешнимиРесурсамиЗаблокирована() Экспорт
	
	Возврат ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована;
	
КонецФункции

Процедура РазрешитьРаботуСВнешнимиРесурсами() Экспорт
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеПараметровБлокировки();
		
		ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
		ВключитьОтключенныеРегламентныеЗадания(ПараметрыБлокировки);
		
		НовыеПараметрыБлокировки = ТекущиеПараметрыБлокировки();
		НовыеПараметрыБлокировки.ПроверятьИмяСервера = ПараметрыБлокировки.ПроверятьИмяСервера;
		СохранитьПараметрыБлокировки(НовыеПараметрыБлокировки);
		
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			ЗаписатьИдентификаторФайловойБазыВФайлПроверки(НовыеПараметрыБлокировки.ИдентификаторБазы);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		МодульОбсужденияСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбсужденияСлужебный");
		МодульОбсужденияСлужебный.Разблокировать();
	КонецЕсли;
	
	ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована = Ложь;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ЗапретитьРаботуСВнешнимиРесурсами() Экспорт
	
	НачатьТранзакцию();
	Попытка
		ИдентификаторИнформационнойБазы = Новый УникальныйИдентификатор();
		Константы.ИдентификаторИнформационнойБазы.Установить(Строка(ИдентификаторИнформационнойБазы));
		
		ЗаблокироватьДанныеПараметровБлокировки();
		
		ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
		ПараметрыБлокировки.ИдентификаторБазы = ИдентификаторИнформационнойБазы;
		ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Истина;
		СохранитьПараметрыБлокировки(ПараметрыБлокировки);
		
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			ЗаписатьИдентификаторФайловойБазыВФайлПроверки(ПараметрыБлокировки.ИдентификаторБазы);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		МодульОбсужденияСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбсужденияСлужебный");
		МодульОбсужденияСлужебный.Заблокировать();
	КонецЕсли;
	
	ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована = Истина;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура УстановитьПроверкуИмениСервераВПараметрыБлокировки(ПроверятьИмяСервера) Экспорт
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеПараметровБлокировки();
		
		ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
		ПараметрыБлокировки.ПроверятьИмяСервера = ПроверятьИмяСервера;
		СохранитьПараметрыБлокировки(ПараметрыБлокировки);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#Область ОбработчикиПодписокНаСобытия

Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	Обработчики.Вставить("РаботаСВнешнимиРесурсамиЗаблокирована",
		"БлокировкаРаботыСВнешнимиРесурсами.ПриУстановкеПараметровСеанса");
	
КонецПроцедуры


// Параметры:
//  ИмяПараметра - Строка
//  УстановленныеПараметры - см. СтандартныеПодсистемыСервер.УстановкаПараметровСеанса
//
Процедура ПриУстановкеПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт 
	
	Если ИмяПараметра = "РаботаСВнешнимиРесурсамиЗаблокирована" Тогда
		
		НачатьТранзакцию();
		Попытка
			ЗаблокироватьДанныеПараметровБлокировки();
			
			ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована = УстановитьБлокировкуРаботыСВнешнимиРесурсами();
			УстановленныеПараметры.Добавить("РаботаСВнешнимиРесурсамиЗаблокирована");
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ЗапускЗаданияРазрешен = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(
		"РегламентныеЗадания", 
		РегламентноеЗадание.ИмяМетода);
	
	Если ЗапускЗаданияРазрешен = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РегламентноеЗаданиеРаботаетСВнешнимиРесурсами(РегламентноеЗадание) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСВнешнимиРесурсамиЗаблокирована() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеПараметровБлокировки();
		
		ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
		ОтключитьРегламентноеЗадание(ПараметрыБлокировки, РегламентноеЗадание);
		СохранитьПараметрыБлокировки(ПараметрыБлокировки);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Приложение было перемещено.
			           |Регламентное задание ""%1"", работающее с внешними ресурсами, отключено.'"), 
			РегламентноеЗадание.Синоним);
	Иначе 
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменилась строка соединения информационной базы.
			           |Возможно информационная база была перемещена.
			           |Регламентное задание ""%1"" отключено.'"), 
			РегламентноеЗадание.Синоним);
	КонецЕсли;
	
	РегламентныеЗаданияСервер.ОтменитьВыполнениеЗадания(РегламентноеЗадание, ТекстИсключения);
	
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(ПараметрыРаботыКлиента, ЭтоВызовПередНачаломРаботыСистемы) Экспорт
	
	ПоказатьФормуБлокировки = Ложь;
	
	Если ЭтоВызовПередНачаломРаботыСистемы И РаботаСВнешнимиРесурсамиЗаблокирована() Тогда
		ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
		
		УстановленПризнакНеобходимостиПринятияРешения = 
			ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Неопределено;
		
		ПоказатьФормуБлокировки = УстановленПризнакНеобходимостиПринятияРешения И Пользователи.ЭтоПолноправныйПользователь();
	КонецЕсли;
	
	ПараметрыРаботыКлиента.Вставить("ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами", ПоказатьФормуБлокировки);
	
КонецПроцедуры

Процедура ПослеЗагрузкиДанных(Контейнер) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыБлокировки = ТекущиеПараметрыБлокировки();
		СохранитьПараметрыБлокировки(ПараметрыБлокировки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

Процедура ОбновитьПараметрыБлокировкиРаботыСВнешнимиРесурсами() Экспорт
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеПараметровБлокировки();
		
		ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
		
		РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
		ПараметрыБлокировки.РазделениеВключено = РазделениеВключено;
		Если РазделениеВключено Тогда
			ПараметрыБлокировки.СтрокаСоединения = "";
			ПараметрыБлокировки.ИмяКомпьютера = "";
		КонецЕсли;
		
		СохранитьПараметрыБлокировки(ПараметрыБлокировки);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыБлокировки

Функция ТекущиеПараметрыБлокировки()
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	СтрокаСоединения = ?(РазделениеВключено, "", СтрокаСоединенияИнформационнойБазы());
	ИмяКомпьютера = ?(РазделениеВключено, "", ИмяКомпьютера());
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторБазы", СтандартныеПодсистемыСервер.ИдентификаторИнформационнойБазы());
	Результат.Вставить("ЭтоФайловаяБаза", ОбщегоНазначения.ИнформационнаяБазаФайловая());
	Результат.Вставить("РазделениеВключено", РазделениеВключено);
	Результат.Вставить("СтрокаСоединения", СтрокаСоединения);
	Результат.Вставить("ИмяКомпьютера", ИмяКомпьютера);
	Результат.Вставить("ПроверятьИмяСервера", Истина);
	Результат.Вставить("РаботаСВнешнимиРесурсамиЗаблокирована", Ложь);
	Результат.Вставить("ОтключенныеЗадания", Новый Массив);
	Результат.Вставить("ПричинаБлокировки", "");
	
	Возврат Результат;
	
КонецФункции

Функция СохраненныеПараметрыБлокировки() Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	Сохраненные = Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Получить().Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат = ТекущиеПараметрыБлокировки();
	
	Если Сохраненные = Неопределено Тогда 
		СохранитьПараметрыБлокировки(Результат); // Автоматическая инициализация.
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			ЗаписатьИдентификаторФайловойБазыВФайлПроверки(Результат.ИдентификаторБазы);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Сохраненные) = Тип("Структура") Тогда 
		ЗаполнитьЗначенияСвойств(Результат, Сохраненные); // Переинициализация новых свойств.
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаблокироватьДанныеПараметровБлокировки()
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Константа.ПараметрыБлокировкиРаботыСВнешнимиРесурсами");
	Блокировка.Заблокировать();
	
КонецПроцедуры

Процедура СохранитьПараметрыБлокировки(ПараметрыБлокировки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ХранилищеЗначения = Новый ХранилищеЗначения(ПараметрыБлокировки);
	Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Установить(ХранилищеЗначения);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

// АПК:453-выкл интегрированное управление регламентными заданиями в блоке блокировки работы.

Функция РегламентноеЗаданиеРаботаетСВнешнимиРесурсами(РегламентноеЗадание)
	
	ЗависимостиЗаданий = РегламентныеЗаданияСлужебный.РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
	
	Отбор = Новый Структура;
	Отбор.Вставить("РегламентноеЗадание", РегламентноеЗадание);
	Отбор.Вставить("РаботаетСВнешнимиРесурсами", Истина);
	
	НайденныеСтроки = ЗависимостиЗаданий.НайтиСтроки(Отбор);
	Возврат НайденныеСтроки.Количество() <> 0;
	
КонецФункции

Процедура ОтключитьРегламентноеЗадание(ПараметрыБлокировки, РегламентноеЗадание)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", РегламентноеЗадание);
	Отбор.Вставить("Использование", Истина);
	
	НайденныеЗадания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	Для Каждого Задание Из НайденныеЗадания Цикл
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, Новый Структура("Использование", Ложь));
		ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

Процедура ВключитьОтключенныеРегламентныеЗадания(ПараметрыБлокировки)
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Для Каждого ИдентификаторЗадания Из ПараметрыБлокировки.ОтключенныеЗадания Цикл
		
		Если РазделениеВключено = (ТипЗнч(ИдентификаторЗадания) = Тип("УникальныйИдентификатор")) Тогда
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура;
		Отбор.Вставить("УникальныйИдентификатор", ИдентификаторЗадания);
		Отбор.Вставить("Использование", Ложь);
		
		НайденныеЗадания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
		
		Для Каждого Задание Из НайденныеЗадания Цикл
			РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, Новый Структура("Использование", Истина));
			ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.УникальныйИдентификатор);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// АПК:453-вкл

#КонецОбласти

#Область ФайлПроверкиИдентификатораФайловойБазы

Функция ФайлПроверкиИдентификатораФайловойБазыСуществует()
	
	ФайлИнфо = Новый Файл(ПутьКФайлуПроверкиИдентификатораФайловойБазы());
	Возврат ФайлИнфо.Существует();
	
КонецФункции

Функция ИдентификаторФайловойБазыИзФайлаПроверки()
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлуПроверкиИдентификатораФайловойБазы());
	ИдентификаторБазы = ЧтениеТекста.ПрочитатьСтроку();
	ЧтениеТекста.Закрыть();
	Возврат ИдентификаторБазы;
	
КонецФункции

Процедура ЗаписатьИдентификаторФайловойБазыВФайлПроверки(ИдентификаторБазы)
	
	СодержимоеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1
		           |
		           |Файл создан автоматически прикладным решением ""%2"".
		           |Он содержит идентификатор информационной базы и позволяет определить, что эта информационная база была скопирована.
		           |
		           |При копировании файлов информационной базы, в том числе при создании резервной копии, не следует копировать этот файл.
		           |Одновременное использование двух копий информационной базы с одинаковым идентификатором может привести к конфликтам
		           |при синхронизации данных, отправке почты и другой работе с внешними ресурсами.
		           |
		           |Если файл отсутствует в папке с информационной базой, то программа запросит администратора, разрешено 
		           |ли ей работать с внешними ресурсами.'"), 
		ИдентификаторБазы, 
		Метаданные.Синоним);
	
	ИмяФайла = ПутьКФайлуПроверкиИдентификатораФайловойБазы();
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла);
	Попытка
		ЗаписьТекста.Записать(СодержимоеФайла);
	Исключение
		ЗаписьТекста.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Функция ПутьКФайлуПроверкиИдентификатораФайловойБазы()
	
	Возврат ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы() + ПолучитьРазделительПути() + "DoNotCopy.txt";
	
КонецФункции

#КонецОбласти

#Область УстановкаБлокировки

Функция УстановитьБлокировкуРаботыСВнешнимиРесурсами()
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыБлокировки = СохраненныеПараметрыБлокировки();
	
	Если ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Неопределено Тогда
		Возврат Истина; // Установлен признак необходимости принятия решения о блокировке.
	ИначеЕсли ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Истина Тогда
		Возврат Истина; // Блокировка работы с внешними ресурсами подтверждена администратором.
	КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	Если РазделениеВключено Тогда
		Возврат Ложь; // При работе в модели сервиса факт переноса базы определяется менеджером сервиса.
	КонецЕсли;
	
	// Ниже код с учетом того, что разделение не включено.
	
	ИзменилосьРазделение = ПараметрыБлокировки.РазделениеВключено <> РазделениеВключено;
	
	Если ИзменилосьРазделение Тогда
		ТекстСообщения = НСтр("ru = 'Информационная база была перемещена из приложения в Интернете.'");
		УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);
		Возврат Истина;
	КонецЕсли;
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	Если СтрокаСоединения = ПараметрыБлокировки.СтрокаСоединения Тогда
		Возврат Ложь; // Если строка соединения совпадает, то дальнейшую проверку не выполняем.
	КонецЕсли;
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ПеремещенаМеждуФайловымИКлиентСервернымРежимом = ЭтоФайловаяБаза <> ПараметрыБлокировки.ЭтоФайловаяБаза;
	
	Если ПеремещенаМеждуФайловымИКлиентСервернымРежимом Тогда
		ТекстСообщения = 
			?(ЭтоФайловаяБаза, 
				НСтр("ru = 'Информационная база была перемещена из клиент-серверного режима работы в файловый.'"),
				НСтр("ru = 'Информационная база была перемещена из файловый режима работы в клиент-серверный.'"));
		УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);
		Возврат Истина;
	КонецЕсли;
	
	// Ниже код с учетом того, что режим работы не менялся:
	// 1. была файловая осталась файловая;
	// 2. была клиент-серверная осталась клиент-серверная.
	
	Если ЭтоФайловаяБаза Тогда
		
		// Для файловой базы строка соединения может быть разной при подключении с различных компьютеров,
		// поэтому проверку перемещения базы осуществляем через файл проверки.
		
		Если Не ФайлПроверкиИдентификатораФайловойБазыСуществует() Тогда
			ТекстСообщения = НСтр("ru = 'В папке информационной базы отсутствует файл проверки DoNotCopy.txt.'");
			УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);
			Возврат Истина;
		КонецЕсли;
		
		ИзменилсяИдентификаторИнформационнойБазы = ИдентификаторФайловойБазыИзФайлаПроверки() <> ПараметрыБлокировки.ИдентификаторБазы;
		
		Если ИзменилсяИдентификаторИнформационнойБазы Тогда
			ТекстСообщения = 
				НСтр("ru = 'Идентификатор информационной базы в файле проверки DoNotCopy.txt не соответствует идентификатору в текущей базе.'");
			УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);
			Возврат Истина;
		КонецЕсли;
		
	Иначе // Клиент-серверная база
		
		ИмяБазы = НРег(СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаСоединения).Ref);
		ИмяСервераМенеджераПодключений = НРег(СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаСоединения).Srvr);
		ИмяСервераРабочегоПроцесса = НРег(ИмяКомпьютера());
		
		СохраненноеИмяБазы = 
			НРег(СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ПараметрыБлокировки.СтрокаСоединения).Ref);
		СохраненноеИмяСервераМенеджераПодключений = 
			НРег(СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ПараметрыБлокировки.СтрокаСоединения).Srvr);
		СохраненноеИмяСервераРабочегоПроцесса = НРег(ПараметрыБлокировки.ИмяКомпьютера);
		
		ИзменилосьИмяБазы = ИмяБазы <> СохраненноеИмяБазы;
		ИзменилосьИмяКомпьютера = ПараметрыБлокировки.ПроверятьИмяСервера
			И ИмяСервераРабочегоПроцесса <> СохраненноеИмяСервераРабочегоПроцесса
			И СтрНайти(СохраненноеИмяСервераМенеджераПодключений, ИмяСервераМенеджераПодключений) = 0;
		
		// В случае масштабируемого кластера СохраненноеИмяСервераМенеджераПодключений может содержать имена
		// нескольких серверов, которые могут выступать в роли менеджера подключения
		// при этом ИмяСервераМенеджераПодключений при запуске сеанса регламентного задания будет содержать имя 
		// текущего активного менеджера. Чтобы обыграть эту ситуацию ищется вхождение текущего в сохраненном имени.
		
		Если ИзменилосьИмяБазы Или ИзменилосьИмяКомпьютера Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Изменились параметры контроля уникальности клиент-серверной базы.
				           |
				           |Было:
				           |Строка соединения: <%1>
				           |Имя компьютера: <%2>
				           |
				           |Стало:
				           |Строка соединения: <%3>
				           |Имя компьютера: <%4>
				           |
				           |Проверять имя сервера: <%5>'"),
				ПараметрыБлокировки.СтрокаСоединения, 
				СохраненноеИмяСервераРабочегоПроцесса,
				СтрокаСоединения,
				ИмяСервераРабочегоПроцесса,
				ПараметрыБлокировки.ПроверятьИмяСервера);
			
			УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения)
	
	ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Неопределено;
	ПараметрыБлокировки.ПричинаБлокировки = ПредставлениеПричиныБлокировки(ПараметрыБлокировки);
	СохранитьПараметрыБлокировки(ПараметрыБлокировки);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		МодульОбсужденияСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбсужденияСлужебный");
		МодульОбсужденияСлужебный.Заблокировать();
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
	
КонецПроцедуры

Функция ПредставлениеПричиныБлокировки(ПараметрыБлокировки)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Блокировка выполнена на сервере <b>%1</b> в <b>%2</b> %3.
		           |
		           |Размещение информационной базы изменилось с
		           |<b>%4</b>
		           |на 
		           |<b>%5</b>'"),
		ИмяКомпьютера(),
		ТекущаяДата(), // АПК:143 Информация о блокировке нужна в дате сервера.
		ПредставлениеТекущейОперации(),
		ПредставлениеСтрокиСоединения(ПараметрыБлокировки.СтрокаСоединения),
		ПредставлениеСтрокиСоединения(СтрокаСоединенияИнформационнойБазы()));
	
КонецФункции

Функция ПредставлениеТекущейОперации()
	
	ТекущийСеансИнформационнойБазы = ПолучитьТекущийСеансИнформационнойБазы();
	ФоновоеЗадание = ТекущийСеансИнформационнойБазы.ПолучитьФоновоеЗадание();
	ЭтоСеансРегламентногоЗадания = ФоновоеЗадание <> Неопределено И ФоновоеЗадание.РегламентноеЗадание <> Неопределено;
	
	Если ЭтоСеансРегламентногоЗадания Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'при попытке выполнения регламентного задания <b>%1</b>'"),
			ФоновоеЗадание.РегламентноеЗадание.Наименование);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'при входе пользователя <b>%1</b>'"),
		ИмяПользователя());
	
КонецФункции

Функция ПредставлениеСтрокиСоединения(СтрокаСоединения)
	
	Результат = СтрокаСоединения;
	
	Параметры = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаСоединения);
	Если Параметры.Свойство("File") Тогда
		Результат = Параметры.File;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации() Экспорт 
	
	Возврат НСтр("ru = 'Работа с внешними ресурсами заблокирована'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#КонецОбласти