﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события ОбработкаОповещения для формы, на которой требуется отобразить флажок использования поиска.
//
// Параметры:
//   ИмяСобытия - Строка - имя события, которое было получено обработчиком события на форме.
//   ИспользоватьПолнотекстовыйПоиск - Число - реквизит, в который будет помещено значение.
// 
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
//		МодульПолнотекстовыйПоискКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолнотекстовыйПоискКлиент");
//		МодульПолнотекстовыйПоискКлиент.ОбработкаОповещенияИзмененияФлажкаИспользоватьПоиск(
//			ИмяСобытия, 
//			ИспользоватьПолнотекстовыйПоиск);
//	КонецЕсли;
//
Процедура ОбработкаОповещенияИзмененияФлажкаИспользоватьПоиск(Знач ИмяСобытия, ИспользоватьПолнотекстовыйПоиск) Экспорт
	
	Если ИмяСобытия = "ИзменилсяРежимПолнотекстовогоПоиска" Тогда
		ИспользоватьПолнотекстовыйПоиск = ПолнотекстовыйПоискСлужебныйВызовСервера.ЗначениеФлажкаИспользоватьПоиск();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриИзменении для флажка, выполняющего переключение режима полнотекстового поиска.
// Флажок должен быть связан с реквизитом типа Число.
// 
// Параметры:
//   ЗначениеФлажкаИспользоватьПоиск - Число - новое значение флажка, которое требуется обработать.
// 
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
//		МодульПолнотекстовыйПоискКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолнотекстовыйПоискКлиент");
//		МодульПолнотекстовыйПоискКлиент.ПриИзмененииФлажкаИспользоватьПоиск(ИспользоватьПолнотекстовыйПоиск);
//	КонецЕсли;
//
Процедура ПриИзмененииФлажкаИспользоватьПоиск(ЗначениеФлажкаИспользоватьПоиск) Экспорт
	
	ИспользоватьПолнотекстовыйПоиск = (ЗначениеФлажкаИспользоватьПоиск = 1);
	
	Установлено = ПолнотекстовыйПоискСлужебныйВызовСервера.УстановитьРежимПолнотекстовогоПоиска(
		ИспользоватьПолнотекстовыйПоиск);
	
	Если Не Установлено Тогда
		ПолнотекстовыйПоискСлужебныйКлиент.ПоказатьПредупреждениеМонопольногоРежимаИзменения();
	КонецЕсли;
	
	Оповестить("ИзменилсяРежимПолнотекстовогоПоиска");
	
КонецПроцедуры

// Открывает форму управления полнотекстовым поиском и извлечением текстов.
// Не забудьте команду, выполняющую вызов процедуры, 
// установить зависимой от функциональной опции ИспользоватьПолнотекстовыйПоиск.
//
// Пример:
//	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
//		МодульПолнотекстовыйПоискКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолнотекстовыйПоискКлиент");
//		МодульПолнотекстовыйПоискКлиент.ПоказатьНастройку();
//	КонецЕсли;
//
Процедура ПоказатьНастройку() Экспорт
	
	ОткрытьФорму("Обработка.ПолнотекстовыйПоискВДанных.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов");
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ПоказатьНастройку.
// Открывает форму управления полнотекстовым поиском и извлечения текстов.
//
Процедура ПоказатьУправлениеПолнотекстовымПоискомИИзвлечениемТекстов() Экспорт
	
	ПоказатьНастройку();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти