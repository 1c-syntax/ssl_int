﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Рассчитывает итоги всех регистров бухгалтерии и накопления, у которых они включены.
Процедура РассчитатьИтоги() Экспорт
	
	ДатаСеанса = ТекущаяДатаСеанса();
	РегистрНакопленияПериод  = КонецМесяца(ДобавитьМесяц(ДатаСеанса, -1)); // Конец прошлого месяца.
	РегистрБухгалтерииПериод = КонецМесяца(ДатаСеанса); // Конец текущего месяца.
	
	Кэш = КэшПроверкиРазделения();
	
	// Расчет итогов для регистров накопления.
	ВидОстатки = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки;
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыНакопления Цикл
		Если РегистрМетаданные.ВидРегистра <> ВидОстатки Тогда
			Продолжить;
		КонецЕсли;
		Если Не ОбъектМетаданныхДоступенПоРазделению(Кэш, РегистрМетаданные) Тогда
			Продолжить;
		КонецЕсли;
		РегистрНакопленияМенеджер = РегистрыНакопления[РегистрМетаданные.Имя]; // РегистрНакопленияМенеджер
		Если РегистрНакопленияМенеджер.ПолучитьМаксимальныйПериодРассчитанныхИтогов() >= РегистрНакопленияПериод Тогда
			Продолжить;
		КонецЕсли;
		РегистрНакопленияМенеджер.УстановитьМаксимальныйПериодРассчитанныхИтогов(РегистрНакопленияПериод);
		Если Не РегистрНакопленияМенеджер.ПолучитьИспользованиеИтогов()
			Или Не РегистрНакопленияМенеджер.ПолучитьИспользованиеТекущихИтогов() Тогда
			Продолжить;
		КонецЕсли;
		РегистрНакопленияМенеджер.ПересчитатьТекущиеИтоги();
	КонецЦикла;
	
	// Расчет итогов для регистров бухгалтерии.
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыБухгалтерии Цикл
		Если Не ОбъектМетаданныхДоступенПоРазделению(Кэш, РегистрМетаданные) Тогда
			Продолжить;
		КонецЕсли;
		РегистрБухгалтерииМенеджер = РегистрыБухгалтерии[РегистрМетаданные.Имя]; // РегистрБухгалтерииМенеджер
		Если РегистрБухгалтерииМенеджер.ПолучитьМаксимальныйПериодРассчитанныхИтогов() >= РегистрБухгалтерииПериод Тогда
			Продолжить;
		КонецЕсли;
		РегистрБухгалтерииМенеджер.УстановитьМаксимальныйПериодРассчитанныхИтогов(РегистрБухгалтерииПериод);
		Если Не РегистрБухгалтерииМенеджер.ПолучитьИспользованиеИтогов()
			Или Не РегистрБухгалтерииМенеджер.ПолучитьИспользованиеТекущихИтогов() Тогда
			Продолжить;
		КонецЕсли;
		РегистрБухгалтерииМенеджер.ПересчитатьТекущиеИтоги();
	КонецЦикла;
	
	// Регистрация даты.
	Если РежимРаботыЛокальныйФайловый() Тогда
		ПараметрыИтогов = ПараметрыИтоговИАгрегатов();
		ПараметрыИтогов.ДатаРасчетаИтогов = НачалоМесяца(ДатаСеанса);
		ЗаписатьПараметрыИтоговИАгрегатов(ПараметрыИтогов);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
//
// Параметры:
//  Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия              = "2.4.1.1";
	Обработчик.Процедура           = "УправлениеИтогамиИАгрегатамиСлужебный.ОбновитьИспользованиеРегламентныхЗаданий";
	Обработчик.РежимВыполнения     = "Оперативно";
	Обработчик.Идентификатор       = Новый УникальныйИдентификатор("16ec32f9-d68f-4283-9e6f-924a8655d2e4");
	Обработчик.Комментарий         =
		НСтр("ru = 'Включает или отключает обновление и перестроение агрегатов по расписанию,
		|в зависимости от того, есть ли в программе регистры с агрегатами.'");
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы.
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	Если НЕ РежимРаботыЛокальныйФайловый() Тогда
		Возврат;
	КонецЕсли;
	
	// Данные действия необходимо выполнять после всех обработчиков обновления,
	// т.к. в них могут изменить состояние (использование) итогов и агрегатов.
	
	СформироватьПараметрыИтоговИАгрегатов();
	
КонецПроцедуры

// Параметры:
//  ШаблоныЗаданий - см. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов.ШаблоныЗаданий
//
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить("ОбновлениеАгрегатов");
	ШаблоныЗаданий.Добавить("ПерестроениеАгрегатов");
	ШаблоныЗаданий.Добавить("УстановкаПериодаРассчитанныхИтогов");
	
КонецПроцедуры

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
//
// Параметры:
//  ТекущиеДела - см. ТекущиеДелаСлужебный.ТекущиеДела
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	Если Не РежимРаботыЛокальныйФайловый() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаМетаданные = Метаданные.Обработки.СдвигГраницыИтогов;
	Если Не ПравоДоступа("Использование", ОбработкаМетаданные) Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаПолноеИмя = ОбработкаМетаданные.ПолноеИмя();
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(ОбработкаПолноеИмя);
	
	Прототип = Новый Структура("ЕстьДела, Важное, Форма, Представление, Подсказка");
	Прототип.ЕстьДела = НадоСдвинутьГраницуИтогов();
	Прототип.Важное   = Истина;
	Прототип.Форма    = ОбработкаПолноеИмя + ".Форма";
	Прототип.Представление = НСтр("ru = 'Оптимизировать программу'");
	Прототип.Подсказка     = НСтр("ru = 'Ускорить проведение документов и формирование отчетов.
		|Обязательная ежемесячная процедура, может занять некоторое время.'");
	
	Для Каждого Раздел Из Разделы Цикл
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = СтрЗаменить(Прототип.Форма, ".", "") + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
		Дело.Владелец       = Раздел;
		ЗаполнитьЗначенияСвойств(Дело, Прототип);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Выполнение регламентных заданий.

// Обработчик регламентного задания "УстановкаПериодаРассчитанныхИтогов".
Процедура УстановкаПериодаРассчитанныхИтоговОбработчикЗадания() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.УстановкаПериодаРассчитанныхИтогов);
	
	РассчитатьИтоги();
	
КонецПроцедуры

// Обработчик регламентного задания "ОбновлениеАгрегатов".
Процедура ОбновлениеАгрегатовОбработчикЗадания() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбновлениеАгрегатов);
	
	ОбновитьАгрегаты();
	
КонецПроцедуры

// Обработчик регламентного задания "ПерестроениеАгрегатов".
Процедура ПерестроениеАгрегатовОбработчикЗадания() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ПерестроениеАгрегатов);
	
	ПерестроитьАгрегаты();
	
КонецПроцедуры

// Для внутреннего использования.
Процедура ОбновитьАгрегаты()
	
	Кэш = КэшПроверкиРазделения();
	
	// Обновление агрегатов для оборотных регистров накопления.
	ВидОбороты = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Обороты;
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыНакопления Цикл
		Если РегистрМетаданные.ВидРегистра <> ВидОбороты Тогда
			Продолжить;
		КонецЕсли;
		Если Не ОбъектМетаданныхДоступенПоРазделению(Кэш, РегистрМетаданные) Тогда
			Продолжить;
		КонецЕсли;
		РегистрНакопленияМенеджер = РегистрыНакопления[РегистрМетаданные.Имя];
		Если Не РегистрНакопленияМенеджер.ПолучитьРежимАгрегатов()
			Или Не РегистрНакопленияМенеджер.ПолучитьИспользованиеАгрегатов() Тогда
			Продолжить;
		КонецЕсли;
		// Обновление агрегатов.
		РегистрНакопленияМенеджер.ОбновитьАгрегаты();
	КонецЦикла;
КонецПроцедуры

// Для внутреннего использования.
Процедура ПерестроитьАгрегаты()
	
	Кэш = КэшПроверкиРазделения();
	
	// Перестроение агрегатов для оборотных регистров накопления.
	ВидОбороты = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Обороты;
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыНакопления Цикл
		Если РегистрМетаданные.ВидРегистра <> ВидОбороты Тогда
			Продолжить;
		КонецЕсли;
		Если Не ОбъектМетаданныхДоступенПоРазделению(Кэш, РегистрМетаданные) Тогда
			Продолжить;
		КонецЕсли;
		РегистрНакопленияМенеджер = РегистрыНакопления[РегистрМетаданные.Имя];
		Если Не РегистрНакопленияМенеджер.ПолучитьРежимАгрегатов()
			Или Не РегистрНакопленияМенеджер.ПолучитьИспользованиеАгрегатов() Тогда
			Продолжить;
		КонецЕсли;
		// Перестроение агрегатов.
		РегистрНакопленияМенеджер.ПерестроитьИспользованиеАгрегатов();
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы в файловом режиме.

// Возвращает Истина если ИБ работает в файловом режиме и разделение отключено.
Функция РежимРаботыЛокальныйФайловый()
	Возврат ОбщегоНазначения.ИнформационнаяБазаФайловая() И НЕ ОбщегоНазначения.РазделениеВключено();
КонецФункции

