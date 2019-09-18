﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - 
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Management/" + Версия();
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком.
//
// Возвращаемое значение:
//   Строка - 
//
Функция Версия() Экспорт
	
	Возврат "1.0.1.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии.
//
// Возвращаемое значение:
//   Строка - 
//
Функция БазовыйТип() Экспорт
	
	Возврат ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/Messages", "Body");
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса.
//
// Параметры:
//  Сообщение           - ОбъектXDTO - входящее сообщение,
//  Отправитель         - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияУправленияДополнительнымиОтчетамиИОбработкамиИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеУстановитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		УстановитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		УдалитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтключитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		ОтключитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеВключитьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		ВключитьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеОтозватьДополнительныйОтчетИлиОбработку(Пакет()) Тогда
		ОтозватьДополнительныйОтчетИлиОбработку(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	
	Попытка
	
		НастройкиКоманд = НастройкиКоманд(ТелоСообщения);
		
		НастройкиРазделов = Новый ТаблицаЗначений();
		НастройкиРазделов.Колонки.Добавить("Раздел");
		
		НастройкиНазначения = Новый ТаблицаЗначений();
		НастройкиНазначения.Колонки.Добавить("ОбъектНазначения");
		
		НастройкиРасположенияКоманд = Новый Структура();
		
		Если ЗначениеЗаполнено(ТелоСообщения.Assignments) Тогда
			
			ТипНазначениеРазделам = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеРазделам(ПакетМанифеста());
			ТипНазначениеСправочникамИДокументам = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеСправочникамИДокументам(ПакетМанифеста());
			Для Каждого Assignment Из ТелоСообщения.Assignments Цикл
				
				Если Assignment.Тип() = ТипНазначениеРазделам Тогда
					
					Для Каждого AssignmentObject Из Assignment.Objects Цикл
						
						СтрокаРаздела = НастройкиРазделов.Добавить();
						Если AssignmentObject.ObjectName = ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы() Тогда
							СтрокаРаздела.Раздел = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
						Иначе
							Раздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(AssignmentObject.ObjectName, Ложь);
							СтрокаРаздела.Раздел = ?(ЗначениеЗаполнено(Раздел), Раздел, Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
						КонецЕсли;
						
					КонецЦикла;
					
				ИначеЕсли Assignment.Тип() = ТипНазначениеСправочникамИДокументам Тогда
					
					Для Каждого AssignmentObject Из Assignment.Objects Цикл
						СтрокаНазначения = НастройкиНазначения.Добавить();
						ОбъектНазначения = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(AssignmentObject.ObjectName, Ложь);
						СтрокаНазначения.ОбъектНазначения = ?(ЗначениеЗаполнено(ОбъектНазначения), ОбъектНазначения, Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
					КонецЦикла;
					
					НастройкиРасположенияКоманд.Вставить("ИспользоватьДляФормыСписка", Assignment.UseInListsForms);
					НастройкиРасположенияКоманд.Вставить("ИспользоватьДляФормыОбъекта", Assignment.UseInObjectsForms);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		НастройкиВариантов = НастройкиВариантов(ТелоСообщения);
		ОписаниеИнсталляции = Новый Структура(
			"Идентификатор,Представление,Инсталляция",
			ТелоСообщения.Extension,
			ТелоСообщения.Representation,
			ТелоСообщения.Installation);
		
		СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.УстановитьДополнительныйОтчетИлиОбработку(
			ОписаниеИнсталляции, НастройкиКоманд, НастройкиРасположенияКоманд, НастройкиРазделов,
			НастройкиНазначения, НастройкиВариантов, ТелоСообщения.InitiatorServiceID);
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПоставляемаяОбработка = Справочники.ПоставляемыеДополнительныеОтчетыИОбработки.ПолучитьСсылку(ТелоСообщения.Extension);
		ДополнительныеОтчетыИОбработкиВМоделиСервиса.ОбработатьОшибкуУстановкиДополнительнойОбработкиВОбластьДанных(
			ПоставляемаяОбработка, ТелоСообщения.Installation, ТекстИсключения);
		
	КонецПопытки;
	
КонецПроцедуры

Функция НастройкиВариантов(Знач ТелоСообщения)
	
	НастройкиВариантов = Новый ТаблицаЗначений();
	НастройкиВариантов.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка"));
	НастройкиВариантов.Колонки.Добавить("Размещение", Новый ОписаниеТипов("Массив"));
	НастройкиВариантов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Если ТелоСообщения.ReportVariants = Неопределено Тогда
		Возврат НастройкиВариантов;
	КонецЕсли;
		
	Для Каждого ReportVariant Из ТелоСообщения.ReportVariants Цикл
		
		НастройкаВарианта = НастройкиВариантов.Добавить();
		НастройкаВарианта.Ключ = ReportVariant.VariantKey;
		НастройкаВарианта.Представление = ReportVariant.Representation;
		
		Размещение = Новый Массив;
		Для Каждого ReportVariantAssignment Из ReportVariant.Assignments Цикл
			
			Раздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ReportVariantAssignment.ObjectName, Ложь);
			Если Не ЗначениеЗаполнено(Раздел) Тогда
				Раздел = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
			КонецЕсли;
			
			Важный = Ложь;
			СмТакже = Ложь;
			Если ReportVariantAssignment.Importance = "High" Тогда
				Важный = Истина;
			ИначеЕсли ReportVariantAssignment.Importance = "Low" Тогда
				СмТакже = Истина;
			КонецЕсли;
			ЭлементРазмещения = Новый Структура("Раздел,Важный,СмТакже", Раздел, Важный, СмТакже);
			Размещение.Добавить(ЭлементРазмещения);
			
		КонецЦикла;
		
		НастройкаВарианта.Размещение = Размещение;
		
	КонецЦикла;
		
	Возврат НастройкиВариантов;

КонецФункции

Функция НастройкиКоманд(Знач ТелоСообщения)
	
	НастройкиКоманд = Новый ТаблицаЗначений();
	НастройкиКоманд.Колонки.Добавить("Идентификатор");
	НастройкиКоманд.Колонки.Добавить("БыстрыйДоступ");
	НастройкиКоманд.Колонки.Добавить("Расписание");
	
	Если Не ЗначениеЗаполнено(ТелоСообщения.CommandSettings) Тогда
		Возврат НастройкиКоманд;
	КонецЕсли;
		
	Для Каждого CommandSettings Из ТелоСообщения.CommandSettings Цикл
		
		НастройкиКоманды = НастройкиКоманд.Добавить();
		НастройкиКоманды.Идентификатор = CommandSettings.Id;
		
		Если CommandSettings.Settings <> Неопределено Тогда
			
			МассивИдентификаторов = Новый Массив;
			Для Каждого UserGUID Из CommandSettings.Settings.UsersFastAccess Цикл
				МассивИдентификаторов.Добавить(UserGUID);
			КонецЦикла;
			
			НастройкиКоманды.БыстрыйДоступ = МассивИдентификаторов;
			Если CommandSettings.Settings.Schedule <> Неопределено Тогда
				НастройкиКоманды.Расписание = СериализаторXDTO.ПрочитатьXDTO(CommandSettings.Settings.Schedule);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НастройкиКоманд;

КонецФункции

Процедура УдалитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	ТелоСообщения = Сообщение.Body;
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.УдалитьДополнительныйОтчетИлиОбработку(
		ТелоСообщения.Extension, ТелоСообщения.Installation);
	
КонецПроцедуры

Процедура ОтключитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.ОтключитьДополнительныйОтчетИлиОбработку(
		Сообщение.Body.Extension);
	
КонецПроцедуры

Процедура ВключитьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.ВключитьДополнительныйОтчетИлиОбработку(
		Сообщение.Body.Extension);
	
КонецПроцедуры

Процедура ОтозватьДополнительныйОтчетИлиОбработку(Знач Сообщение, Знач Отправитель)
	
	СообщенияУправленияДополнительнымиОтчетамиИОбработкамиРеализация.ОтозватьДополнительныйОтчетИлиОбработку(
		Сообщение.Body.Extension);
	
КонецПроцедуры

Функция ПакетМанифеста()
	
	Возврат ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.1");
	
КонецФункции

#КонецОбласти
