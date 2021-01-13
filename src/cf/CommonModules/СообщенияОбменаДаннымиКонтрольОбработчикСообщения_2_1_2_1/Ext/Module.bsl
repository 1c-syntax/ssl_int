﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пространство имен версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Control";
	
КонецФункции

// Версия интерфейса сообщений, обслуживаемая обработчиком.
//
// Возвращаемое значение:
//   Строка - версия интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Базовый тип для сообщений версии.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - базовый тип тела сообщения.
//
Функция БазовыйТип() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует менеджер сервиса.'");
	КонецЕсли;
	
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Возврат МодульСообщенияВМоделиСервиса.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//   Сообщение   - ОбъектXDTO - входящее сообщение.
//   Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения.
//   СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//                         установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияОбменаДаннымиКонтрольИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеНастройкаОбменаШаг1УспешноЗавершена(Пакет()) Тогда
		
		НастройкаОбменаШаг1УспешноЗавершена(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеНастройкаОбменаШаг2УспешноЗавершена(Пакет()) Тогда
		
		НастройкаОбменаШаг2УспешноЗавершена(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаНастройкиОбменаШаг1(Пакет()) Тогда
		
		ОшибкаНастройкиОбменаШаг1(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаНастройкиОбменаШаг2(Пакет()) Тогда
		
		ОшибкаНастройкиОбменаШаг2(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеЗагрузкаСообщенияОбменаУспешноЗавершена(Пакет()) Тогда
		
		ЗагрузкаСообщенияОбменаУспешноЗавершена(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаЗагрузкиСообщенияОбмена(Пакет()) Тогда
		
		ОшибкаЗагрузкиСообщенияОбмена(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучениеДанныхКорреспондентаУспешноЗавершено(Пакет()) Тогда
		
		ПолучениеДанныхКорреспондентаУспешноЗавершено(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено(Пакет()) Тогда
		
		ПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаПолученияДанныхКорреспондента(Пакет()) Тогда
		
		ОшибкаПолученияДанныхКорреспондента(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаПолученияОбщихДанныхУзловКорреспондента(Пакет()) Тогда
		
		ОшибкаПолученияОбщихДанныхУзловКорреспондента(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучениеПараметровУчетаКорреспондентаУспешноЗавершено(Пакет()) Тогда
		
		ПолучениеПараметровУчетаКорреспондентаУспешноЗавершено(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаПолученияПараметровУчетаКорреспондента(Пакет()) Тогда
		
		ОшибкаПолученияПараметровУчетаКорреспондента(Сообщение, Отправитель);
		
	Иначе
		
		СообщениеОбработано = Ложь;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Настройка обмена

Процедура НастройкаОбменаШаг1УспешноЗавершена(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеНастройкаСинхронизацииШаг1());
	
КонецПроцедуры

Процедура НастройкаОбменаШаг2УспешноЗавершена(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеНастройкаСинхронизацииШаг2());
	
КонецПроцедуры

Процедура ОшибкаНастройкиОбменаШаг1(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеНастройкаСинхронизацииШаг1());
	
КонецПроцедуры

Процедура ОшибкаНастройкиОбменаШаг2(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеНастройкаСинхронизацииШаг2());
	
КонецПроцедуры

Процедура ЗагрузкаСообщенияОбменаУспешноЗавершена(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеЗагрузкаСообщенияОбмена());
	
КонецПроцедуры

Процедура ОшибкаЗагрузкиСообщенияОбмена(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеЗагрузкаСообщенияОбмена());
	
КонецПроцедуры

// Получение данных корреспондента

Процедура ПолучениеДанныхКорреспондентаУспешноЗавершено(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.СохранитьДанныеСессии(Сообщение, ПредставлениеПолучениеДанныхКорреспондента());
	
КонецПроцедуры

Процедура ПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.СохранитьДанныеСессии(Сообщение, ПредставлениеПолучениеОбщихДанныхУзловКорреспондента());
	
КонецПроцедуры

Процедура ОшибкаПолученияДанныхКорреспондента(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеПолучениеДанныхКорреспондента());
	
КонецПроцедуры

Процедура ОшибкаПолученияОбщихДанныхУзловКорреспондента(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеПолучениеОбщихДанныхУзловКорреспондента());
	
КонецПроцедуры

// Получение параметров учета корреспондента

Процедура ПолучениеПараметровУчетаКорреспондентаУспешноЗавершено(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.СохранитьДанныеСессии(Сообщение, ПредставлениеПолучениеПараметровУчетаКорреспондента());
	
КонецПроцедуры

Процедура ОшибкаПолученияПараметровУчетаКорреспондента(Сообщение, Отправитель)
	
	ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеПолучениеПараметровУчетаКорреспондента());
	
КонецПроцедуры

// Вспомогательные функции

Функция ПредставлениеНастройкаСинхронизацииШаг1()
	
	Возврат НСтр("ru = 'Настройка синхронизации, шаг 1.'");
	
КонецФункции

Функция ПредставлениеНастройкаСинхронизацииШаг2()
	
	Возврат НСтр("ru = 'Настройка синхронизации, шаг 2.'");
	
КонецФункции

Функция ПредставлениеЗагрузкаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Загрузка сообщения обмена.'");
	
КонецФункции

Функция ПредставлениеПолучениеДанныхКорреспондента()
	
	Возврат НСтр("ru = 'Получение данных корреспондента.'");
	
КонецФункции

Функция ПредставлениеПолучениеОбщихДанныхУзловКорреспондента()
	
	Возврат НСтр("ru = 'Получение общих данных узлов корреспондента.'");
	
КонецФункции

Функция ПредставлениеПолучениеПараметровУчетаКорреспондента()
	
	Возврат НСтр("ru = 'Получение параметров учета корреспондента.'");
	
КонецФункции

#КонецОбласти
