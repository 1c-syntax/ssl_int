﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ТекстСостояния - Строка
//  КартинкаСостояния - Картинка
//                    - Неопределено
//
Процедура ОтобразитьСостояниеОтчета(Форма, Знач ТекстСостояния = "", Знач КартинкаСостояния = Неопределено) Экспорт 
	
	ПолеОтчета = Форма.Элементы.Найти("РезультатОтчета");
	Если ПолеОтчета = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ОтображатьСостояние = Не ПустаяСтрока(ТекстСостояния);
	
	Если КартинкаСостояния = Неопределено Или Не ОтображатьСостояние Тогда 
		КартинкаСостояния = Новый Картинка;
	КонецЕсли;
	
	РежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	Если ОтображатьСостояние Тогда 
		РежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	КонецЕсли;
	
	ОтображениеСостояния = ПолеОтчета.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = ОтображатьСостояние;
	ОтображениеСостояния.ДополнительныйРежимОтображения = РежимОтображения;
	ОтображениеСостояния.Картинка = КартинкаСостояния;
	ОтображениеСостояния.Текст = ТекстСостояния;

	ПолеОтчета.ТолькоПросмотр = ОтображатьСостояние 
		Или ПолеОтчета.Вывод = ИспользованиеВывода.Запретить;
	
КонецПроцедуры

// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  СвойстваЗаголовка - см. ВариантыОтчетовСлужебный.СтандартныеСвойстваЗаголовкаОтчета
//
Процедура ОпределитьДоступностьДействийКонтекстногоМеню(Форма, СвойстваЗаголовка) Экспорт 
	
	Если ТипЗнч(СвойстваЗаголовка) <> Тип("Структура") Тогда 
		Возврат;
	КонецЕсли;
	
	ДействияКонтекстногоМеню = ДействияКонтекстногоМенюОбластиЗаголовка();
	
	Для Каждого Действие Из ДействияКонтекстногоМеню Цикл 
		Форма.Элементы[Действие.Ключ].Доступность = СвойстваЗаголовка[Действие.Значение];
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  Поля - ПоляГруппировкиКомпоновкиДанных
//       - ВыбранныеПоляКомпоновкиДанных
//  Поле - ПолеКомпоновкиДанных
//  ПроверятьИспользование - Булево
//  Содержится - Булево
//
// Возвращаемое значение:
//  Булево
//
Функция ПолеСодержитсяВГруппировкеОтчета(Поля, Поле, ПроверятьИспользование = Истина, Содержится = Ложь) Экспорт 
	
	Возврат ПолеОтчета(Поля, Поле, ПроверятьИспользование) <> Неопределено;
	
КонецФункции

// Параметры:
//  Родитель - ГруппировкаКомпоновкиДанных
//           - ГруппировкаТаблицыКомпоновкиДанных
//  Поле - ПолеКомпоновкиДанных
//  Содержится - Булево
//
// Возвращаемое значение:
//  Булево
//
Функция ПолеИспользуетсяВРодительскихГруппировкахОтчета(Родитель, Поле, Содержится = Ложь) Экспорт 
	
	Если (ТипЗнч(Родитель) = Тип("ГруппировкаКомпоновкиДанных")
		Или ТипЗнч(Родитель) = Тип("ГруппировкаТаблицыКомпоновкиДанных")) Тогда 
		
		Если ПолеСодержитсяВГруппировкеОтчета(Родитель.ПоляГруппировки, Поле) Тогда 
			Содержится = Истина;
		Иначе
			ПолеИспользуетсяВРодительскихГруппировкахОтчета(Родитель.Родитель, Поле, Содержится);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Содержится;
	
КонецФункции

// Параметры:
//  Поля - ВыбранныеПоляКомпоновкиДанных
//       - ПоляГруппировкиКомпоновкиДанных
//  Поле - ПолеКомпоновкиДанных
//  ПроверятьИспользование - Булево
//  ПолеОтчета - ВыбранноеПолеКомпоновкиДанных
//             - ПолеГруппировкиКомпоновкиДанных
//             - Неопределено
//
// Возвращаемое значение:
//  ВыбранноеПолеКомпоновкиДанных
//  ПолеГруппировкиКомпоновкиДанных
//  Неопределено
//
Функция ПолеОтчета(Поля, Поле, ПроверятьИспользование = Истина, ПолеОтчета = Неопределено) Экспорт 
	
	НайтиПолеОтчета(Поля, Поле, ПроверятьИспользование, ПолеОтчета);
	
	Возврат ПолеОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДействияКонтекстногоМенюОбластиЗаголовка()
	
	Действия = Новый Соответствие;
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаВставитьПолеСправа", "ВставитьПолеСправа");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаВставитьГруппировкуНиже", "ВставитьГруппировкуНиже");
	
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаПереместитьПолеВлево", "ПереместитьПолеВлево");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаПереместитьПолеВправо", "ПереместитьПолеВправо");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаПереместитьПолеВыше", "ПереместитьПолеВыше");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаПереместитьПолеНиже", "ПереместитьПолеНиже");
	
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаСортироватьПоВозрастанию", "СортироватьПоВозрастанию");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаСортироватьПоУбыванию", "СортироватьПоУбыванию");
	
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаСкрытьПоле", "СкрытьПоле");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаПереименоватьПоле", "ПереименоватьПоле");
	
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаОформитьОтрицательные", "ОформитьОтрицательные");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаОформитьПоложительные", "ОформитьПоложительные");
	Действия.Вставить("КонтекстноеМенюОбластиЗаголовкаМенюОформитьЕще", "ОформитьЕще");
	
	Возврат Действия;
	
