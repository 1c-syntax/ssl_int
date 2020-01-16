﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДеревоОбъектов;
Перем ЗависимостиДобавления;
Перем ЗависимостиУдаления;
Перем СоставСтандартногоИнтерфейса;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ИнициализироватьДанныеДляНастройкиСоставаСтандартногоИнтерфейсаOData() Экспорт
	
	// Заполняем корневые строки дерева (по коллекциям объектов метаданных)
	ДобавитьКорневуюСтрокуДерева("Константа", НСтр("ru = 'Константы'"), 1, БиблиотекаКартинок.Константа);
	ДобавитьКорневуюСтрокуДерева("Справочник", НСтр("ru = 'Справочники'"), 2, БиблиотекаКартинок.Справочник);
	ДобавитьКорневуюСтрокуДерева("Документ", НСтр("ru = 'Документы'"), 3, БиблиотекаКартинок.Документ);
	ДобавитьКорневуюСтрокуДерева("ЖурналДокументов", НСтр("ru = 'Журналы документов'"), 4, БиблиотекаКартинок.ЖурналДокументов);
	ДобавитьКорневуюСтрокуДерева("Перечисление", НСтр("ru = 'Перечисление'"), 5, БиблиотекаКартинок.Перечисление);
	ДобавитьКорневуюСтрокуДерева("ПланВидовХарактеристик", НСтр("ru = 'Планы видов характеристик'"), 6, БиблиотекаКартинок.ПланВидовХарактеристик);
	ДобавитьКорневуюСтрокуДерева("ПланСчетов", НСтр("ru = 'Планы счетов'"), 7, БиблиотекаКартинок.ПланСчетов);
	ДобавитьКорневуюСтрокуДерева("ПланВидовРасчета", НСтр("ru = 'Планы видов расчета'"), 8, БиблиотекаКартинок.ПланВидовРасчета);
	ДобавитьКорневуюСтрокуДерева("РегистрСведений", НСтр("ru = 'Регистры сведений'"), 9, БиблиотекаКартинок.РегистрСведений);
	ДобавитьКорневуюСтрокуДерева("РегистрНакопления", НСтр("ru = 'Регистры накопления'"), 10, БиблиотекаКартинок.РегистрНакопления);
	ДобавитьКорневуюСтрокуДерева("РегистрБухгалтерии", НСтр("ru = 'Регистры бухгалтерии'"), 11, БиблиотекаКартинок.РегистрБухгалтерии);
	ДобавитьКорневуюСтрокуДерева("РегистрРасчета", НСтр("ru = 'Регистры расчета'"), 12, БиблиотекаКартинок.РегистрРасчета);
	ДобавитьКорневуюСтрокуДерева("БизнесПроцесс", НСтр("ru = 'Бизнес-процессы'"), 13, БиблиотекаКартинок.БизнесПроцесс);
	ДобавитьКорневуюСтрокуДерева("Задача", НСтр("ru = 'Задачи'"), 14, БиблиотекаКартинок.Задача);
	ДобавитьКорневуюСтрокуДерева("ПланОбмена", НСтр("ru = 'Планы обмена'"), 15, БиблиотекаКартинок.ПланОбмена);
	
	// Читаем текущий состав стандартного интерфейса OData
	СистемныйСостав = ПолучитьСоставСтандартногоИнтерфейсаOData();
	СоставСтандартногоИнтерфейса = Новый Массив();
	Для Каждого Элемент Из СистемныйСостав Цикл
		СоставСтандартногоИнтерфейса.Добавить(Элемент.ПолноеИмя());
	КонецЦикла;
	
	// Читаем модель данных, предоставляемых для стандартного интерфейса OData
	Модель = Обработки.НастройкаСтандартногоИнтерфейсаOData.МодельДанныхПредоставляемыхДляСтандартногоИнтерфейсаOData();
	
	// Заполняем вложенные строки дерева (по объектам метаданных, входящим в модель)
	Для Каждого ЭлементМодели Из Модель Цикл
		
		ПолноеИмя = ЭлементМодели.ПолноеИмя;
		ЭтоОбъектДоступныйТолькоДляЧтения = Не ЭлементМодели.Изменение;
		ЭтоОбъектВключенныйВСостав = (СоставСтандартногоИнтерфейса.Найти(ЭлементМодели.ПолноеИмя) <> Неопределено);
		Зависимости = ЭлементМодели.Зависимости;
		
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ПолноеИмя) Тогда
			
			ДобавитьВложеннуюСтрокуДерева(ПолноеИмя, ЭтоОбъектДоступныйТолькоДляЧтения,
				ЭтоОбъектВключенныйВСостав, Зависимости);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Удалим корневые строки (от коллекций метаданных, для которых нет ни одного объекта для включения в состав).
	УдаляемыеСтроки = Новый Массив();
	Для Каждого СтрокаДерева Из ДеревоОбъектов.Строки Цикл
		Если СтрокаДерева.Строки.Количество() = 0 Тогда
			УдаляемыеСтроки.Добавить(СтрокаДерева);
		КонецЕсли;
	КонецЦикла;
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		ДеревоОбъектов.Строки.Удалить(УдаляемаяСтрока);
	КонецЦикла;
	
	// Отсортируем вложенные строки по представлению объектов метаданных
	Для Каждого ВложеннаяСтрока Из ДеревоОбъектов.Строки Цикл
		ВложеннаяСтрока.Строки.Сортировать("Представление");
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ДеревоОбъектов", ДеревоОбъектов);
	Результат.Вставить("ЗависимостиДобавления", ЗависимостиДобавления);
	Результат.Вставить("ЗависимостиУдаления", ЗависимостиУдаления);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВложеннуюСтрокуДерева(Знач ПолноеИмя, Знач ТолькоЧтение, Знач Использование, Знач Зависимости)
	
	СтруктураИмени = СтрРазделить(ПолноеИмя, ".");
	КлассОбъекта = СтруктураИмени[0];
	
	СтрокаВладелец = Неопределено;
	Для Каждого СтрокаДерева Из ДеревоОбъектов.Строки Цикл
		Если СтрокаДерева.ПолноеИмя = КлассОбъекта Тогда
			СтрокаВладелец = СтрокаДерева;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаВладелец = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный объект метаданных: %1'"), ПолноеИмя);
	КонецЕсли;
	
	НоваяСтрока = СтрокаВладелец.Строки.Добавить();
	
	НоваяСтрока.ПолноеИмя = ПолноеИмя;
	НоваяСтрока.Представление = ПредставлениеОбъектаМетаданных(ПолноеИмя);
	НоваяСтрока.Класс = СтрокаВладелец.Класс;
	НоваяСтрока.Картинка = СтрокаВладелец.Картинка;
	НоваяСтрока.Использование = СоставСтандартногоИнтерфейса.Найти(ПолноеИмя) <> Неопределено;
	НоваяСтрока.Подчиненный = ИнтерфейсODataСлужебный.ЭтоНаборЗаписей(ПолноеИмя)
		И Не ЭтоНезависимыйНаборЗаписей(ПолноеИмя);
	НоваяСтрока.ТолькоЧтение = ТолькоЧтение;
	НоваяСтрока.Использование = Использование;
	
	Для Каждого ОбъектЗависимость Из Зависимости Цикл
		
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектЗависимость) Тогда
			
			// При включении в состав объекта ОбъектМетаданных требуется включать в состав объект ОбъектЗависимость.
			Строка = ЗависимостиДобавления.Добавить();
			Строка.ИмяОбъекта = ПолноеИмя;
			Строка.ИмяЗависимогоОбъекта = ОбъектЗависимость;
			
			// При исключении из состава объекта ОбъектЗависимость требуется исключать из состава объект ОбъектМетаданных.
			Строка = ЗависимостиУдаления.Добавить();
			Строка.ИмяОбъекта = ОбъектЗависимость;
			Строка.ИмяЗависимогоОбъекта = ПолноеИмя;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьКорневуюСтрокуДерева(Знач ПолноеИмя, Знач Представление, Знач Класс, Знач Картинка)
	
	НоваяСтрока = ДеревоОбъектов.Строки.Добавить();
	НоваяСтрока.ПолноеИмя = ПолноеИмя;
	НоваяСтрока.Представление = Представление;
	НоваяСтрока.Класс = Класс;
	НоваяСтрока.Картинка = Картинка;
	НоваяСтрока.Подчиненный = Ложь;
	НоваяСтрока.ТолькоЧтение = Ложь;
	НоваяСтрока.Корневой = Истина;
	