// Определяет актуальность итогов и агрегатов. Если нет регистров, то возвращает Истина.
Функция НадоСдвинутьГраницуИтогов() Экспорт
	Параметры = ПараметрыИтоговИАгрегатов();
	Возврат Параметры.ЕстьРегистрыИтогов И ДобавитьМесяц(Параметры.ДатаРасчетаИтогов, 2) < ТекущаяДатаСеанса();
КонецФункции

// Получает значение константы "ПараметрыИтоговИАгрегатов".
Функция ПараметрыИтоговИАгрегатов()
	УстановитьПривилегированныйРежим(Истина);
	Параметры = Константы.ПараметрыИтоговИАгрегатов.Получить().Получить();
	Если ТипЗнч(Параметры) <> Тип("Структура") ИЛИ НЕ Параметры.Свойство("ЕстьРегистрыИтогов") Тогда
		Параметры = СформироватьПараметрыИтоговИАгрегатов();
	КонецЕсли;
	Возврат Параметры;
КонецФункции

// Перезаполняет константу "ПараметрыИтоговИАгрегатов".
Функция СформироватьПараметрыИтоговИАгрегатов()
	Параметры = Новый Структура;
	Параметры.Вставить("ЕстьРегистрыИтогов", Ложь);
	Параметры.Вставить("ДатаРасчетаИтогов",  '39991231235959'); // М1.12.3999 23:59:59, максимальная дата.
	
	ВидОстатки = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки;
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыНакопления Цикл
		Если РегистрМетаданные.ВидРегистра = ВидОстатки Тогда
			РегистрНакопленияМенеджер = РегистрыНакопления[РегистрМетаданные.Имя]; // РегистрНакопленияМенеджер
			Дата = РегистрНакопленияМенеджер.ПолучитьМаксимальныйПериодРассчитанныхИтогов() + 1;
			Параметры.ЕстьРегистрыИтогов = Истина;
			Параметры.ДатаРасчетаИтогов  = Мин(Параметры.ДатаРасчетаИтогов, Дата);
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ Параметры.ЕстьРегистрыИтогов Тогда
		Параметры.Вставить("ДатаРасчетаИтогов", '00010101');
	КонецЕсли;
	
	ЗаписатьПараметрыИтоговИАгрегатов(Параметры);
	
	Возврат Параметры;
КонецФункции

// Записывает значение константы "ПараметрыИтоговИАгрегатов".
Процедура ЗаписатьПараметрыИтоговИАгрегатов(Параметры) Экспорт
	Константы.ПараметрыИтоговИАгрегатов.Установить(Новый ХранилищеЗначения(Параметры));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// [2.3.4.7] Актуализирует использование регламентных заданий ОбновлениеАгрегатов и ПерестроениеАгрегатов.
Процедура ОбновитьИспользованиеРегламентныхЗаданий() Экспорт
	// Регламентные задания "ОбновлениеАгрегатов" и "ПерестроениеАгрегатов".
	ЕстьРегистрыСАгрегатами = ЕстьРегистрыСАгрегатами();
	ОбновитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ОбновлениеАгрегатов, ЕстьРегистрыСАгрегатами);
	ОбновитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ПерестроениеАгрегатов, ЕстьРегистрыСАгрегатами);
	
	// Регламентное задание "УстановкаПериодаРассчитанныхИтогов".
	ОбновитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.УстановкаПериодаРассчитанныхИтогов, Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Другие

// Вспомогательная для процедуры ОбновитьИспользованиеРегламентныхЗаданий.
Процедура ОбновитьРегламентноеЗадание(МетаданныеРегламентногоЗадания, Использование)
	Найденные = РегламентныеЗаданияСервер.НайтиЗадания(Новый Структура("Метаданные", МетаданныеРегламентногоЗадания));
	Для Каждого Задание Из Найденные Цикл
		Изменения = Новый Структура("Использование", Использование);
		// Изменять расписание надо только если оно не было установлено и только в коробке.
		Если Не РасписаниеЗаполнено(Задание.Расписание)
			И Не ОбщегоНазначения.РазделениеВключено() Тогда
			Изменения.Вставить("Расписание", РасписаниеПоУмолчанию(МетаданныеРегламентногоЗадания));
		КонецЕсли;
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, Изменения);
	КонецЦикла;
КонецПроцедуры

// Определяет, задано ли расписание регламентного задания.
//
// Параметры:
//   Расписание - РасписаниеРегламентногоЗадания - расписание регламентного задания.
//
// Возвращаемое значение:
//   Булево - Истина, если расписание регламентного задания задано.
//
Функция РасписаниеЗаполнено(Расписание)
	Возврат Расписание <> Неопределено
		И Строка(Расписание) <> Строка(Новый РасписаниеРегламентногоЗадания);
КонецФункции