КонецФункции

#Область Фильтры

// Параметры:
//  Настройки - НастройкиКомпоновкиДанных
//  СвойстваЗаголовка - см. ВариантыОтчетовСлужебный.СтандартныеСвойстваЗаголовкаОтчета
//
Функция ГруппировкаФильтра(Настройки, СвойстваЗаголовка) Экспорт 
	
	Если СвойстваЗаголовка.ИдентификаторНастроек = Неопределено Тогда 
		Возврат Настройки;
	КонецЕсли;
	
	ИспользуемыеНастройки = Настройки.ПолучитьОбъектПоИдентификатору(
		СвойстваЗаголовка.ИдентификаторНастроек);
	
	Если ИспользуемыеНастройки = Неопределено Тогда 
		ИспользуемыеНастройки = Настройки;
	КонецЕсли;
	
	Если СвойстваЗаголовка.КоличествоРазделов = 1 Тогда 
		Раздел = ИспользуемыеНастройки;
	Иначе
		Раздел = ИспользуемыеНастройки.ПолучитьОбъектПоИдентификатору(СвойстваЗаголовка.ИдентификаторРаздела);
	КонецЕсли;
	
	Если ТипЗнч(Раздел) = Тип("ТаблицаКомпоновкиДанных") Тогда 
		
		Если СтрНайти(СвойстваЗаголовка.ИдентификаторГруппировки, "/column/") > 0
			И Раздел.Строки.Количество() > 0 Тогда 
			
			Возврат Раздел.Строки[0];
			
		Иначе
			
			Группировка = ИспользуемыеНастройки.ПолучитьОбъектПоИдентификатору(СвойстваЗаголовка.ИдентификаторГруппировки);
			Возврат Группировка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Раздел;
	
КонецФункции

// Параметры:
//  Настройки - НастройкиКомпоновкиДанных
//  СвойстваЗаголовка - см. ВариантыОтчетовСлужебный.СтандартныеСвойстваЗаголовкаОтчета
//
// Возвращаемое значение:
//  ОтборКомпоновкиДанных
//
Функция ФильтрыРазделаОтчета(Настройки, СвойстваЗаголовка) Экспорт 
	
	ГруппировкаФильтра = ГруппировкаФильтра(Настройки, СвойстваЗаголовка);
	Возврат ГруппировкаФильтра.Отбор;
	
КонецФункции

// Параметры:
//  Фильтры - ОтборКомпоновкиДанных
//  Поле - ПолеКомпоновкиДанных
//
// Возвращаемое значение:
//  ЭлементОтбораКомпоновкиДанных
//  Неопределено
//
Функция ФильтрРазделаОтчета(Фильтры, Поле) Экспорт 
	
	Для Каждого Элемент Из Фильтры.Элементы Цикл 
		
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда 
			
			ЭлементыГруппы = Элемент.Элементы;
			
			Если ЭлементыГруппы.Количество() = 2
				Или ЭлементыГруппы[0].ЛевоеЗначение = Поле
				Или ЭлементыГруппы[1].ЛевоеЗначение = Поле Тогда 
				
				Возврат Элемент;
			КонецЕсли;
			
		ИначеЕсли Элемент.ЛевоеЗначение = Поле Тогда 
			
			Возврат Элемент;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область ПоискПоля

// Параметры:
//  Поля - ВыбранныеПоляКомпоновкиДанных
//       - ПоляГруппировкиКомпоновкиДанных
//  Поле - ПолеКомпоновкиДанных
//  НайденноеПоле - ВыбранноеПолеКомпоновкиДанных
//                - ПолеГруппировкиКомпоновкиДанных
//                - Неопределено
//
Процедура НайтиПолеОтчета(Поля, Поле, ПроверятьИспользование, НайденноеПоле)
	
	Для Каждого Элемент Из Поля.Элементы Цикл 
		
		ТипЭлемента = ТипЗнч(Элемент);
		
		Если ТипЭлемента <> Тип("АвтоВыбранноеПолеКомпоновкиДанных")
			И Элемент.Поле = Поле
			И (Не ПроверятьИспользование Или ПроверятьИспользование И Элемент.Использование) Тогда 
			
			НайденноеПоле = Элемент;
			Возврат;
			
		ИначеЕсли ТипЭлемента = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда 
			
			НайтиПолеОтчета(Элемент, Поле, ПроверятьИспользование, НайденноеПоле);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти