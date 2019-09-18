﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийИдентификаторНеуказанногоПользователя;
Перем ИсходныйИдентификаторНеуказанногоПользователя;
Перем СохраненныеСсылкиНаНеуказанногоПользователя;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиВыгрузкиДанных

Процедура ПередВыгрузкойДанных(Контейнер) Экспорт
	
	ТекущийИдентификаторНеуказанногоПользователя = ПользователиСлужебный.СоздатьНеуказанногоПользователя().УникальныйИдентификатор();
	
	ИмяФайла = Контейнер.СоздатьПроизвольныйФайл("xml", ТипДанныхДляВыгрузкиИдентификатораНеуказанногоПользователя());
	ЗаписатьОбъектВФайл(ТекущийИдентификаторНеуказанногоПользователя, ИмяФайла);
	
КонецПроцедуры

// Вызывается перед выгрузкой объекта.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	Если ТипЗнч(Объект) <> Тип("СправочникОбъект.Пользователи") Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком ВыгрузкаЗагрузкаДанныхСверткаСсылокНаПользователейВРазделенныхДанных.ПередВыгрузкойОбъекта.'"),
			Объект.Метаданные().ПолноеИмя());
	КонецЕсли;
		
	Если Объект.Ссылка.УникальныйИдентификатор() = ТекущийИдентификаторНеуказанногоПользователя Тогда
		
		НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактНеуказанногоПользователя());
		Артефакты.Добавить(НовыйАртефакт);
		
	ИначеЕсли ПользователиСлужебныйВМоделиСервиса.ПользовательЗарегистрированКакНеразделенный(Объект.ИдентификаторПользователяИБ) Тогда
		
		НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактНеразделенногоПользователя());
		НовыйАртефакт.UserName = ВнутреннееИмяНеразделенногоПользователя(Объект.ИдентификаторПользователяИБ);
		Артефакты.Добавить(НовыйАртефакт);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыгрузкиОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты) Экспорт
	
	Если ТипЗнч(Объект) <> Тип("СправочникОбъект.Пользователи") Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком ВыгрузкаЗагрузкаДанныхСверткаСсылокНаПользователейВРазделенныхДанных.ПослеВыгрузкиОбъекта.'"),
			Объект.Метаданные().ПолноеИмя());
	КонецЕсли;
		
	Если Объект.Ссылка.УникальныйИдентификатор() <> ТекущийИдентификаторНеуказанногоПользователя Тогда
		
		ЭтоСсылкаНеразделенногоПользователя = ПользователиСлужебныйВМоделиСервиса.ПользовательЗарегистрированКакНеразделенный(
			Объект.ИдентификаторПользователяИБ);
		
		ЕстественныйКлюч = Новый Структура("Неразделенный", ЭтоСсылкаНеразделенногоПользователя);
		МенеджерВыгрузкиОбъекта.ТребуетсяСопоставитьСсылкуПриЗагрузке(Объект.Ссылка, ЕстественныйКлюч);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЗагрузкиДанных

// Вызывается перед загрузкой данных.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	ТекущийИдентификаторНеуказанногоПользователя = ПользователиСлужебный.СоздатьНеуказанногоПользователя().УникальныйИдентификатор();
	
	ИмяФайла = Контейнер.ПолучитьПроизвольныйФайл(ТипДанныхДляВыгрузкиИдентификатораНеуказанногоПользователя());
	ИсходныйИдентификаторНеуказанногоПользователя = ПрочитатьОбъектИзФайла(ИмяФайла);
	
КонецПроцедуры

Процедура ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, Отказ) Экспорт
	
	Если ОбъектМетаданных = Метаданные.Справочники.Пользователи Тогда
		
		СтандартнаяОбработка = Ложь;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Тип данных указан неверно'");
		
	КонецЕсли;
	
КонецПроцедуры

