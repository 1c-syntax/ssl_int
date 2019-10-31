﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Определение менеджера объекта для вызова прикладных правил.
//
// Параметры:
//   ИмяОбластиПоискаДанных - Строка - Имя области (полное имя метаданных).
//
// Возвращаемое значение:
//   СправочникиМенеджер - , ПланыВидовХарактеристикМенеджер,
//   ПланыСчетовМенеджер, ПланыВидовРасчетаМенеджер - Менеджер объекта.
//
Функция МенеджерОбластиПоискаДублей(Знач ИмяОбластиПоискаДанных) Экспорт
	ОбластьПоискаДанных = Метаданные.НайтиПоПолномуИмени(ИмяОбластиПоискаДанных);
	
	Если Метаданные.Справочники.Содержит(ОбластьПоискаДанных) Тогда
		Возврат Справочники[ОбластьПоискаДанных.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(ОбластьПоискаДанных) Тогда
		Возврат ПланыВидовХарактеристик[ОбластьПоискаДанных.Имя];
		
	ИначеЕсли Метаданные.ПланыСчетов.Содержит(ОбластьПоискаДанных) Тогда
		Возврат ПланыСчетов[ОбластьПоискаДанных.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(ОбластьПоискаДанных) Тогда
		Возврат ПланыВидовРасчета[ОбластьПоискаДанных.Имя];
		
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Некорректный тип объекта метаданных ""%1""'"), ИмяОбластиПоискаДанных);
КонецФункции

// Поиск дублей во всех данных информационной базы.
//
// Параметры:
//     ПараметрыПоиска - Структура - описывает параметры поиска.
//     ЭталонныйОбъект - Произвольный - объект, для которого производится поиск дублей.
//
// Возвращаемое значение:
//   Структура - результаты поиска дублей:
//       * ТаблицаДублей - ТаблицаЗначений - найденные дубли (в интерфейс выводятся в 2 уровня: Родители и Элементы).
//           ** Ссылка       - Произвольный - ссылка элемента.
//           ** Код          - Произвольный - код элемента.
//           ** Наименование - Произвольный - наименование элемента.
//           ** Родитель     - Произвольный - родитель группы дублей. Если Родитель пустой, то элемент является
//                                            родителем группы дублей.
//           ** <Другие поля> - Произвольный - значение соответствующего полей отборов и критериев сравнения дублей.
//       * ОписаниеОшибки - Неопределено - ошибки не возникло.
//                        - Строка - описание ошибки, возникшей в процессе поиска дублей.
//       * МестаИспользования - Неопределено, ТаблицаЗначений - заполняется, если 
//           ПараметрыПоиска.РассчитыватьМестаИспользования = Истина.
//           Описание колонок таблицы см. в ОбщегоНазначения.МестаИспользования.
//
Функция ГруппыДублей(Знач ПараметрыПоиска, Знач ЭталонныйОбъект = Неопределено) Экспорт
	
	ПолноеИмяОбъектаМетаданных = ПараметрыПоиска.ОбластьПоискаДублей;
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	// Уточняем входные параметры.
	РазмерВозвращаемойПорции = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоиска, "МаксимальноеЧислоДублей");
	Если Не ЗначениеЗаполнено(РазмерВозвращаемойПорции) Тогда
		РазмерВозвращаемойПорции = 0; // Без ограничения.
	КонецЕсли;
	
	РассчитыватьМестаИспользования = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоиска, "РассчитыватьМестаИспользования");
	Если ТипЗнч(РассчитыватьМестаИспользования) <> Тип("Булево") Тогда
		РассчитыватьМестаИспользования = Ложь;
	КонецЕсли;
	
	// Вызываем обработчик ПараметрыПоискаДублей.
	ЕстьПравилаПоиска = Ложь;
	ИменаПолейДляСравненияНаРавенство = ""; // Имена реквизитов, по которым сравниваем по равенству.
	ИменаПолейДляСравненияНаПодобие   = ""; // Имена реквизитов, по которым будем нечетко сравнивать.
	ИменаДополнительныхПолей = ""; // Имена реквизитов, дополнительно заказанные прикладными правилами.
	КоличествоЭлементовДляСравнения = 0;  // Сколько отдавать в прикладные правила для расчета.
	ДополнительныеПараметры = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоиска, "ДополнительныеПараметры");
	МенеджерОбластиПоиска = Неопределено;
	
	ПрикладныеПараметрыПоиска = ПоискИУдалениеДублей.ПараметрыПоискаДублей(ПараметрыПоиска.ПравилаПоиска, 
		ПараметрыПоиска.КомпоновщикПредварительногоОтбора);
	Если ЕстьПрикладныеПравилаОбластиПоискаДублей(ПолноеИмяОбъектаМетаданных) Тогда	
		МенеджерОбластиПоиска = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
		МенеджерОбластиПоиска.ПараметрыПоискаДублей(ПрикладныеПараметрыПоиска, ДополнительныеПараметры);
		ЕстьПравилаПоиска = ПараметрыПоиска.УчитыватьПрикладныеПравила;
	КонецЕсли;
		
	СтандартнаяОбработка = Истина;
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииПараметровПоискаДублей(ПолноеИмяОбъектаМетаданных,
		ПрикладныеПараметрыПоиска, ДополнительныеПараметры, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		ЕстьПравилаПоиска = ЕстьПравилаПоиска Или ПараметрыПоиска.УчитыватьПрикладныеПравила;	
	КонецЕсли;		
		
	Если ЕстьПравилаПоиска Тогда
		ВсеДополнительныеПоля = Новый Соответствие;
		Для Каждого Ограничение Из ПрикладныеПараметрыПоиска.ОграниченияСравнения Цикл
			Для Каждого ПолеТаблицы Из Новый Структура(Ограничение.ДополнительныеПоля) Цикл
				ИмяПоля = ПолеТаблицы.Ключ;
				Если ВсеДополнительныеПоля[ИмяПоля] = Неопределено Тогда
					ИменаДополнительныхПолей = ИменаДополнительныхПолей + ", " + ИмяПоля;
					ВсеДополнительныеПоля[ИмяПоля] = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		ИменаДополнительныхПолей = Сред(ИменаДополнительныхПолей, 2);
		КоличествоЭлементовДляСравнения = ПрикладныеПараметрыПоиска.КоличествоЭлементовДляСравнения;
	КонецЕсли;
	
	Для Каждого Строка Из ПараметрыПоиска.ПравилаПоиска Цикл
		Если Строка.Правило = "Равно" Тогда
			ИменаПолейДляСравненияНаРавенство = ИменаПолейДляСравненияНаРавенство + ", " + Строка.Реквизит;
		ИначеЕсли Строка.Правило = "Подобно" Тогда
			ИменаПолейДляСравненияНаПодобие = ИменаПолейДляСравненияНаПодобие + ", " + Строка.Реквизит;
		КонецЕсли
	КонецЦикла;
	ИменаПолейДляСравненияНаРавенство = Сред(ИменаПолейДляСравненияНаРавенство, 2);
	ИменаПолейДляСравненияНаПодобие   = Сред(ИменаПолейДляСравненияНаПодобие, 2);
	
	ПоляДляСравненияНаРавенство   = Новый Структура(ИменаПолейДляСравненияНаРавенство);
	ПоляДляСравненияНаПодобие     = Новый Структура(ИменаПолейДляСравненияНаПодобие);
	ДополнительныеПоля = Новый Структура(ИменаДополнительныхПолей);
	
	// Формируем условия отбора.
	Характеристики = Новый Структура;
	Характеристики.Вставить("ДлинаКода", 0);
	Характеристики.Вставить("ДлинаНомера", 0);
	Характеристики.Вставить("ДлинаНаименования", 0);
	Характеристики.Вставить("Иерархический", Ложь);
	Характеристики.Вставить("ВидИерархии", Неопределено);
	
	ЗаполнитьЗначенияСвойств(Характеристики, ОбъектМетаданных);
	
	ЕстьНаименование = Характеристики.ДлинаНаименования > 0;
	ЕстьКод          = Характеристики.ДлинаКода > 0;
	ЕстьНомер        = Характеристики.ДлинаНомера > 0;
	
	// Задаем псевдонимы дополнительных полей, чтобы не пересекались с остальными полями.
	ТаблицаКандидатов = Новый ТаблицаЗначений;
	КолонкиКандидатов = ТаблицаКандидатов.Колонки;
	КолонкиКандидатов.Добавить("Ссылка1");
	КолонкиКандидатов.Добавить("Поля1");
	КолонкиКандидатов.Добавить("Ссылка2");
	КолонкиКандидатов.Добавить("Поля2");
	КолонкиКандидатов.Добавить("ЭтоДубли", Новый ОписаниеТипов("Булево"));
	ТаблицаКандидатов.Индексы.Добавить("ЭтоДубли");
	
	ИменаПолейВЗапросе = ДоступныеРеквизитыОтбора(ОбъектМетаданных);
	Если Не ЕстьКод Тогда
		Если ЕстьНомер Тогда 
			ИменаПолейВЗапросе = ИменаПолейВЗапросе + ", Номер КАК Код";
		Иначе
			ИменаПолейВЗапросе = ИменаПолейВЗапросе + ", НЕОПРЕДЕЛЕНО КАК Код";
		КонецЕсли;
	КонецЕсли;
	Если Не ЕстьНаименование Тогда
		ИменаПолейВЗапросе = ИменаПолейВЗапросе + ", Ссылка КАК Наименование";
	КонецЕсли;
	ИменаПолейВВыборе  = СтрРазделить(ИменаПолейДляСравненияНаРавенство + "," + ИменаПолейДляСравненияНаПодобие, ",", Ложь);
	
	РасшифровкаДополнительныхПолей = Новый Соответствие;
	ПорядковыйНомер = 0;
	Для Каждого ПолеТаблицы Из ДополнительныеПоля Цикл
		ИмяПоля   = ПолеТаблицы.Ключ;
		Псевдоним = "Доп" + Формат(ПорядковыйНомер, "ЧН=; ЧГ=") + "_" + ИмяПоля;
		РасшифровкаДополнительныхПолей.Вставить(Псевдоним, ИмяПоля);
		
		ИменаПолейВЗапросе = ИменаПолейВЗапросе + "," + ИмяПоля + " КАК " + Псевдоним;
		ИменаПолейВВыборе.Добавить(Псевдоним);
		ПорядковыйНомер = ПорядковыйНомер + 1;
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ #Таблица";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "*", ИменаПолейВЗапросе);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Таблица", ПолноеИмяОбъектаМетаданных);
	
	// Наполнение схемы.
	СхемаКД = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанныхСхемыКД = СхемаКД.ИсточникиДанных.Добавить();
	ИсточникДанныхСхемыКД.Имя = "ИсточникДанных1";
	ИсточникДанныхСхемыКД.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = "ИсточникДанных1";
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	// Инициализация компоновщика.
	КомпоновщикНастроекКД = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
	КомпоновщикНастроекКД.ЗагрузитьНастройки(ПараметрыПоиска.КомпоновщикПредварительногоОтбора.Настройки);
	НастройкиКД = КомпоновщикНастроекКД.Настройки;
	
	// Поля.
	НастройкиКД.Выбор.Элементы.Очистить();
	Для Каждого ИмяПоля Из ИменаПолейВВыборе Цикл
		ПолеКД = Новый ПолеКомпоновкиДанных(СокрЛП(ИмяПоля));
		ДоступноеПолеКД = НастройкиКД.ДоступныеПоляВыбора.НайтиПоле(ПолеКД);
		Если ДоступноеПолеКД = Неопределено Тогда
			ЗаписьЖурналаРегистрации(ПоискИУдалениеДублей.НаименованиеПодсистемы(Ложь),
				УровеньЖурналаРегистрации.Предупреждение, ОбъектМетаданных, ЭталонныйОбъект,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не существует.'"), Строка(ПолеКД)));
			Продолжить;
		КонецЕсли;
		ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКД.Поле = ПолеКД;
	КонецЦикла;
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("Код");
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	
	// Сортировки.
	НастройкиКД.Порядок.Элементы.Очистить();
	ЭлементПорядкаКД = НастройкиКД.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядкаКД.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	// Отборы.
	Если Характеристики.Иерархический
		И Характеристики.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКД.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
		ЭлементОтбораКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораКД.ПравоеЗначение = Ложь;
	КонецЕсли;
	
	Если ОбъектМетаданных = Метаданные.Справочники.Пользователи Тогда
		ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКД.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Служебный");
		ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораКД.ПравоеЗначение = Ложь;
	КонецЕсли;
	
	// Структура.
	НастройкиКД.Структура.Очистить();
	ГруппировкаКД = НастройкиКД.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКД.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКД.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	// Чтение данных оригиналов.
	Если ЭталонныйОбъект = Неопределено Тогда
		ВыборкаЭталонныхОбъектов = ИнициализироватьВыборкуКД(СхемаКД, КомпоновщикНастроекКД.ПолучитьНастройки());
	Иначе
		ТаблицаЗначений = ОбъектВТаблицуЗначений(ЭталонныйОбъект, РасшифровкаДополнительныхПолей);
		Если Не ЕстьКод И Не ЕстьНомер Тогда
			ТаблицаЗначений.Колонки.Добавить("Код", Новый ОписаниеТипов("Неопределено"));
		КонецЕсли;
		ВыборкаЭталонныхОбъектов = ИнициализироватьВыборкуТЗ(ТаблицаЗначений);
	КонецЕсли;
	
	// Подготовка СКД к чтению данных дублей.
	ОтборыКандидатов = Новый Соответствие;
	ИменаПолей = СтрРазделить(ИменаПолейДляСравненияНаРавенство, ",", Ложь);
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		ИмяПоля = СокрЛП(ИмяПоля);
		ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКД.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбораКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборыКандидатов.Вставить(ИмяПоля, ЭлементОтбораКД);
	КонецЦикла;
	ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораКД.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбораКД.ВидСравнения = ?(ЭталонныйОбъект = Неопределено, ВидСравненияКомпоновкиДанных.Больше, ВидСравненияКомпоновкиДанных.НеРавно);
	ОтборыКандидатов.Вставить("Ссылка", ЭлементОтбораКД);
	
	// Результат и цикл поиска
	ТаблицаДублей = Новый ТаблицаЗначений;
	ТаблицаДублей.Колонки.Добавить("Ссылка");
	Для Каждого ПолеТаблицы Из ПоляДляСравненияНаРавенство Цикл
		Если ТаблицаДублей.Колонки.Найти(ПолеТаблицы.Ключ) = Неопределено Тогда
			ТаблицаДублей.Колонки.Добавить(ПолеТаблицы.Ключ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого ПолеТаблицы Из ПоляДляСравненияНаПодобие Цикл
		Если ТаблицаДублей.Колонки.Найти(ПолеТаблицы.Ключ) = Неопределено Тогда
			ТаблицаДублей.Колонки.Добавить(ПолеТаблицы.Ключ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого ИмяПоляТаблицы Из СтрРазделить("Код,Наименование,Родитель,ПометкаУдаления", ",") Цикл
		Если ТаблицаДублей.Колонки.Найти(ИмяПоляТаблицы) = Неопределено Тогда
			ТаблицаДублей.Колонки.Добавить(ИмяПоляТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДублей.Индексы.Добавить("Ссылка");
	ТаблицаДублей.Индексы.Добавить("Родитель");
	ТаблицаДублей.Индексы.Добавить("Ссылка, Родитель");
	
	Результат = Новый Структура("ТаблицаДублей, ОписаниеОшибки, МестаИспользования", ТаблицаДублей);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("РасшифровкаДополнительныхПолей", РасшифровкаДополнительныхПолей);
	СтруктураПолей.Вставить("СтруктураПолейИдентичности",     ПоляДляСравненияНаРавенство);
	СтруктураПолей.Вставить("СтруктураПолейПодобия",          ПоляДляСравненияНаПодобие);
	СтруктураПолей.Вставить("СписокПолейИдентичности",        ИменаПолейДляСравненияНаРавенство);
	СтруктураПолей.Вставить("СписокПолейПодобия",             ИменаПолейДляСравненияНаПодобие);
	
	Пока СледующийЭлементВыборки(ВыборкаЭталонныхОбъектов) Цикл
		ЭталонныйЭлемент = ВыборкаЭталонныхОбъектов.ТекущийЭлемент;
		
		// Установка отборов для выбора кандидатов.
		Для Каждого ЭлементОтбора Из ОтборыКандидатов Цикл
			ЭлементОтбора.Значение.ПравоеЗначение = ЭталонныйЭлемент[ЭлементОтбора.Ключ];
		КонецЦикла;
		
		// Выборка кандидатов данных из СУБД.
		ВыборкаКандидатов = ИнициализироватьВыборкуКД(СхемаКД, НастройкиКД);
		КандидатыДублей = ВыборкаКандидатов.ПроцессорВыводаКД.Вывести(ВыборкаКандидатов.ПроцессорКД);
		
		Если ПоляДляСравненияНаПодобие.Количество() > 0 Тогда
			
			СравнениеСтрокНаПодобие = ПрикладныеПараметрыПоиска.СравнениеСтрокНаПодобие;
			СловаИсключения = СтрСоединить(СравнениеСтрокНаПодобие.СловаИсключения, "~");
			НечеткийПоиск = ОбщегоНазначения.ПодключитьКомпонентуИзМакета("FuzzyStringMatchExtension", "ОбщийМакет.КомпонентаПоискаСтрок");
			Если НечеткийПоиск = Неопределено Тогда
				Результат.ОписаниеОшибки = 
					НСтр("ru = 'Не удалось подключить компоненту нечеткого поиска. Подробнее см. в журнале регистрации.'");
				Возврат Результат;
			КонецЕсли;
			Для Каждого ПолеТаблицы Из ПоляДляСравненияНаПодобие Цикл
				ИмяПоля = ПолеТаблицы.Ключ;
				ИскомыеСтроки = СтрСоединить(КандидатыДублей.ВыгрузитьКолонку(ИмяПоля), "~");
				СтрокаДляПоиска = ЭталонныйЭлемент[ИмяПоля];
				ИндексыСтрок = НечеткийПоиск.StringSearch(НРег(СтрокаДляПоиска), НРег(ИскомыеСтроки), "~", 
					СравнениеСтрокНаПодобие.ДлинаНебольшихСтрок, СравнениеСтрокНаПодобие.ПроцентСовпаденияНебольшихСтрок, 
					СравнениеСтрокНаПодобие.ПроцентСовпаденияСтрок);
				Если ПустаяСтрока(ИндексыСтрок) Тогда
					Продолжить;
				КонецЕсли;
				Для Каждого ИндексСтроки Из СтрРазделить(ИндексыСтрок, ",") Цикл
					Если ПустаяСтрока(ИндексСтроки) Тогда
						Продолжить;
					КонецЕсли;
					ЭлементДубль = КандидатыДублей.Получить(ИндексСтроки);
					Если ЕстьПравилаПоиска Тогда
						ДобавитьСтрокуКандидатов(ТаблицаКандидатов, ЭталонныйЭлемент, ЭлементДубль, СтруктураПолей);
						Если ТаблицаКандидатов.Количество() = КоличествоЭлементовДляСравнения Тогда
							ЗарегистрироватьДублиПоПрикладнымПравилам(ТаблицаДублей, ПолноеИмяОбъектаМетаданных, МенеджерОбластиПоиска, 
								ЭталонныйЭлемент, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
							ТаблицаКандидатов.Очистить();
						КонецЕсли;
					Иначе
						ЗарегистрироватьДубль(ТаблицаДублей, ЭталонныйЭлемент, ЭлементДубль, СтруктураПолей);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		Иначе
			Для Каждого ЭлементДубль Из КандидатыДублей Цикл
				Если ЕстьПравилаПоиска Тогда
					ДобавитьСтрокуКандидатов(ТаблицаКандидатов, ЭталонныйЭлемент, ЭлементДубль, СтруктураПолей);
					Если ТаблицаКандидатов.Количество() = КоличествоЭлементовДляСравнения Тогда
						ЗарегистрироватьДублиПоПрикладнымПравилам(ТаблицаДублей, ПолноеИмяОбъектаМетаданных, МенеджерОбластиПоиска, 
							ЭталонныйЭлемент, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
						ТаблицаКандидатов.Очистить();
					КонецЕсли;
				Иначе
					ЗарегистрироватьДубль(ТаблицаДублей, ЭталонныйЭлемент, ЭлементДубль, СтруктураПолей);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		// Обрабатываем остаток таблицы для прикладных правил.
		Если ЕстьПравилаПоиска Тогда
			ЗарегистрироватьДублиПоПрикладнымПравилам(ТаблицаДублей, ПолноеИмяОбъектаМетаданных, МенеджерОбластиПоиска, 
				ЭталонныйЭлемент, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
			ТаблицаКандидатов.Очистить();
		КонецЕсли;
		
		// Учитываем ограничение.
		Если РазмерВозвращаемойПорции > 0 И (ТаблицаДублей.Количество() > РазмерВозвращаемойПорции) Тогда
			Найдено = ТаблицаДублей.Количество();
			// Откатываем последнюю группу.
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Родитель", ЭталонныйЭлемент.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Ссылка", ЭталонныйЭлемент.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			Если Найдено > 0 И ТаблицаДублей.Количество() = 0 Тогда
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много дублей одного элемента.'");
			Иначе
				Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Найдено слишком много дублей. Показаны только первые %1.'"), РазмерВозвращаемойПорции);
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Расчет мест использования
	Если РассчитыватьМестаИспользования Тогда
		
		ДлительныеОперации.СообщитьПрогресс(0, "РассчитыватьМестаИспользования");
		
		СсылкиОбъектов = Новый Массив;
		Для Каждого СтрокаДублей Из ТаблицаДублей Цикл
			Если ЗначениеЗаполнено(СтрокаДублей.Ссылка) Тогда
				СсылкиОбъектов.Добавить(СтрокаДублей.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		МестаИспользования = МестаИспользованияСсылок(СсылкиОбъектов);
		МестаИспользования = МестаИспользования.Скопировать(
			МестаИспользования.НайтиСтроки(Новый Структура("ВспомогательныеДанные", Ложь)));
		МестаИспользования.Индексы.Добавить("Ссылка");
		
		Результат.Вставить("МестаИспользования", МестаИспользования);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определение наличия прикладных правил у объекта.
//
// Параметры:
//     МенеджерОбласти - СправочникМенеджер - Менеджер проверяемого объекта.
//
// Возвращаемое значение:
//     Булево - Истина, если прикладные правила определены.
//
Функция ЕстьПрикладныеПравилаОбластиПоискаДублей(Знач ИмяОбъекта) Экспорт
	
	СведенияОбОбъекте = ПоискИУдалениеДублей.ОбъектыСПоискомДублей()[ИмяОбъекта];
	Возврат СведенияОбОбъекте <> Неопределено И (СведенияОбОбъекте = "" Или СтрНайти(СведенияОбОбъекте, "ПараметрыПоискаДублей") > 0);
	
КонецФункции

// Обработчик фонового поиска дублей.
//
// Параметры:
//     Параметры       - Структура - Данные для анализа.
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата.
//
Процедура ФоновыйПоискДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикПредварительногоОтбора.Инициализировать( Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.СхемаКомпоновки) );
	КомпоновщикПредварительногоОтбора.ЗагрузитьНастройки(Параметры.НастройкиКомпоновщикаПредварительногоОтбора);
	Параметры.Вставить("КомпоновщикПредварительногоОтбора", КомпоновщикПредварительногоОтбора);
	
	ПравилаПоиска = Новый ТаблицаЗначений;
	ПравилаПоиска.Колонки.Добавить("Реквизит", Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Колонки.Добавить("Правило",  Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Индексы.Добавить("Реквизит");
	Для Каждого Правило Из Параметры.ПравилаПоиска Цикл
		ЗаполнитьЗначенияСвойств(ПравилаПоиска.Добавить(), Правило);
	КонецЦикла;
	Параметры.Вставить("ПравилаПоиска", ПравилаПоиска);
	Параметры.Вставить("РассчитыватьМестаИспользования", Истина);
	
	Результат = ГруппыДублей(Параметры);
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик фонового удаления дублей.
//
// Параметры:
//     Параметры       - Структура - Данные для анализа.
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата.
//
Процедура ФоновоеУдалениеДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	ПараметрыЗамены = Новый Структура;
	ПараметрыЗамены.Вставить("ВключатьБизнесЛогику", Ложь);
	ПараметрыЗамены.Вставить("УчитыватьПрикладныеПравила", Параметры.УчитыватьПрикладныеПравила);
	ПараметрыЗамены.Вставить("ЗаменаПарыВТранзакции", Ложь);
	ПараметрыЗамены.Вставить("СпособУдаления", Параметры.СпособУдаления);
	
	ЗаменитьСсылки(Параметры.ПарыЗамен, ПараметрыЗамены, АдресРезультата);
	
КонецПроцедуры

// Преобразуем объект в таблицу для помещения в запрос.
Функция ОбъектВТаблицуЗначений(Знач ОбъектДанных, Знач РасшифровкаДополнительныхПолей)
	Результат = Новый ТаблицаЗначений;
	СтрокаДанных = Результат.Добавить();
	
	МетаОбъект = ОбъектДанных.Метаданные();
	
	Для Каждого МетаРеквизит Из МетаОбъект.СтандартныеРеквизиты  Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Для Каждого МетаРеквизит Из МетаОбъект.Реквизиты Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из РасшифровкаДополнительныхПолей Цикл
		Имя1 = КлючИЗначение.Ключ;
		Имя2 = КлючИЗначение.Значение;
		Результат.Колонки.Добавить(Имя1, Результат.Колонки[Имя2].ТипЗначения);
		СтрокаДанных[Имя1] = СтрокаДанных[Имя2];
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Дополнительный анализ кандидатов в дубли с помощью обработчика ПриПоискеДублей.
//
Процедура ЗарегистрироватьДублиПоПрикладнымПравилам(СтрокиДереваРезультата, Знач ПолноеИмяОбъектаМетаданных, Знач МенеджерОбластиПоиска, 
	Знач ОсновныеДанные, Знач ТаблицаКандидатов, Знач СтруктураПолей, Знач ДополнительныеПараметры)
	
	Если ТаблицаКандидатов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если МенеджерОбластиПоиска <> Неопределено Тогда
		МенеджерОбластиПоиска.ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры);
	КонецЕсли;
	ПоискИУдалениеДублейПереопределяемый.ПриПоискеДублей(ПолноеИмяОбъектаМетаданных, ТаблицаКандидатов, ДополнительныеПараметры);
	
	Данные1 = Новый Структура;
	Данные2 = Новый Структура;
	
	Найденные = ТаблицаКандидатов.НайтиСтроки(Новый Структура("ЭтоДубли", Истина));
	Для Каждого ПараКандидатов Из Найденные Цикл
		Данные1.Вставить("Ссылка",       ПараКандидатов.Ссылка1);
		Данные1.Вставить("Код",          ПараКандидатов.Поля1.Код);
		Данные1.Вставить("Наименование", ПараКандидатов.Поля1.Наименование);
		Данные1.Вставить("ПометкаУдаления", ПараКандидатов.Поля1.ПометкаУдаления);
		
		Данные2.Вставить("Ссылка",       ПараКандидатов.Ссылка2);
		Данные2.Вставить("Код",          ПараКандидатов.Поля2.Код);
		Данные2.Вставить("Наименование", ПараКандидатов.Поля2.Наименование);
		Данные2.Вставить("ПометкаУдаления", ПараКандидатов.Поля2.ПометкаУдаления);
		
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		
		ЗарегистрироватьДубль(СтрокиДереваРезультата, Данные1, Данные2, СтруктураПолей);
	КонецЦикла;
КонецПроцедуры

// Добавить строку в таблицу кандидатов для прикладного метода.
//
Функция ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	Строка = ТаблицаКандидатов.Добавить();
	Строка.ЭтоДубли = Ложь;
	Строка.Ссылка1  = ДанныеОсновногоЭлемента.Ссылка;
	Строка.Ссылка2  = ДанныеКандидата.Ссылка;
	
	Строка.Поля1 = Новый Структура("Код, Наименование, ПометкаУдаления", 
		ДанныеОсновногоЭлемента.Код, ДанныеОсновногоЭлемента.Наименование, ДанныеОсновногоЭлемента.ПометкаУдаления);
	Строка.Поля2 = Новый Структура("Код, Наименование, ПометкаУдаления", 
		ДанныеКандидата.Код, ДанныеКандидата.Наименование, ДанныеКандидата.ПометкаУдаления);
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.РасшифровкаДополнительныхПолей Цикл
		ИмяКолонки = КлючЗначение.Значение;
		ИмяПоля    = КлючЗначение.Ключ;
		
		Строка.Поля1.Вставить(ИмяКолонки, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяКолонки, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Возврат Строка;
КонецФункции

// Добавить в дерево результатов найденный дубль.
//
Процедура ЗарегистрироватьДубль(ТаблицаДублей, Знач Элемент1, Знач Элемент2, Знач СтруктураПолей)
	// Определить какой элемент уже добавлен в дубли.
	СтрокаДублей1 = ТаблицаДублей.Найти(Элемент1.Ссылка, "Ссылка");
	СтрокаДублей2 = ТаблицаДублей.Найти(Элемент2.Ссылка, "Ссылка");
	Дубль1Зарегистрирован = (СтрокаДублей1 <> Неопределено);
	Дубль2Зарегистрирован = (СтрокаДублей2 <> Неопределено);
	
	// Если оба элемента добавлены в дубли, то ничего делать не надо.
	Если Дубль1Зарегистрирован И Дубль2Зарегистрирован Тогда
		Возврат;
	КонецЕсли;
	
	// Перед регистрацией дубля определить ссылку группы дублей.
	Если Дубль1Зарегистрирован Тогда
		СсылкаГруппыДублей = ?(ЗначениеЗаполнено(СтрокаДублей1.Родитель), СтрокаДублей1.Родитель, СтрокаДублей1.Ссылка);
	ИначеЕсли Дубль2Зарегистрирован Тогда
		СсылкаГруппыДублей = ?(ЗначениеЗаполнено(СтрокаДублей2.Родитель), СтрокаДублей2.Родитель, СтрокаДублей2.Ссылка);
	Иначе // Регистрация группы дублей.
		ГруппаДублей = ТаблицаДублей.Добавить();
		ГруппаДублей.Ссылка = Элемент1.Ссылка;
		СсылкаГруппыДублей = ГруппаДублей.Ссылка;
	КонецЕсли;
	
	СписокСвойств = "Ссылка,Код,Наименование,ПометкаУдаления," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия;
	
	Если Не Дубль1Зарегистрирован Тогда
		СведенияОДубле = ТаблицаДублей.Добавить();
		ЗаполнитьЗначенияСвойств(СведенияОДубле, Элемент1, СписокСвойств);
		СведенияОДубле.Родитель = СсылкаГруппыДублей;
	КонецЕсли;
	
	Если Не Дубль2Зарегистрирован Тогда
		СведенияОДубле = ТаблицаДублей.Добавить();
		ЗаполнитьЗначенияСвойств(СведенияОДубле, Элемент2, СписокСвойств);
		СведенияОДубле.Родитель = СсылкаГруппыДублей;
	КонецЕсли;
	
	ДлительныеОперации.СообщитьПрогресс(ТаблицаДублей.Количество(), "ЗарегистрироватьДубль");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для автономной работы.

// [ОбщегоНазначения.МестаИспользования]
Функция МестаИспользованияСсылок(Знач НаборСсылок, Знач АдресРезультата = "")
	
	Возврат ОбщегоНазначения.МестаИспользования(НаборСсылок, АдресРезультата);
	
КонецФункции

// [ОбщегоНазначения.ЗаменитьСсылки]
Процедура ЗаменитьСсылки(Знач ПарыЗамен, Знач Параметры = Неопределено, Знач АдресРезультата = "")
	
	Результат = ОбщегоНазначения.ЗаменитьСсылки(ПарыЗамен, Параметры);
	
	Если АдресРезультата <> "" Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие.

Функция ДоступныеРеквизитыОтбора(ОбъектМетаданных)
	МассивРеквизитов = Новый Массив;
	Для Каждого РеквизитМетаданные Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		Если РеквизитМетаданные.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			Продолжить;
		КонецЕсли;
		МассивРеквизитов.Добавить(РеквизитМетаданные.Имя);
	КонецЦикла;
	Для Каждого РеквизитМетаданные Из ОбъектМетаданных.Реквизиты Цикл
		Если РеквизитМетаданные.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			Продолжить;
		КонецЕсли;
		МассивРеквизитов.Добавить(РеквизитМетаданные.Имя);
	КонецЦикла;
	Возврат СтрСоединить(МассивРеквизитов, ",");
КонецФункции

Функция ИнициализироватьВыборкуКД(СхемаКД, НастройкиКД)
	Выборка = Новый Структура("Таблица, ТекущийЭлемент, Индекс, ВГраница, ПроцессорКД, ПроцессорВыводаКД");
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКД, НастройкиКД, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	Выборка.ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	Выборка.ПроцессорКД.Инициализировать(МакетКД);
	
	Выборка.Таблица = Новый ТаблицаЗначений;
	Выборка.Индекс = -1;
	Выборка.ВГраница = -100;
	
	Выборка.ПроцессорВыводаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Выборка.ПроцессорВыводаКД.УстановитьОбъект(Выборка.Таблица);
	
	Возврат Выборка;
КонецФункции

Функция ИнициализироватьВыборкуТЗ(ТаблицаЗначений)
	Выборка = Новый Структура("Таблица, ТекущийЭлемент, Индекс, ВГраница, ПроцессорКД, ПроцессорВыводаКД");
	Выборка.Таблица = ТаблицаЗначений;
	Выборка.Индекс = -1;
	Выборка.ВГраница = ТаблицаЗначений.Количество() - 1;
	Возврат Выборка;
КонецФункции

Функция СледующийЭлементВыборки(Выборка)
	Если Выборка.Индекс >= Выборка.ВГраница Тогда
		Если Выборка.ПроцессорКД = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Выборка.ВГраница = -100 Тогда
			Выборка.ПроцессорВыводаКД.НачатьВывод();
		КонецЕсли;
		Выборка.Таблица.Очистить();
		Выборка.Индекс = -1;
		Выборка.ВГраница = -1;
		Пока Выборка.ВГраница = -1 Цикл
			ЭлементРезультатаКД = Выборка.ПроцессорКД.Следующий();
			Если ЭлементРезультатаКД = Неопределено Тогда
				Выборка.ПроцессорВыводаКД.ЗакончитьВывод();
				Возврат Ложь;
			КонецЕсли;
			Выборка.ПроцессорВыводаКД.ВывестиЭлемент(ЭлементРезультатаКД);
			Выборка.ВГраница = Выборка.Таблица.Количество() - 1;
		КонецЦикла;
	КонецЕсли;
	Выборка.Индекс = Выборка.Индекс + 1;
	Выборка.ТекущийЭлемент = Выборка.Таблица[Выборка.Индекс];
	Возврат Истина;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли