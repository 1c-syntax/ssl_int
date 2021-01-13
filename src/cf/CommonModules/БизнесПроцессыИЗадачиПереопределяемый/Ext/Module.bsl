﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается для обновления данных бизнес-процесса в регистре сведений ДанныеБизнесПроцессов.
//
// Параметры:
//  Запись - РегистрСведенийЗапись.ДанныеБизнесПроцессов - запись данных бизнес-процесса.
//
Процедура ПриЗаписиСпискаБизнесПроцессов(Запись) Экспорт
	
КонецПроцедуры

// Вызывается для проверки прав на остановку и продолжение бизнес-процесса
// у текущего пользователя.
//
// Параметры:
//  БизнесПроцесс        - ОпределяемыйТип.БизнесПроцессОбъект
//  ЕстьПрава            - Булево - если установить Ложь, то прав нет.
//  СтандартнаяОбработка - Булево - если установить Ложь, то стандартная проверка прав не будет выполнена.
//
Процедура ПриПроверкеПравНаОстановкуБизнесПроцесса(БизнесПроцесс, ЕстьПрава, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается для заполнения реквизита ГлавнаяЗадача из данных заполнения.
//
// Параметры:
//  БизнесПроцессОбъект  - ОпределяемыйТип.БизнесПроцессОбъект
//  ДанныеЗаполнения     - Произвольный        - данные заполнения, которые передаются в обработчик заполнения.
//  СтандартнаяОбработка - Булево              - если установить Ложь, то стандартная обработка заполнения не будет
//                                               выполнена.
//
Процедура ПриЗаполненииГлавнойЗадачиБизнесПроцесса(БизнесПроцессОбъект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается для заполнения параметров формы задачи.
//
// Параметры:
//  ИмяБизнесПроцесса           - Строка                         - название бизнес-процесса.
//  ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.Задание - действие.
//  ПараметрыФормы              - Структура:
//   * ИмяФормы       - имя формы, передаваемое в метод ОткрытьФорму. 
//   * ПараметрыФормы - содержит параметры открываемой формы.
//
// Пример:
//  Если ИмяБизнесПроцесса = "Задание" Тогда
//      ИмяФормы = "БизнесПроцесс.Задание.Форма.ВнешнееДействие" + ТочкаМаршрутаБизнесПроцесса.Имя;
//      ПараметрыФормы.Вставить("ИмяФормы", ИмяФормы);
//  КонецЕсли;
//
Процедура ПриПолученииФормыВыполненияЗадачи(ИмяБизнесПроцесса, ЗадачаСсылка,
	ТочкаМаршрутаБизнесПроцесса, ПараметрыФормы) Экспорт
	
КонецПроцедуры

// Заполняет список бизнес-процессов, которые подключены к подсистеме
// и модули менеджеров которых содержат следующие экспортные процедуры и функции:
//  - ПриПеренаправленииЗадачи.
//  - ФормаВыполненияЗадачи.
//  - ОбработкаВыполненияПоУмолчанию.
//
// Параметры:
//   ПодключенныеБизнесПроцессы - Соответствие из КлючИЗначение:
//     * Ключ - Строка - полное имя объекта метаданных, подключенного к подсистеме;
//     * Значение - Строка - пустая строка.
//
// Пример:
//   ПодключенныеБизнесПроцессы.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "");
//
Процедура ПриОпределенииБизнесПроцессов(ПодключенныеБизнесПроцессы) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из модулей объектов подсистемы БизнесПроцессыИЗадачи для
// возможности настройки логики ограничения в прикладном решении.
//
// Пример заполнения наборов значений доступа см. в комментарии
// к процедуре УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//  Объект - БизнесПроцессОбъект.Задание - объект, для которого нужно заполнить наборы.
//  Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ПриЗаполненииНаборовЗначенийДоступа(Объект, Таблица) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из модуля менеджера справочника РолиИсполнителей при начальном заполнении
// ролей исполнителей в прикладном решении.
//
// Параметры:
//  КодыЯзыков - Массив из Строка - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов 
//                                 справочника РолиИсполнителей.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением. Например:
//                                  Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                  ЭлементТЧ = Элемент.Ключи.Добавить();
//                                  ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииРолейИсполнителей(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из модуля менеджера справочника РолиИсполнителей при начальном заполнении
// элемента роль исполнителя в прикладном решении.
//
// Параметры:
//  Объект                  - СправочникОбъект.РолиИсполнителей - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура
//
Процедура ПриНачальномЗаполненииРолиИсполнителя(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из модуля менеджера ПВХ ОбъектыАдресацииЗадач при начальном заполнении
// объектов адресации задача в прикладном решении.
// Стандартный реквизит ТипЗначения следует заполнять в процедуре ПриНачальномЗаполненииЭлементаОбъектаАдресацииЗадачи.
//
// Параметры:
//  КодыЯзыков - Массив из Строка - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов объекта ПВХ ОбъектыАдресацииЗада.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением. Например:
//                                  Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                  ЭлементТЧ = Элемент.Ключи.Добавить();
//                                  ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииОбъектовАдресацииЗадач(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из модуля менеджера ПВХ ОбъектыАдресацииЗадач при начальном заполнении
// элемента адресации задача в прикладном решении.
//
// Параметры:
//  Объект                  - ПланВидовХарактеристикОбъект.ОбъектыАдресацииЗадач - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура
//
Процедура ПриНачальномЗаполненииЭлементаОбъектаАдресацииЗадачи(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