// Возвращает расписание регламентного задания по умолчанию.
//   Используется вместо свойства "ОбъектМетаданных: РегламентноеЗадание.Расписание",
//   т.к. оно всегда имеет значение Неопределено.
//
Функция РасписаниеПоУмолчанию(МетаданныеРегламентногоЗадания)
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Если МетаданныеРегламентногоЗадания = Метаданные.РегламентныеЗадания.ОбновлениеАгрегатов Тогда
		Расписание.ВремяНачала = Дата(1, 1, 1, 01, 00, 00);
		ДобавитьДетальноеРасписание(Расписание, "ВремяНачала", Дата(1, 1, 1, 01, 00, 00));
		ДобавитьДетальноеРасписание(Расписание, "ВремяНачала", Дата(1, 1, 1, 14, 00, 00));
	ИначеЕсли МетаданныеРегламентногоЗадания = Метаданные.РегламентныеЗадания.ПерестроениеАгрегатов Тогда
		Расписание.ВремяНачала = Дата(1, 1, 1, 03, 00, 00);
		УстановитьДниНедели(Расписание, "6");
	ИначеЕсли МетаданныеРегламентногоЗадания = Метаданные.РегламентныеЗадания.УстановкаПериодаРассчитанныхИтогов Тогда
		Расписание.ВремяНачала = Дата(1, 1, 1, 01, 00, 00);
		Расписание.ДеньВМесяце = 5;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Возврат Расписание;
КонецФункции

// Вспомогательная для функции РасписаниеПоУмолчанию.
Процедура ДобавитьДетальноеРасписание(Расписание, Ключ, Значение)
	ДетальноеРасписание = Новый РасписаниеРегламентногоЗадания;
	ЗаполнитьЗначенияСвойств(ДетальноеРасписание, Новый Структура(Ключ, Значение));
	Массив = Расписание.ДетальныеРасписанияДня;
	Массив.Добавить(ДетальноеРасписание);
	Расписание.ДетальныеРасписанияДня = Массив;
КонецПроцедуры

// Вспомогательная для функции РасписаниеПоУмолчанию.
Процедура УстановитьДниНедели(Расписание, ДниНеделиВСтроке)
	ДниНедели = Новый Массив;
	МассивСтрок = СтрРазделить(ДниНеделиВСтроке, ",", Ложь);
	Для Каждого СтрокаНомерДняНедели Из МассивСтрок Цикл
		ДниНедели.Добавить(Число(СокрЛП(СтрокаНомерДняНедели)));
	КонецЦикла;
	Расписание.ДниНедели = ДниНедели;
КонецПроцедуры

Функция КэшПроверкиРазделения()
	Кэш = Новый Структура;
	Кэш.Вставить("МодельСервиса", ОбщегоНазначения.РазделениеВключено());
	Если Кэш.МодельСервиса Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			РазделительОсновныхДанных = МодульРаботаВМоделиСервиса.РазделительОсновныхДанных();
			РазделительВспомогательныхДанных = МодульРаботаВМоделиСервиса.РазделительВспомогательныхДанных();
		Иначе
			РазделительОсновныхДанных = Неопределено;
			РазделительВспомогательныхДанных = Неопределено;
		КонецЕсли;
		
		Кэш.Вставить("ВОбластиДанных",                   ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных());
		Кэш.Вставить("РазделительОсновныхДанных",        РазделительОсновныхДанных);
		Кэш.Вставить("РазделительВспомогательныхДанных", РазделительВспомогательныхДанных);
	КонецЕсли;
	Возврат Кэш;
КонецФункции

Функция ОбъектМетаданныхДоступенПоРазделению(Кэш, ОбъектМетаданных)
	Если Не Кэш.МодельСервиса Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ЭтоРазделенныйОбъектМетаданных = МодульРаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ОбъектМетаданных);
	Иначе
		ЭтоРазделенныйОбъектМетаданных = Ложь;
	КонецЕсли;
	
	Возврат Кэш.ВОбластиДанных = ЭтоРазделенныйОбъектМетаданных;
КонецФункции

Функция ЕстьРегистрыСАгрегатами()
	Кэш = КэшПроверкиРазделения();
	ВидОбороты = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Обороты;
	Для Каждого РегистрМетаданные Из Метаданные.РегистрыНакопления Цикл
		Если РегистрМетаданные.ВидРегистра <> ВидОбороты Тогда
			Продолжить;
		КонецЕсли;
		Если Не ОбъектМетаданныхДоступенПоРазделению(Кэш, РегистрМетаданные) Тогда
			Продолжить;
		КонецЕсли;
		РегистрНакопленияМенеджер = РегистрыНакопления[РегистрМетаданные.Имя];
		Если Не РегистрНакопленияМенеджер.ПолучитьРежимАгрегатов()
			Или Не РегистрНакопленияМенеджер.ПолучитьИспользованиеАгрегатов() Тогда
			Продолжить;
		КонецЕсли;
		Возврат Истина;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

#КонецОбласти
