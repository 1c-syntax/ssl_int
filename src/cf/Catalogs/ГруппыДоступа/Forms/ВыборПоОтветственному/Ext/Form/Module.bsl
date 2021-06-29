﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Выбранные",                 Параметры.Выбранные);
	Запрос.УстановитьПараметр("ПользовательГрупп",         Параметры.ПользовательГрупп);
	Запрос.УстановитьПараметр("Ответственный",             Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("ПолноправныйОтветственный", Пользователи.ЭтоПолноправныйПользователь());
	Запрос.УстановитьПараметр("ГруппаДоступаАдминистраторы",
		УправлениеДоступом.ГруппаДоступаАдминистраторы());
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка,
	|	ГруппыДоступа.Наименование КАК Наименование,
	|	ГруппыДоступа.ЭтоГруппа КАК ЭтоГруппа,
	|	ВЫБОР
	|		КОГДА ГруппыДоступа.ЭтоГруппа
	|				И НЕ ГруппыДоступа.ПометкаУдаления
	|			ТОГДА 0
	|		КОГДА ГруппыДоступа.ЭтоГруппа
	|				И ГруппыДоступа.ПометкаУдаления
	|			ТОГДА 1
	|		КОГДА НЕ ГруппыДоступа.ЭтоГруппа
	|				И НЕ ГруппыДоступа.ПометкаУдаления
	|			ТОГДА 3
	|		ИНАЧЕ 4
	|	КОНЕЦ КАК НомерКартинки,
	|	ЛОЖЬ КАК Пометка,
	|	ГруппыДоступа.Комментарий КАК Комментарий
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ГруппыДоступа.ЭтоГруппа
	|				ТОГДА ИСТИНА
	|			КОГДА ГруппыДоступа.Ссылка В (&Выбранные)
	|				ТОГДА ЛОЖЬ
	|			КОГДА ГруппыДоступа.ПометкаУдаления
	|				ТОГДА ЛОЖЬ
	|			КОГДА ГруппыДоступа.Профиль.ПометкаУдаления
	|				ТОГДА ЛОЖЬ
	|			КОГДА ГруппыДоступа.Ссылка = &ГруппаДоступаАдминистраторы
	|				ТОГДА &ПолноправныйОтветственный
	|						И ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.Пользователи)
	|			КОГДА &ПолноправныйОтветственный = ЛОЖЬ
	|					И ГруппыДоступа.Ответственный <> &Ответственный
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ВЫБОР
	|						КОГДА ГруппыДоступа.Пользователь = НЕОПРЕДЕЛЕНО
	|							ТОГДА ИСТИНА
	|						КОГДА ГруппыДоступа.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|							ТОГДА ИСТИНА
	|						КОГДА ГруппыДоступа.Пользователь = ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ГруппыДоступа.Пользователь = &ПользовательГрупп
	|					КОНЕЦ
	|					И ВЫБОР
	|						КОГДА ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.Пользователи)
	|								ИЛИ ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.ГруппыПользователей)
	|							ТОГДА ИСТИНА В
	|									(ВЫБРАТЬ ПЕРВЫЕ 1
	|										ИСТИНА
	|									ИЗ
	|										Справочник.ПрофилиГруппДоступа.Назначение КАК ПрофилиГруппДоступаНазначение
	|									ГДЕ
	|										ПрофилиГруппДоступаНазначение.Ссылка = ГруппыДоступа.Профиль
	|										И ТИПЗНАЧЕНИЯ(ПрофилиГруппДоступаНазначение.ТипПользователей) = ТИП(Справочник.Пользователи))
	|						КОГДА ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.ВнешниеПользователи)
	|							ТОГДА ИСТИНА В
	|									(ВЫБРАТЬ ПЕРВЫЕ 1
	|										ИСТИНА
	|									ИЗ
	|										Справочник.ПрофилиГруппДоступа.Назначение КАК ПрофилиГруппДоступаНазначение,
	|										Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|									ГДЕ
	|										ВнешниеПользователи.Ссылка = &ПользовательГрупп
	|										И ПрофилиГруппДоступаНазначение.Ссылка = ГруппыДоступа.Профиль
	|										И ТИПЗНАЧЕНИЯ(ПрофилиГруппДоступаНазначение.ТипПользователей) = ТИПЗНАЧЕНИЯ(ВнешниеПользователи.ОбъектАвторизации))
	|						КОГДА ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.ГруппыВнешнихПользователей)
	|							ТОГДА ИСТИНА В
	|									(ВЫБРАТЬ ПЕРВЫЕ 1
	|										ИСТИНА
	|									ИЗ
	|										Справочник.ПрофилиГруппДоступа.Назначение КАК ПрофилиГруппДоступаНазначение,
	|										Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователейНазначение
	|									ГДЕ
	|										ГруппыВнешнихПользователейНазначение.Ссылка = &ПользовательГрупп
	|										И ПрофилиГруппДоступаНазначение.Ссылка = ГруппыДоступа.Профиль
	|										И ТИПЗНАЧЕНИЯ(ПрофилиГруппДоступаНазначение.ТипПользователей) = ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователейНазначение.ТипПользователей))
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыДоступа.Ссылка ИЕРАРХИЯ";
	
	НовоеДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Папки = НовоеДерево.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Истина), Истина);
	
	УдалитьПапки = Новый Соответствие;
	НетПапок = Истина;
	
	Для каждого Папка Из Папки Цикл
		Если Папка.Родитель = Неопределено
		   И Папка.Строки.Количество() = 0
		 ИЛИ Папка.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Ложь), Истина).Количество() = 0 Тогда
			
			УдалитьПапки.Вставить(
				?(Папка.Родитель = Неопределено, НовоеДерево.Строки, Папка.Родитель.Строки),
				Папка);
		Иначе
			НетПапок = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из УдалитьПапки Цикл
		Строки = КлючИЗначение.Ключ; // КоллекцияСтрокДереваЗначений
		Если Строки.Индекс(КлючИЗначение.Значение) > -1 Тогда
			Строки.Удалить(КлючИЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
	НовоеДерево.Строки.Сортировать("ЭтоГруппа Убыв, Наименование Возр", Истина);
	ЗначениеВРеквизитФормы(НовоеДерево, "ГруппыДоступа");
	
	Если НетПапок Тогда
		Элементы.ГруппыДоступа.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыДоступа

&НаКлиенте
Процедура ГруппыДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПриВыборе();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПриВыборе();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриВыборе()
	
	ТекущиеДанные = Элементы.ГруппыДоступа.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.ЭтоГруппа Тогда
			
			Если Элементы.ГруппыДоступа.Развернут(Элементы.ГруппыДоступа.ТекущаяСтрока) Тогда
				Элементы.ГруппыДоступа.Свернуть(Элементы.ГруппыДоступа.ТекущаяСтрока);
			Иначе
				Элементы.ГруппыДоступа.Развернуть(Элементы.ГруппыДоступа.ТекущаяСтрока);
			КонецЕсли;
		Иначе
			ОповеститьОВыборе(ТекущиеДанные.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