КонецПроцедуры

// Возвращает представление объекта метаданных.
//
// Параметры:
//  ОбъектМетаданных.
//
// Возвращаемое значение:
//   Строка - представление объекта метаданных.
//
Функция ПредставлениеОбъектаМетаданных(Знач ОбъектМетаданных) Экспорт
	
	СвойстваОбъектовМетаданных = ИнтерфейсODataСлужебный.СвойстваОбъектаМоделиКонфигурации(
		ИнтерфейсODataСлужебныйПовтИсп.ОписаниеМоделиДанныхКонфигурации(), ОбъектМетаданных);
		
	Возврат СвойстваОбъектовМетаданных.Представление;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных независимым набором записей.
//
// Параметры:
//  ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - 
//
Функция ЭтоНезависимыйНаборЗаписей(Знач ОбъектМетаданных) Экспорт
	
	Если ТипЗнч(ОбъектМетаданных) = Тип("Строка") Тогда
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных);
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЭтоРегистрСведений(ОбъектМетаданных)
		И ОбъектМетаданных.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ДеревоОбъектов = Новый ДеревоЗначений();
ДеревоОбъектов.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
ДеревоОбъектов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
ДеревоОбъектов.Колонки.Добавить("Класс", Новый ОписаниеТипов("Число", , Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)));
ДеревоОбъектов.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
ДеревоОбъектов.Колонки.Добавить("Использование", Новый ОписаниеТипов("Булево"));
ДеревоОбъектов.Колонки.Добавить("Подчиненный", Новый ОписаниеТипов("Булево"));
ДеревоОбъектов.Колонки.Добавить("ТолькоЧтение", Новый ОписаниеТипов("Булево"));
ДеревоОбъектов.Колонки.Добавить("Корневой", Новый ОписаниеТипов("Булево"));

СоставСтандартногоИнтерфейса = Новый Массив();

ЗависимостиДобавления = Новый ТаблицаЗначений();
ЗависимостиДобавления.Колонки.Добавить("ИмяОбъекта", Новый ОписаниеТипов("Строка"));
ЗависимостиДобавления.Колонки.Добавить("ИмяЗависимогоОбъекта", Новый ОписаниеТипов("Строка"));

ЗависимостиУдаления = Новый ТаблицаЗначений();
ЗависимостиУдаления.Колонки.Добавить("ИмяОбъекта", Новый ОписаниеТипов("Строка"));
ЗависимостиУдаления.Колонки.Добавить("ИмяЗависимогоОбъекта", Новый ОписаниеТипов("Строка"));

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли