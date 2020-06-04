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
	
	СохранитьПараметрыОткрытия(Параметры);
	Взаимодействия.ОбработатьНеобходимостьОтображенияГруппПользователей(ЭтотОбъект);
	Взаимодействия.ДобавитьСтраницыФормыПодбораКонтактов(ЭтотОбъект);
	
	// Заполним контакты по предмету.
	Взаимодействия.ЗаполнитьКонтактыПоПредмету(Элементы, Параметры.Предмет, КонтактыПоПредмету, Ложь);
	
	// Заполним список вариантов поиска и осуществим первый поиск.
	ВсеСпискиПоиска = Взаимодействия.СписокДоступныхПоисков(ППДВключен, Параметры, Элементы, Ложь);
	ВыполнитьПервыйПоиск();
	
	// Если заполнен контакт, установим нужной текущую страницу и спозиционируемся на нем.
	Если ЗначениеЗаполнено(Параметры.Контакт) Тогда
		УстановитьТекущимКонтакт(Параметры.Контакт)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСписокВыбораВСтрокеПоиска(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НайденныеКонтактыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Оповестить("ВыбранКонтакт", ПараметрыОповещения(Элемент.ТекущиеДанные.Ссылка));
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокСправочникаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКонтакта = Новый Структура;
	
	МассивОписанийКонтакта = ВзаимодействияКлиентСервер.ОписанияКонтактов();
	Для Каждого ЭлементМассива Из  МассивОписанийКонтакта Цикл
		Если ТипЗнч(ТекущиеДанные.Ссылка) = ЭлементМассива.Тип Тогда
			ОписаниеКонтакта = ЭлементМассива;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОписаниеКонтакта.Свойство("Иерархический")И ОписаниеКонтакта.Иерархический Тогда
		ЭтоГруппа = ЭтоГруппа(ТекущиеДанные.Ссылка);
	Иначе
		ЭтоГруппа = Ложь;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыПоПредметуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Оповестить("ВыбранКонтакт", ПараметрыОповещения(Элемент.ТекущиеДанные.Ссылка));
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПоискаПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораВСтрокеПоиска(Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_СписокКонтактыПриАктивизацииСтроки(Элемент)
	
	ОпределитьАктивизированныйКонтакт(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокВладелецПриАктивизацииСтроки(Элемент)
	
	ОпределитьАктивизированныйКонтакт(Элемент);
	
	ВзаимодействияКлиент.КонтактВладелецПриАктивизацииСтроки(Элемент, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаНайтиВыполнить()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не задана строка поиска.'"));
		Возврат;
	КонецЕсли;
	
	Результат = "";
	НайденныеКонтакты.Очистить();
	
	Если ВариантыПоиска = "ПоEmail" Тогда
		НайтиПоEmail(Ложь);
	ИначеЕсли ВариантыПоиска = "ПоДомену" Тогда
		НайтиПоEmail(Истина);
	ИначеЕсли ВариантыПоиска = "ПоТелефону" Тогда
		НайтиПоТелефону();
	ИначеЕсли ВариантыПоиска = "ПоСтроке" Тогда
		Результат = НайтиПоСтроке();
	ИначеЕсли ВариантыПоиска = "НачинаетсяС" Тогда
		НайтиПоНачалуНаименования();
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат) Тогда
		ПоказатьПредупреждение(, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВСпискеИзСпискаНайденныхВыполнить()
	
	Если Элементы.НайденныеКонтакты.ТекущиеДанные <> Неопределено Тогда
		УстановитьТекущимКонтакт(Элементы.НайденныеКонтакты.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НайтиВСпискеИзСпискаПредметовВыполнить()
	
	Если Элементы.КонтактыПоПредмету.ТекущиеДанные <> Неопределено Тогда
		УстановитьТекущимКонтакт(Элементы.КонтактыПоПредмету.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

// Возвращает данные строки таблицы Контакты по предмету.
// 
// Параметры:
//  ВыделеннаяСтрока  - ДанныеФормыЭлементКоллекции - строка, данные которой получаются.
//
// Возвращаемое значение:
//  Структура:
//   * Ссылка                    - ОпределяемыйТип.КонтактВзаимодействия
//   * Наименование              - Строка
//   * ИмяСправочника            - Строка
//   * ПредставлениеНаименования - Строка
//
&НаКлиенте
Функция ДанныеКонтактыПоПредмету(ВыделеннаяСтрока);
	
	Возврат ВыделеннаяСтрока;
	
КонецФункции

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов Тогда
		
		ТекущиеДанные = ДанныеКонтактыПоПредмету(Элементы.НайденныеКонтакты.ТекущиеДанные);
		Если ТекущиеДанные <> Неопределено Тогда
			Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	ИначеЕсли Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаВсеКонтактыПоПредмету Тогда
		
		ТекущиеДанные = ДанныеКонтактыПоПредмету(Элементы.КонтактыПоПредмету.ТекущиеДанные);
		Если ТекущиеДанные <> Неопределено Тогда
			Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	КонтактДляВыбора = Неопределено;
	
	Для инд = 0 По Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() -1 Цикл
		
		ТекущиеДанные = ДанныеКонтактыПоПредмету(Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы[инд].ТекущиеДанные);
		Если ТекущиеДанные = Неопределено  Тогда
			Продолжить;
		Иначе
			Если ТекущиеДанные.Свойство("Ссылка") И ТекущиеДанные.Ссылка = ПоследнийАктивизированныйКонтакт Тогда
				КонтактДляВыбора = ПоследнийАктивизированныйКонтакт;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если КонтактДляВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ОписаниеКонтакта = Новый Структура;
	
	МассивОписанийКонтакта = ВзаимодействияКлиентСервер.ОписанияКонтактов();
	Для Каждого ЭлементМассива Из  МассивОписанийКонтакта Цикл
		Если ТипЗнч(КонтактДляВыбора) = ЭлементМассива.Тип Тогда
			ОписаниеКонтакта = ЭлементМассива;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОписаниеКонтакта.Свойство("Иерархический")И ОписаниеКонтакта.Иерархический Тогда
		ЭтоГруппа = ЭтоГруппа(КонтактДляВыбора);
	Иначе
		ЭтоГруппа = Ложь;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		Оповестить("ВыбранКонтакт", ПараметрыОповещения(ТекущиеДанные.Ссылка));
		Закрыть(КонтактДляВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Просмотр(Команда)
	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПользователей Тогда
		ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОСУЩЕСТВЛЕНИЯ ПОИСКА

// Формирует список значений строк, по которым будет осуществляться поиск по текущему варианту поиска.
//
// Возвращаемое значение:
//   СписокЗначений   - список строк, по которым будет осуществляться поиск.
//
&НаСервере
Функция СписокСтрокПоискаПоВарианту()

	СписокСтрок = Новый СписокЗначений;
	
	Значения = Неопределено;
	ВсеСпискиПоиска.Свойство(ВариантыПоиска, Значения);
	
	Если ТипЗнч(Значения) = Тип("Строка") Тогда
		СписокСтрок.Добавить(Значения);
	ИначеЕсли ТипЗнч(Значения) = Тип("СписокЗначений") Тогда
		Для Каждого Элемент Из Значения Цикл
			СписокСтрок.Добавить(Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокСтрок;

КонецФункции

// Выполняет первый поиск по всем возможным вариантам поиска согласно переданным параметрам.
//
&НаСервере
Процедура ВыполнитьПервыйПоиск()
	
	ВариантыПоиска = "ПоСтроке";
	Если ПустаяСтрока(Параметры.Адрес) И ПустаяСтрока(Параметры.Представление) Тогда
		Возврат;
	КонецЕсли;

	// Попробуем поискать по email.
	ВариантыПоиска = "ПоEmail";
	Для Каждого Вариант Из СписокСтрокПоискаПоВарианту() Цикл
		СтрокаПоиска = Вариант.Значение;
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Продолжить;
		КонецЕсли;
		Если НайтиПоEmail(Ложь) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	// Попробуем поискать по телефону.
	ВариантыПоиска = "ПоТелефону";
	Для Каждого Вариант Из СписокСтрокПоискаПоВарианту() Цикл
		СтрокаПоиска = Вариант.Значение;
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Продолжить;
		КонецЕсли;
		Если НайтиПоТелефону() Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

	// Если индекс ППД не включен то дальше не ищем.
	Если НЕ ППДВключен Тогда
		ВариантыПоиска = "ПоEmail";
		Возврат;
	КонецЕсли;

	// Попробуем поискать по адресу и представлению.
	ВариантыПоиска = "ПоСтроке";
	Для Каждого Вариант Из СписокСтрокПоискаПоВарианту() Цикл
		СтрокаПоиска = Вариант.Значение;
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Продолжить;
		КонецЕсли;
		НайтиПоСтроке();
		Если НайденныеКонтакты.Количество() > 0 Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Осуществляет поиск контактов по доменному имени или по адресу электронной почты.
//
&НаСервере
Функция НайтиПоEmail(ПоДомену)

	Возврат Взаимодействия.НайтиПоEmail(СтрокаПоиска, ПоДомену, НайденныеКонтакты);

КонецФункции

// Осуществляет поиск контактов по телефону.
//
&НаСервере
Функция НайтиПоТелефону()
	
	Возврат Взаимодействия.НайтиКонтактыПоТелефону(СтрокаПоиска, ЭтотОбъект);
	
КонецФункции

// Осуществляет поиск контактов по строке.
//
&НаСервере
Функция НайтиПоСтроке()
	
	Возврат Взаимодействия.ПолнотекстовыйПоискКонтактовПоСтроке(СтрокаПоиска, НайденныеКонтакты);
	
КонецФункции

// Осуществляет поиск контактов по началу наименования.
//
&НаСервере
Функция НайтиПоНачалуНаименования()

	ТаблицаКонтактов = Взаимодействия.НайтиКонтактыПоНачалуНаименования(СтрокаПоиска);

	Если ТаблицаКонтактов = Неопределено ИЛИ ТаблицаКонтактов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Взаимодействия.ЗаполнитьНайденныеКонтакты(ТаблицаКонтактов, НайденныеКонтакты);
	Возврат Истина;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Устанавливает текущим контакт в соответствующем динамическом списке.
//
// Параметры:
//  Контакт  - СправочникСсылка - контакт, на котором необходимо спозиционироваться.
// 
&НаСервере
Процедура УстановитьТекущимКонтакт(Контакт)

	Взаимодействия.УстановитьТекущимКонтакт(Контакт, ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыОткрытия(ПереданныеПараметры)
	
	Представление = "";
	Если Не ПустаяСтрока(ПереданныеПараметры.Представление) Тогда
		Представление = СтрПолучитьСтроку(ПереданныеПараметры.Представление, 1);
	КонецЕсли;
	
	ПараметрыФормы.Добавить( ПереданныеПараметры.Адрес,                             "Адрес");
	ПараметрыФормы.Добавить( ПереданныеПараметры.Контакт,                           "Контакт");
	ПараметрыФормы.Добавить( ПереданныеПараметры.Предмет,                           "Предмет");
	ПараметрыФормы.Добавить( Представление,                                         "Представление");
	ПараметрыФормы.Добавить( ПереданныеПараметры.ТолькоEmail,                       "ТолькоEmail");
	ПараметрыФормы.Добавить( ПереданныеПараметры.ТолькоТелефон,                     "ТолькоТелефон");
	ПараметрыФормы.Добавить( ПереданныеПараметры.ДляФормыУточненияКонтактов,        "ДляФормыУточненияКонтактов");
	ПараметрыФормы.Добавить( ПереданныеПараметры.ЗаменятьПустыеАдресИПредставление, "ЗаменятьПустыеАдресИПредставление");
	ПараметрыФормы.Добавить( ПереданныеПараметры.ИдентификаторФормы,                "ИдентификаторФормы");
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОповещения(ВыбранныйКонтакт)

	ПараметрыОповещения = Новый Структура;
	
	Для каждого ЭлементСписка Из ПараметрыФормы Цикл
	
		ПараметрыОповещения.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
	
	КонецЦикла;
	
	ПараметрыОповещения.Вставить("ВыбранныйКонтакт", ВыбранныйКонтакт);
	
	Возврат ПараметрыОповещения;

КонецФункции 

&НаКлиенте
Процедура ОпределитьАктивизированныйКонтакт(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоследнийАктивизированныйКонтакт = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораВСтрокеПоиска(ИзменятьСтрокуПоиска)

	СписокВариантовПоиска = Неопределено;
	ВсеСпискиПоиска.Свойство(ВариантыПоиска, СписокВариантовПоиска);
	
	ЭтоСписок = Ложь;
	Если ТипЗнч(СписокВариантовПоиска) = Тип("СписокЗначений") Тогда
		Количество = СписокВариантовПоиска.Количество();
		Если Количество = 0 Тогда
			СписокВариантовПоиска = "";
		ИначеЕсли Количество = 1 Тогда
			СписокВариантовПоиска = СписокВариантовПоиска.Получить(0).Значение;
		Иначе
			ЭтоСписок = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтрокаПоиска.КнопкаВыпадающегоСписка = ЭтоСписок;
	
	Если ЭтоСписок Тогда
		Элементы.СтрокаПоиска.СписокВыбора.Очистить();
		Для Каждого ЭлементВарианта Из СписокВариантовПоиска Цикл
			Элементы.СтрокаПоиска.СписокВыбора.Добавить(ЭлементВарианта.Значение);
		КонецЦикла;
		Если ИзменятьСтрокуПоиска Тогда
			СтрокаПоиска = СписокВариантовПоиска.Получить(0).Значение;
		КонецЕсли;
	ИначеЕсли ИзменятьСтрокуПоиска Тогда
		СтрокаПоиска = СписокВариантовПоиска;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЭтоГруппа(СсылкаНаОбъект)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект, "ЭтоГруппа");
КонецФункции

#КонецОбласти