Функция СопоставитьСсылки(Контейнер, МенеджерСопоставленияСсылок, ТаблицаИсходныхСсылок) Экспорт
	
	ИмяКолонки = МенеджерСопоставленияСсылок.ИмяКолонкиИсходныхСсылок();
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	Результат.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	СопоставлениеНеуказанногоПользователя = Результат.Добавить();
	СопоставлениеНеуказанногоПользователя[ИмяКолонки] =
		Справочники.Пользователи.ПолучитьСсылку(ИсходныйИдентификаторНеуказанногоПользователя);
	СопоставлениеНеуказанногоПользователя.Ссылка =
		Справочники.Пользователи.ПолучитьСсылку(ТекущийИдентификаторНеуказанногоПользователя);
	
	ОбъединитьНеразделенныхПользователей = Ложь;
	ОбъединитьРазделенныхПользователей = Ложь;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Если Контейнер.ПараметрыЗагрузки().Свойство("СвернутьРазделенныхПользователей") Тогда
			ОбъединитьРазделенныхПользователей = Контейнер.ПараметрыЗагрузки().СвернутьРазделенныхПользователей;
		Иначе
			ОбъединитьРазделенныхПользователей = Ложь;
		КонецЕсли;
		
	Иначе
		ОбъединитьНеразделенныхПользователей = Истина;
		ОбъединитьРазделенныхПользователей = Ложь;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицыИсходныхСсылок Из ТаблицаИсходныхСсылок Цикл
		
		Если СтрокаТаблицыИсходныхСсылок.Неразделенный Тогда
			
			Если ОбъединитьНеразделенныхПользователей Тогда
				
				СопоставлениеПользователя = Результат.Добавить();
				СопоставлениеПользователя[ИмяКолонки] = СтрокаТаблицыИсходныхСсылок[ИмяКолонки];
				СопоставлениеПользователя.Ссылка =
					Справочники.Пользователи.ПолучитьСсылку(ТекущийИдентификаторНеуказанногоПользователя);
				
			КонецЕсли;
			
		Иначе
			
			Если ОбъединитьРазделенныхПользователей Тогда
				
				СопоставлениеПользователя = Результат.Добавить();
				СопоставлениеПользователя[ИмяКолонки] = СтрокаТаблицыИсходныхСсылок[ИмяКолонки];
				СопоставлениеПользователя.Ссылка =
					Справочники.Пользователи.ПолучитьСсылку(ТекущийИдентификаторНеуказанногоПользователя);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполняет обработчики перед загрузкой определенного типа данных.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
//	Отказ - Булево - признак выполнения данной операции.
//
Процедура ПередЗагрузкойТипа(Контейнер, ОбъектМетаданных, Отказ) Экспорт
	
	Если ПользователиСлужебныйВМоделиСервисаПовтИсп.СписокНаборовЗаписейСоСсылкамиНаПользователей().Получить(ОбъектМетаданных) <> Неопределено Тогда
		
		СохраненныеСсылкиНаНеуказанногоПользователя = Новый ТаблицаЗначений();
		
		Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
			
			СохраненныеСсылкиНаНеуказанногоПользователя.Колонки.Добавить(Измерение.Имя, Измерение.Тип);
			
		КонецЦикла;
		
	Иначе
		
		СохраненныеСсылкиНаНеуказанногоПользователя = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.Пользователи") Тогда
		
		// Справочник Пользователи
		ЭтоИсходныйНеуказанныйПользователь = Ложь;
		
		Для Каждого Артефакт Из Артефакты Цикл
			
			Если Артефакт.Тип() = ТипАртефактНеразделенногоПользователя() Тогда
				
				ВнутреннееИмя = Артефакт.UserName;
				Идентификатор = ИдентификаторСлужебногоПользователяПоВнутреннемуИмени(ВнутреннееИмя);
				
				Если ПользователиСлужебныйВМоделиСервиса.ПользовательЗарегистрированКакНеразделенный(Идентификатор) Тогда
					
					Объект.ИдентификаторПользователяИБ = Идентификатор;
					Объект.Наименование = ПользователиСлужебныйВМоделиСервиса.ПолноеИмяСлужебногоПользователя(Идентификатор);
					
				КонецЕсли;
				
			ИначеЕсли Артефакт.Тип() = ТипАртефактНеуказанногоПользователя() Тогда
				
				ЭтоИсходныйНеуказанныйПользователь = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Объект.Ссылка.УникальныйИдентификатор() = ТекущийИдентификаторНеуказанногоПользователя И Не ЭтоИсходныйНеуказанныйПользователь Тогда
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли ПользователиСлужебныйВМоделиСервисаПовтИсп.СписокНаборовЗаписейСоСсылкамиНаПользователей().Получить(Объект.Метаданные()) <> Неопределено Тогда
		
		// Набор записей, содержащий измерение с типом СправочникСсылка.Пользователи
		СвернутьСсылкиНаПользователейВНаборе(Объект);
		
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком ВыгрузкаЗагрузкаДанныхСверткаСсылокНаПользователейВРазделенныхДанных.ПередЗагрузкойОбъекта.'"),
			Объект.Метаданные().ПолноеИмя());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипДанныхДляВыгрузкиИдентификатораНеуказанногоПользователя()
	
	Возврат "1cfresh\ApplicationData\DefaultUserRef";
	
КонецФункции

Функция ТипАртефактНеразделенногоПользователя() 
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "UnseparatedUser");
	
КонецФункции

Функция ТипАртефактНеуказанногоПользователя()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "UndefinedUser");
	
КонецФункции

Функция Пакет()
	
	Возврат "http://www.1c.ru/1cFresh/Data/Artefacts/ServiceUsers/1.0.0.1";
	
КонецФункции

Функция ВнутреннееИмяНеразделенногоПользователя(Знач Идентификатор)
	
	Менеджер = РегистрыСведений.НеразделенныеПользователи.СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторПользователяИБ = Идентификатор;
	Менеджер.Прочитать();
	Если Менеджер.Выбран() Тогда
		Возврат Менеджер.ИмяПользователя;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ИдентификаторСлужебногоПользователяПоВнутреннемуИмени(Знач ВнутреннееИмя)
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	НеразделенныеПользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
		|ИЗ
		|	РегистрСведений.НеразделенныеПользователи КАК НеразделенныеПользователи
		|ГДЕ
		|	НеразделенныеПользователи.ИмяПользователя = &ИмяПользователя";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИмяПользователя", ВнутреннееИмя);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ИдентификаторПользователяИБ;
	КонецЕсли;
	
КонецФункции

Процедура СвернутьСсылкиНаПользователейВНаборе(НаборЗаписей)
	
	СсылкаНеуказанногоПользователя = Справочники.Пользователи.ПолучитьСсылку(ТекущийИдентификаторНеуказанногоПользователя);
	
	УдаляемыеЗаписи = Новый Массив();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		
		ОтборСтрокСостояния = Новый Структура();
		
		Для Каждого Измерение Из НаборЗаписей.Метаданные().Измерения Цикл
			
			ПроверяемоеЗначение = Запись[Измерение.Имя];
			
			Если ЗначениеЗаполнено(ПроверяемоеЗначение) Тогда
				
				Если ТипЗнч(ПроверяемоеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
					
					Если ПроверяемоеЗначение = СсылкаНеуказанногоПользователя Тогда
						
						ОтборСтрокСостояния.Вставить(Измерение.Имя, ПроверяемоеЗначение);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОтборСтрокСостояния.Количество() > 0 Тогда
			
			Если СохраненныеСсылкиНаНеуказанногоПользователя.НайтиСтроки(ОтборСтрокСостояния).Количество() = 0 Тогда
				
				СтрокаСостояния = СохраненныеСсылкиНаНеуказанногоПользователя.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаСостояния, Запись);
				
			Иначе
				
				УдаляемыеЗаписи.Добавить(Запись);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого УдаляемаяЗапись Из УдаляемыеЗаписи Цикл
		
		НаборЗаписей.Удалить(УдаляемаяЗапись);
		
	КонецЦикла;
	
КонецПроцедуры

// Записывает объект в файл.
//
// Параметры:
//	Объект - записываемый объект.
//	ИмяФайла - Строка - путь к файлу.
//	Сериализатор - СериализаторXDTO - сериализатор.
//
Процедура ЗаписатьОбъектВФайл(Знач Объект, Знач ИмяФайла, Сериализатор = Неопределено)
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	
	ЗаписатьОбъектВПоток(Объект, ПотокЗаписи, Сериализатор);
	
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

// Записывает объект в поток записи.
//
// Параметры:
//	Объект - записываемый объект.
//	ПотокЗаписи - ЗаписьXML - поток записи.
//	Сериализатор - СериализаторXDTO - сериализатор.
//
Процедура ЗаписатьОбъектВПоток(Знач Объект, ПотокЗаписи, Сериализатор = Неопределено)
	
	Если Сериализатор = Неопределено Тогда
		Сериализатор = СериализаторXDTO;
	КонецЕсли;
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Data");
	
	ПрефиксыПространствИмен = ПрефиксыПространствИмен();
	Для Каждого ПрефиксПространстваИмен Из ПрефиксыПространствИмен Цикл
		ПотокЗаписи.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен.Значение, ПрефиксПространстваИмен.Ключ);
	КонецЦикла;
	
	Сериализатор.ЗаписатьXML(ПотокЗаписи, Объект, НазначениеТипаXML.Явное);
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

// Возвращает объект из файла.
//
// Параметры:
//	ИмяФайла - Строка - путь к файлу.
//
// Возвращаемое значение:
//	Объект - .
//
Функция ПрочитатьОбъектИзФайла(Знач ИмяФайла)
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Объект = ПрочитатьОбъектИзПотока(ПотокЧтения);
	
	ПотокЧтения.Закрыть();
	
	Возврат Объект;
	
КонецФункции

// Возвращает объект из файла.
//
// Параметры:
//	ПотокЧтения - ЧтениеXML - поток чтения.
//
// Возвращаемое значение:
//	Объект - .
//
Функция ПрочитатьОбъектИзПотока(ПотокЧтения)
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента Или ПотокЧтения.Имя <> "Data" Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"),
			"Data");
	КонецЕсли;
	
	Если НЕ ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	Объект = СериализаторXDTO.ПрочитатьXML(ПотокЧтения);
	Возврат Объект;
	
КонецФункции

// Возвращает префиксы для часто используемых пространств имен.
//
// Возвращаемое значение:
//	Соответствие:
//	Ключ - Строка - пространство имени.
//	Значение - Строка - префикс.
//
Функция ПрефиксыПространствИмен() Экспорт
	
	Результат = Новый Соответствие();
	
	Результат.Вставить("http://www.w3.org/2001/XMLSchema", "xs");
	Результат.Вставить("http://www.w3.org/2001/XMLSchema-instance", "xsi");
	Результат.Вставить("http://v8.1c.ru/8.1/data/core", "v8");
	Результат.Вставить("http://v8.1c.ru/8.1/data/enterprise", "ns");
	Результат.Вставить("http://v8.1c.ru/8.1/data/enterprise/current-config", "cc");
	Результат.Вставить("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "dmp");
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли