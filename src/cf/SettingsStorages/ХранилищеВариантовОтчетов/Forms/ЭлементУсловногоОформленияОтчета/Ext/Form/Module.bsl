﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("КомпоновщикНастроек", КомпоновщикНастроек) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""КомпоновщикНастроек"".'");
	КонецЕсли;
	Если Не Параметры.Свойство("НастройкиОтчета", НастройкиОтчета) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""НастройкиОтчета"".'");
	КонецЕсли;
	Если Не Параметры.Свойство("ИдентификаторЭлементаСтруктурыНастроек", ИдентификаторЭлементаСтруктурыНастроек) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""ИдентификаторЭлементаСтруктурыНастроек"".'");
	КонецЕсли;
	Если Не Параметры.Свойство("ИдентификаторКД", ИдентификаторКД) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""ИдентификаторКД"".'");
	КонецЕсли;
	Если Не Параметры.Свойство("Наименование", Наименование) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""Наименование"".'");
	КонецЕсли;
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы);
	КомпоновщикНастроек.Инициализировать(Источник);
	
	УзелКД = КомпоновщикНастроек.Настройки.УсловноеОформление;
	Если ИдентификаторКД = Неопределено Тогда // Новый элемент
		ЭтоНовый = Истина;
		ЭлементКД = УзелКД.Элементы.Вставить(0);
		ЭлементКД.Использование = Истина;
		ЭлементКД.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		Элементы.Наименование.КнопкаОчистки = Ложь;
	Иначе
		УзелКДИсточник = УзелКД(ЭтотОбъект);
		Если УзелКДИсточник = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не найден узел отчета.'");
		КонецЕсли;
		ЭлементКДИсточник = УзелКДИсточник.ПолучитьОбъектПоИдентификатору(ИдентификаторКД);
		Если ЭлементКДИсточник = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не найден элемент условного оформления.'");
		КонецЕсли;
		ЭлементКД = ОтчетыКлиентСервер.СкопироватьРекурсивно(УзелКД, ЭлементКДИсточник, УзелКД.Элементы, 0, Новый Соответствие);
		
		НаименованиеПоУмолчанию = ОтчетыКлиентСервер.ПредставлениеЭлементаУсловногоОформления(ЭлементКД, Неопределено, "");
		НаименованиеПереопределено = (Наименование <> "" И Наименование <> НаименованиеПоУмолчанию);
		Элементы.Наименование.ПодсказкаВвода = НаименованиеПоУмолчанию;
		Если Не НаименованиеПереопределено Тогда
			Наименование = "";
			Элементы.Наименование.КнопкаОчистки = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ПолеФлажка Из Элементы.ГруппаОбластьОтображения.ПодчиненныеЭлементы Цикл
		ИмяФлажка = ПолеФлажка.Имя;
		ФлажкиОбластиОтображения.Добавить(ИмяФлажка);
		Если ЭлементКД[ИмяФлажка] = ИспользованиеУсловногоОформленияКомпоновкиДанных.Использовать Тогда
			ЭтотОбъект[ИмяФлажка] = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ЗакрыватьПриВыборе = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если Наименование = "" Или Наименование = Элементы.Наименование.ПодсказкаВвода Тогда
		ТребуетсяОбновлениеНаименованияПоУмолчанию = Истина;
		ОбновитьНаименованиеПоУмолчаниюЕслиТребуется();
		Элементы.Наименование.КнопкаОчистки = Ложь;
	Иначе
		Элементы.Наименование.КнопкаОчистки = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВГруппировкеПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВИерархическойГруппировкеПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВОбщемИтогеПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВЗаголовкеПолейПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВЗаголовкеПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПараметрахПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВОтбореПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОформление

&НаКлиенте
Процедура ОформлениеПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтбор

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОформляемыеПоля

&НаКлиенте
Процедура ОформляемыеПоляПриИзменении(Элемент)
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура Показывать_УстановитьПометки(Команда)
	Для Каждого ЭлементСписка Из ФлажкиОбластиОтображения Цикл
		ЭтотОбъект[ЭлементСписка.Значение] = Истина;
	КонецЦикла;
	ОбновитьНаименованиеПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура Показывать_СнятьПометки(Команда)
	Для Каждого ЭлементСписка Из ФлажкиОбластиОтображения Цикл
		ЭтотОбъект[ЭлементСписка.Значение] = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНаименованиеПоУмолчанию(Команда)
	Наименование = НаименованиеПоУмолчанию;
	Элементы.Наименование.КнопкаОчистки = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция УзелКД(Форма)
	Если Форма.ИдентификаторЭлементаСтруктурыНастроек = Неопределено Тогда
		Возврат Форма.КомпоновщикНастроек.Настройки.УсловноеОформление;
	Иначе
		ТекущийУзелКД = Форма.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Форма.ИдентификаторЭлементаСтруктурыНастроек);
		Возврат ТекущийУзелКД.УсловноеОформление;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ОбновитьНаименованиеПоУмолчанию()
	ТребуетсяОбновлениеНаименованияПоУмолчанию = Истина;
	Если Наименование = "" Или Наименование = Элементы.Наименование.ПодсказкаВвода Тогда
		ПодключитьОбработчикОжидания("ОбновитьНаименованиеПоУмолчаниюЕслиТребуется", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНаименованиеПоУмолчаниюЕслиТребуется()
	Если Не ТребуетсяОбновлениеНаименованияПоУмолчанию Тогда
		Возврат;
	КонецЕсли;
	ТребуетсяОбновлениеНаименованияПоУмолчанию = Ложь;
	УзелКД = КомпоновщикНастроек.Настройки.УсловноеОформление;
	ЭлементКД = УзелКД.Элементы[0];
	НаименованиеПоУмолчанию = ОтчетыКлиентСервер.ПредставлениеЭлементаУсловногоОформления(ЭлементКД, Неопределено, "");
	Если Наименование = Элементы.Наименование.ПодсказкаВвода Тогда
		Наименование = НаименованиеПоУмолчанию;
		Элементы.Наименование.ПодсказкаВвода = НаименованиеПоУмолчанию;
	ИначеЕсли Наименование = "" Тогда
		Элементы.Наименование.ПодсказкаВвода = НаименованиеПоУмолчанию;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	ОтключитьОбработчикОжидания("ОбновитьНаименованиеПоУмолчаниюЕслиТребуется");
	ОбновитьНаименованиеПоУмолчаниюЕслиТребуется();
	
	Если Наименование = "" Тогда
		Наименование = НаименованиеПоУмолчанию;
	КонецЕсли;
	
	ЭлементКД = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы[0];
	
	Если Наименование = НаименованиеПоУмолчанию Тогда
		ЭлементКД.ПредставлениеПользовательскойНастройки = "";
	Иначе
		ЭлементКД.ПредставлениеПользовательскойНастройки = Наименование;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из ФлажкиОбластиОтображения Цикл
		ИмяФлажка = ЭлементСписка.Значение;
		Если ЭтотОбъект[ИмяФлажка] Тогда
			ЭлементКД[ИмяФлажка] = ИспользованиеУсловногоОформленияКомпоновкиДанных.Использовать;
		Иначе
			ЭлементКД[ИмяФлажка] = ИспользованиеУсловногоОформленияКомпоновкиДанных.НеИспользовать;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура("ЭлементКД, Наименование", ЭлементКД, Наименование);
	ОповеститьОВыборе(Результат);
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти