﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	Поля.Добавить("ИмяПредопределенногоНабора");
	Поля.Добавить("Наименование");
	Поля.Добавить("Ссылка");
	Поля.Добавить("Родитель");
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Если ТекущийЯзык() = Метаданные.ОсновнойЯзык Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.Родитель) Тогда
		ЛокализацияКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.ИмяПредопределенногоНабора) Тогда
		ИмяНабора = Данные.ИмяПредопределенногоНабора;
	Иначе
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ИмяНабора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Данные.Ссылка, "ИмяПредопределенныхДанных");
#Иначе
		ИмяНабора = "";
#КонецЕсли
	КонецЕсли;
	Представление = ПредставлениеНабораВерхнегоУровня(ИмяНабора, Данные);
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет состав наименований предопределенных наборов в
// параметрах дополнительных реквизитов и сведений.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьСоставНаименованийПредопределенныхНаборов(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредопределенныеНаборы = ПредопределенныеНаборыСвойств();
	
	НачатьТранзакцию();
	Попытка
		ЕстьТекущиеИзменения = Ложь;
		СтароеЗначение = Неопределено;
		
		СтандартныеПодсистемыСервер.ОбновитьПараметрРаботыПрограммы(
			"СтандартныеПодсистемы.Свойства.ПредопределенныеНаборыДополнительныхРеквизитовИСведений",
			ПредопределенныеНаборы, ЕстьТекущиеИзменения, СтароеЗначение);
		
		СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы(
			"СтандартныеПодсистемы.Свойства.ПредопределенныеНаборыДополнительныхРеквизитовИСведений",
			?(ЕстьТекущиеИзменения,
			  Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина),
			  Новый ФиксированнаяСтруктура()) );
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ЕстьТекущиеИзменения Тогда
		ЕстьИзменения = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьНаборыСвойствДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПредопределенныеНаборыСвойств = УправлениеСвойствамиПовтИсп.ПредопределенныеНаборыСвойств();
	ПроблемныхОбъектов = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Наборы.Ссылка КАК Ссылка,
		|	Наборы.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	Наборы.ДополнительныеРеквизиты.(
		|		Свойство КАК Свойство
		|	) КАК ДополнительныеРеквизиты,
		|	Наборы.ДополнительныеСведения.(
		|		Свойство КАК Свойство
		|	) КАК ДополнительныеСведения,
		|	Наборы.Родитель КАК Родитель,
		|	Наборы.ЭтоГруппа КАК ЭтоГруппа
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК Наборы
		|ГДЕ
		|	Наборы.Предопределенный = ИСТИНА";
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ОбновляемыйНабор Из Результат Цикл
		
		НачатьТранзакцию();
		Попытка
			Если Не ЗначениеЗаполнено(ОбновляемыйНабор.ИмяПредопределенныхДанных) Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			Если Не СтрНачинаетсяС(ОбновляемыйНабор.ИмяПредопределенныхДанных, "Удалить") Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			Если ОбновляемыйНабор.ДополнительныеРеквизиты.Количество() = 0
				И ОбновляемыйНабор.ДополнительныеСведения.Количество() = 0 Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			ИмяНабора = Сред(ОбновляемыйНабор.ИмяПредопределенныхДанных, 8, СтрДлина(ОбновляемыйНабор.ИмяПредопределенныхДанных) - 7);
			ОписаниеНовогоНабора = ПредопределенныеНаборыСвойств.Получить(ИмяНабора);
			Если ОписаниеНовогоНабора = Неопределено Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			НовыйНабор = ОписаниеНовогоНабора.Ссылка;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.НаборыДополнительныхРеквизитовИСведений");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", НовыйНабор);
			Блокировка.Заблокировать();
			
			// Заполнение нового набора.
			НовыйНаборОбъект = НовыйНабор.ПолучитьОбъект();
			Если ОбновляемыйНабор.ЭтоГруппа <> НовыйНаборОбъект.ЭтоГруппа Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			Для Каждого СтрокаРеквизит Из ОбновляемыйНабор.ДополнительныеРеквизиты Цикл
				НоваяСтрокаРеквизиты = НовыйНаборОбъект.ДополнительныеРеквизиты.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаРеквизиты, СтрокаРеквизит);
				НоваяСтрокаРеквизиты.ИмяПредопределенногоНабора = НовыйНаборОбъект.ИмяПредопределенногоНабора;
			КонецЦикла;
			Для Каждого СтрокаСведение Из ОбновляемыйНабор.ДополнительныеСведения Цикл
				НоваяСтрокаСведения = НовыйНаборОбъект.ДополнительныеСведения.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаСведения, СтрокаСведение);
				НоваяСтрокаСведения.ИмяПредопределенногоНабора = НовыйНаборОбъект.ИмяПредопределенногоНабора;
			КонецЦикла;
			
			// Обновление реквизитов и сведений.
			Если Не ОбновляемыйНабор.ЭтоГруппа Тогда
				Для Каждого СтрокаТаблицы Из ОбновляемыйНабор.ДополнительныеРеквизиты Цикл
					РеквизитОбъект = СтрокаТаблицы.Свойство.ПолучитьОбъект();
					Если Не ЗначениеЗаполнено(РеквизитОбъект.НаборСвойств) Тогда
						Продолжить;
					КонецЕсли;
					РеквизитОбъект.НаборСвойств = НовыйНабор;
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(РеквизитОбъект);
				КонецЦикла;
				
				Для Каждого СтрокаТаблицы Из ОбновляемыйНабор.ДополнительныеСведения Цикл
					СвойствоОбъект = СтрокаТаблицы.Свойство.ПолучитьОбъект();
					Если Не ЗначениеЗаполнено(СвойствоОбъект.НаборСвойств) Тогда
						Продолжить;
					КонецЕсли;
					СвойствоОбъект.НаборСвойств = НовыйНабор;
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СвойствоОбъект);
				КонецЦикла;
			КонецЕсли;
			
			Если Не ОбновляемыйНабор.ЭтоГруппа Тогда
				КоличествоРеквизитов = Формат(НовыйНаборОбъект.ДополнительныеРеквизиты.НайтиСтроки(
					Новый Структура("ПометкаУдаления", Ложь)).Количество(), "ЧГ=");
				КоличествоСведений   = Формат(НовыйНаборОбъект.ДополнительныеСведения.НайтиСтроки(
					Новый Структура("ПометкаУдаления", Ложь)).Количество(), "ЧГ=");
				
				НовыйНаборОбъект.КоличествоРеквизитов = КоличествоРеквизитов;
				НовыйНаборОбъект.КоличествоСведений   = КоличествоСведений;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовыйНаборОбъект);
			
			// Очистка старого набора.
			УстаревшийНаборОбъект = ОбновляемыйНабор.Ссылка.ПолучитьОбъект();
			УстаревшийНаборОбъект.ДополнительныеРеквизиты.Очистить();
			УстаревшийНаборОбъект.ДополнительныеСведения.Очистить();
			УстаревшийНаборОбъект.Используется = Ложь;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(УстаревшийНаборОбъект);
			
			Если ОбновляемыйНабор.ЭтоГруппа Тогда
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("Родитель", ОбновляемыйНабор.Ссылка);
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	НаборыДополнительныхРеквизитовИСведений.Ссылка КАК Ссылка
					|ИЗ
					|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НаборыДополнительныхРеквизитовИСведений
					|ГДЕ
					|	НаборыДополнительныхРеквизитовИСведений.Родитель = &Родитель
					|	И НаборыДополнительныхРеквизитовИСведений.Предопределенный = ЛОЖЬ";
				ПереносимыеНаборы = Запрос.Выполнить().Выгрузить();
				Для Каждого Строка Из ПереносимыеНаборы Цикл
					НаборОбъект = Строка.Ссылка.ПолучитьОбъект();
					НаборОбъект.Родитель = НовыйНабор;
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НаборОбъект);
				КонецЦикла;
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать набор свойств: %1 по причине:
					|%2'"), 
					ОбновляемыйНабор.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений, ОбновляемыйНабор.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = НСтр("ru = 'Процедура ОбработатьНаборыСвойствДляПереходаНаНовуюВерсию завершилась с ошибкой. Не все наборы свойств удалось обновить.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры



#КонецОбласти

#КонецЕсли

#Область СлужебныеПроцедурыИФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПредопределенныеНаборыСвойств() Экспорт
	
	ДеревоНаборов = Новый ДеревоЗначений;
	ДеревоНаборов.Колонки.Добавить("Имя");
	ДеревоНаборов.Колонки.Добавить("ЭтоГруппа", Новый ОписаниеТипов("Булево"));
	ДеревоНаборов.Колонки.Добавить("Используется");
	ДеревоНаборов.Колонки.Добавить("Идентификатор");
	ИнтеграцияПодсистемБСП.ПриПолученииПредопределенныхНаборовСвойств(ДеревоНаборов);
	УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств(ДеревоНаборов);
	
	НаименованияНаборовСвойств = УправлениеСвойствамиСлужебный.НаименованияНаборовСвойств();
	Наименования = НаименованияНаборовСвойств[ТекущийЯзык().КодЯзыка];
	
	НаборыСвойств = Новый Соответствие;
	Для Каждого Набор Из ДеревоНаборов.Строки Цикл
		СвойстваНабора = СвойстваНабора(НаборыСвойств, Набор);
		Для Каждого ДочернийНабор Из Набор.Строки Цикл
			СвойстваДочернегоНабора = СвойстваНабора(НаборыСвойств, ДочернийНабор, СвойстваНабора.Ссылка, Наименования);
			СвойстваНабора.ДочерниеНаборы.Вставить(ДочернийНабор.Имя, СвойстваДочернегоНабора);
		КонецЦикла;
		СвойстваНабора.ДочерниеНаборы = Новый ФиксированноеСоответствие(СвойстваНабора.ДочерниеНаборы);
		НаборыСвойств[СвойстваНабора.Имя] = Новый ФиксированнаяСтруктура(НаборыСвойств[СвойстваНабора.Имя]);
		НаборыСвойств[СвойстваНабора.Ссылка] = Новый ФиксированнаяСтруктура(НаборыСвойств[СвойстваНабора.Ссылка]);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(НаборыСвойств);
	
КонецФункции

Функция СвойстваНабора(НаборыСвойств, Набор, Родитель = Неопределено, Наименования = Неопределено)
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ПриСозданииПредопределенныхНаборовСвойств
		           |общего модуля УправлениеСвойствамиПереопределяемый.'")
		+ Символы.ПС
		+ Символы.ПС;
	
	Если Не ЗначениеЗаполнено(Набор.Имя) Тогда
		ВызватьИсключение ЗаголовокОшибки + НСтр("ru = 'Имя набора свойств не заполнено.'");
	КонецЕсли;
	
	Если НаборыСвойств.Получить(Набор.Имя) <> Неопределено Тогда
		ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Имя набора свойств ""%1"" уже определено.'"),
			Набор.Имя);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Набор.Идентификатор) Тогда
		ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Идентификатор набора свойств ""%1"" не заполнен.'"),
			Набор.Имя);
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		НаборСсылка = Набор.Идентификатор;
	Иначе
		НаборСсылка = ПолучитьСсылку(Набор.Идентификатор);
	КонецЕсли;
	
	Если НаборыСвойств.Получить(НаборСсылка) <> Неопределено Тогда
		ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Идентификатор ""%1"" набора свойств
			           |""%2"" уже используется для набора ""%3"".'"),
			Набор.Идентификатор, Набор.Имя, НаборыСвойств.Получить(НаборСсылка).Имя);
	КонецЕсли;
	
	СвойстваНабора = Новый Структура;
	СвойстваНабора.Вставить("Имя", Набор.Имя);
	СвойстваНабора.Вставить("ЭтоГруппа", Набор.ЭтоГруппа);
	СвойстваНабора.Вставить("Используется", Набор.Используется);
	СвойстваНабора.Вставить("Ссылка", НаборСсылка);
	СвойстваНабора.Вставить("Родитель", Родитель);
	СвойстваНабора.Вставить("ДочерниеНаборы", ?(Родитель = Неопределено, Новый Соответствие, Неопределено));
	Если Наименования = Неопределено Тогда
		СвойстваНабора.Вставить("Наименование", ПредставлениеНабораВерхнегоУровня(Набор.Имя));
	Иначе
		СвойстваНабора.Вставить("Наименование", Наименования[Набор.Имя]);
	КонецЕсли;
	
	Если Родитель <> Неопределено Тогда
		СвойстваНабора = Новый ФиксированнаяСтруктура(СвойстваНабора);
	КонецЕсли;
	НаборыСвойств.Вставить(СвойстваНабора.Имя,    СвойстваНабора);
	НаборыСвойств.Вставить(СвойстваНабора.Ссылка, СвойстваНабора);
	
	Возврат СвойстваНабора;
	
КонецФункции

#КонецЕсли

// АПК:361-выкл нет обращения к серверному коду.
Функция ПредставлениеНабораВерхнегоУровня(ИмяПредопределенного, СвойстваНабора = Неопределено)
	
	Представление = "";
	Позиция = СтрНайти(ИмяПредопределенного, "_");
	ПерваяЧастьИмени =  Лев(ИмяПредопределенного, Позиция - 1);
	ВтораяЧастьИмени = Прав(ИмяПредопределенного, СтрДлина(ИмяПредопределенного) - Позиция);
	
	ПолноеИмя = ПерваяЧастьИмени + "." + ВтораяЧастьИмени;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмя);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Представление;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектМетаданных.ПредставлениеСписка) Тогда
		Представление = ОбъектМетаданных.ПредставлениеСписка;
	ИначеЕсли ЗначениеЗаполнено(ОбъектМетаданных.Синоним) Тогда
		Представление = ОбъектМетаданных.Синоним;
	ИначеЕсли СвойстваНабора <> Неопределено Тогда
		Представление = СвойстваНабора.Наименование;
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти