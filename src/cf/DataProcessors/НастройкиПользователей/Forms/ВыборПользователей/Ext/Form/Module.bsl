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

	УстановитьУсловноеОформление();
	
	ТипПользователя = ТипЗнч(Параметры.Пользователь);
	
	Если ТипПользователя = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ГруппаВсеПользователи = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
	Иначе
		ГруппаВсеПользователи = Справочники.ГруппыПользователей.ВсеПользователи;
	КонецЕсли;
	
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ИспользоватьГруппы = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	ПользовательИсточник = Параметры.Пользователь;
	ЗаполнитьСписокПользователей(ТипПользователя, ИспользоватьГруппы);
	
	КопироватьВсе   = (Параметры.ТипДействия = "КопироватьВсе");
	ОчисткаНастроек = (Параметры.ТипДействия = "Очистка");
	Если ОчисткаНастроек Тогда
		Заголовок =
			НСтр("ru = 'Выбор пользователей для очистки настроек'");
		Элементы.Надпись.Заголовок =
			НСтр("ru = 'Выберите пользователей, которым необходимо очистить настройки'");
	КонецЕсли;
	
	Если Параметры.Свойство("ВыбранныеПользователи") Тогда
		ПомечатьПереданныхПользователей = Истина;
		
		Если Параметры.ВыбранныеПользователи <> Неопределено Тогда
			
			Для Каждого ВыбранныйПользователь Из Параметры.ВыбранныеПользователи Цикл
				ОтметитьПользователя(ВыбранныйПользователь);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Источник = Параметры.Источник;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Удалить("СписокВсехПользователей");
	
	// Если форма открыта из помощника копирования или очистки, то настройки не сохраняем.
	Если ПомечатьПереданныхПользователей Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Пометка", Истина);
	СписокПомеченныхПользователей = Новый СписокЗначений;
	МассивПомеченныхПользователей = СписокВсехПользователей.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаМассива Из МассивПомеченныхПользователей Цикл
		СписокПомеченныхПользователей.Добавить(СтрокаМассива.Пользователь);
	КонецЦикла;
	
	Настройки.Вставить("ПомеченныеПользователи", СписокПомеченныхПользователей);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	// Если форма открыта из помощника копирования или очистки, то настройки не загружаем.
	Если ПомечатьПереданныхПользователей Тогда
		Настройки.Удалить("СписокВсехПользователей");
		Настройки.Удалить("ПомеченныеПользователи");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПомеченныеПользователи = Настройки.Получить("ПомеченныеПользователи");
	
	Если ПомеченныеПользователи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаПомеченныеПользователи Из ПомеченныеПользователи Цикл
		
		ПользовательСсылка = СтрокаПомеченныеПользователи.Значение;
		ОтметитьПользователя(ПользовательСсылка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЗаголовкиГруппПриПереключенииФлажка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	ВыбраннаяГруппа = Элемент.ТекущиеДанные;
	Если ВыбраннаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПрименитьФильтрГрупп(ВыбраннаяГруппа);
	Если ИспользоватьГруппы Тогда
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаУстановитьСвойство;
	Иначе
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.Видимость = Ложь;
	КонецЕсли;
	
#Если МобильныйКлиент Тогда
	Элементы.СписокПользователей.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Пользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПользователейДочернихГруппПриИзменении(Элемент)
	
	ВыделеннаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущиеДанные;
	ПрименитьФильтрГрупп(ВыделеннаяГруппаПользователей);
	
	// Обновление заголовков групп.
	ОчиститьЗаголовкиГрупп();
	ОбновитьЗаголовкиГруппПриПереключенииФлажка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиФлажокПриИзменении(Элемент)
	
	СтрокаСпискаПользователей = Элемент.Родитель.Родитель.ТекущиеДанные;
	СтрокаСпискаПользователей.Пометка = Не СтрокаСпискаПользователей.Пометка;
	ПоменятьПометку(СтрокаСпискаПользователей, Не СтрокаСпискаПользователей.Пометка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПользователиПриемник = Новый Массив;
	Для Каждого Элемент Из СписокПользователей Цикл
		
		Если Элемент.Пометка Тогда
			ПользователиПриемник.Добавить(Элемент.Пользователь);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПользователиПриемник.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Необходимо отметить одного или несколько пользователей.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ПользователиПриемник, КопироватьВсе, ОчисткаНастроек", 
		ПользователиПриемник, КопироватьВсе, ОчисткаНастроек);
	Оповестить("ВыборПользователя", Результат, Источник);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	
	Для Каждого СтрокаСпискаПользователей Из СписокПользователей Цикл
		ПоменятьПометку(СтрокаСпискаПользователей, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВыбранные(Команда)
	
	ВыделенныеЭлементы = Элементы.СписокПользователей.ВыделенныеСтроки;
	
	Если ВыделенныеЭлементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из ВыделенныеЭлементы Цикл
		СтрокаСпискаПользователей = СписокПользователей.НайтиПоИдентификатору(Элемент);
		ПоменятьПометку(СтрокаСпискаПользователей, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуСоВсех(Команда)
	
	Для Каждого СтрокаСпискаПользователей Из СписокПользователей Цикл
		ПоменятьПометку(СтрокаСпискаПользователей, Ложь);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуВыбранных(Команда)
	
	ВыделенныеЭлементы = Элементы.СписокПользователей.ВыделенныеСтроки;
	
	Если ВыделенныеЭлементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из ВыделенныеЭлементы Цикл
		СтрокаСпискаПользователей = СписокПользователей.НайтиПоИдентификатору(Элемент);
		ПоменятьПометку(СтрокаСпискаПользователей, Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПользователяИлиГруппу(Команда)
	
	ТекущееЗначение = ТекущийЭлемент.ТекущиеДанные;
	
	Если ТипЗнч(ТекущееЗначение) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		
		ПоказатьЗначение(,ТекущееЗначение.Пользователь);
		
	ИначеЕсли ТипЗнч(ТекущееЗначение) = Тип("ДанныеФормыЭлементДерева") Тогда
		
		ПоказатьЗначение(,ТекущееЗначение.Группа);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АктивныеПользователи(Команда)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппыПользователейГруппа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппыПользователей.ПомеченоПользователей");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ОсновнойЭлементСписка);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ГруппыПользователей.НаименованиеГруппыИПомеченоПользователей"));

КонецПроцедуры

&НаСервере
Процедура ОтметитьПользователя(ПользовательСсылка)
	
	Для Каждого СтрокаСпискаВсехПользователей Из СписокВсехПользователей Цикл
		
		Если СтрокаСпискаВсехПользователей.Пользователь = ПользовательСсылка Тогда
			СтрокаСпискаВсехПользователей.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовкиГруппПриПереключенииФлажка()
	
	Для Каждого ГруппаПользователей Из ГруппыПользователей.ПолучитьЭлементы() Цикл
		
		Для Каждого СтрокаСпискаПользователей Из СписокВсехПользователей Цикл
			
			Если СтрокаСпискаПользователей.Пометка Тогда
				ЗначениеПометки = Истина;
				СтрокаСпискаПользователей.Пометка = Ложь;
				ОбновитьЗаголовокГруппы(ЭтотОбъект, ГруппаПользователей, СтрокаСпискаПользователей, ЗначениеПометки);
				СтрокаСпискаПользователей.Пометка = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗаголовкиГрупп()
	
	Для Каждого ГруппаПользователей Из ГруппыПользователей.ПолучитьЭлементы() Цикл
		ОчиститьЗаголовокГруппы(ГруппаПользователей);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗаголовокГруппы(ГруппаПользователей)
	
	ГруппаПользователей.ПомеченоПользователей = 0;
	ПодчиненныеГруппы = ГруппаПользователей.ПолучитьЭлементы();
	
	Для Каждого ПодчиненнаяГруппа Из ПодчиненныеГруппы Цикл
	
		ОчиститьЗаголовокГруппы(ПодчиненнаяГруппа);
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьПометку(СтрокаСпискаПользователей, ЗначениеПометки)
	
	Если ИспользоватьГруппы Тогда
		
		ОбновитьЗаголовкиГрупп(ЭтотОбъект, СтрокаСпискаПользователей, ЗначениеПометки);
		
		СтрокаСпискаПользователей.Пометка = ЗначениеПометки;
		Отбор = Новый Структура("Пользователь", СтрокаСпискаПользователей.Пользователь); 
		НайденныеПользователи = СписокВсехПользователей.НайтиСтроки(Отбор);
		Для Каждого НайденныйПользователь Из НайденныеПользователи Цикл
			НайденныйПользователь.Пометка = ЗначениеПометки;
		КонецЦикла;
	Иначе
		СтрокаСпискаПользователей.Пометка = ЗначениеПометки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовкиГрупп(Форма, СтрокаСпискаПользователей, ЗначениеПометки)
	
	Для Каждого ГруппаПользователей Из Форма.ГруппыПользователей.ПолучитьЭлементы() Цикл
		
		ОбновитьЗаголовокГруппы(Форма, ГруппаПользователей, СтрокаСпискаПользователей, ЗначениеПометки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокГруппы(Форма, ГруппаПользователей, СтрокаСпискаПользователей, ЗначениеПометки)
	
	ПользовательСсылка = СтрокаСпискаПользователей.Пользователь;
	Если Форма.ПоказыватьПользователейДочернихГрупп 
		Или Форма.ГруппаВсеПользователи = ГруппаПользователей.Группа Тогда
		Состав = ГруппаПользователей.ПолныйСостав;
	Иначе
		Состав = ГруппаПользователей.Состав;
	КонецЕсли;
	ПомеченныйПользователь = Состав.НайтиПоЗначению(ПользовательСсылка);
	
	Если ПомеченныйПользователь <> Неопределено И ЗначениеПометки <> СтрокаСпискаПользователей.Пометка Тогда
		ПомеченоПользователей = ГруппаПользователей.ПомеченоПользователей;
		ГруппаПользователей.ПомеченоПользователей = ?(ЗначениеПометки, ПомеченоПользователей + 1, ПомеченоПользователей - 1);
		ГруппаПользователей.НаименованиеГруппыИПомеченоПользователей = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"), Строка(ГруппаПользователей.Группа), ГруппаПользователей.ПомеченоПользователей);
	КонецЕсли;
	
	// Обновить заголовки у всех подчиненных групп рекурсивно.
	ПодчиненныеГруппы = ГруппаПользователей.ПолучитьЭлементы();
	Для Каждого ПодчиненнаяГруппа Из ПодчиненныеГруппы Цикл
		ОбновитьЗаголовокГруппы(Форма, ПодчиненнаяГруппа, СтрокаСпискаПользователей, ЗначениеПометки);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФильтрГрупп(ТекущаяГруппа)
	
	СписокПользователей.Очистить();
	Если ТекущаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоказыватьПользователейДочернихГрупп Тогда
		СоставГруппы = ТекущаяГруппа.ПолныйСостав;
	Иначе
		СоставГруппы = ТекущаяГруппа.Состав;
	КонецЕсли;
	
	Для Каждого Элемент Из СписокВсехПользователей Цикл
		Если СоставГруппы.НайтиПоЗначению(Элемент.Пользователь) <> Неопределено
			Или ГруппаВсеПользователи = ТекущаяГруппа.Группа Тогда
			СтрокаСписокПользователей = СписокПользователей.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаСписокПользователей, Элемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей(ТипПользователя, ИспользоватьГруппы);
	
	ДеревоГрупп = РеквизитФормыВЗначение("ГруппыПользователей");
	СписокВсехПользователейТаблица = РеквизитФормыВЗначение("СписокВсехПользователей");
	СписокПользователейТаблица = РеквизитФормыВЗначение("СписокПользователей");
	
	ПользовательВнешний = (ТипПользователя = Тип("СправочникСсылка.ВнешниеПользователи"));
	Если ИспользоватьГруппы Тогда
		Обработки.НастройкиПользователей.ЗаполнитьДеревоГрупп(ДеревоГрупп, ПользовательВнешний);
		СписокВсехПользователейТаблица = Обработки.НастройкиПользователей.ПользователиДляКопирования(
			ПользовательИсточник, СписокВсехПользователейТаблица, ПользовательВнешний);
	Иначе
		СписокПользователейТаблица = Обработки.НастройкиПользователей.ПользователиДляКопирования(
			ПользовательИсточник, СписокПользователейТаблица, ПользовательВнешний);
	КонецЕсли;
	
	ДеревоГрупп.Строки.Сортировать("Группа Возр");
	СтрокаДляПеремещения = ДеревоГрупп.Строки.Найти(ГруппаВсеПользователи, "Группа");
	
	Если СтрокаДляПеремещения <> Неопределено Тогда
		ИндексСтроки = ДеревоГрупп.Строки.Индекс(СтрокаДляПеремещения);
		ДеревоГрупп.Строки.Сдвинуть(ИндексСтроки, -ИндексСтроки);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоГрупп, "ГруппыПользователей");
	ЗначениеВРеквизитФормы(СписокПользователейТаблица, "СписокПользователей");
	ЗначениеВРеквизитФормы(СписокВсехПользователейТаблица, "СписокВсехПользователей");
	
КонецПроцедуры

#КонецОбласти
