﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при изменении данных производственных календарей.
// В случае, если разделение включено, выполняется в не разделенном режиме.
//
// Параметры:
//  УсловияОбновления - ТаблицаЗначений:
//    * КодПроизводственногоКалендаря - Строка - код производственного календаря, данные которого изменились;
//    * Год                           - Число  - календарный год, за который изменились данные.
//
Процедура ПриОбновленииПроизводственныхКалендарей(УсловияОбновления) Экспорт
	
КонецПроцедуры

// Вызывается при изменении данных, зависимых от производственных календарей.
// В случае, если разделение включено, выполняется в областях данных.
//
// Параметры:
//  УсловияОбновления - ТаблицаЗначений:
//    * КодПроизводственногоКалендаря - Строка - код производственного календаря, данные которого изменились;
//    * Год                           - Число  - календарный год, за который изменились данные.
//
Процедура ПриОбновленииДанныхЗависимыхОтПроизводственныхКалендарей(УсловияОбновления) Экспорт
	
КонецПроцедуры

// Вызывается при регистрации отложенного обработчика обновления данных, зависимых от производственных календарей.
// В БлокируемыеОбъекты следует добавить имена метаданных объектов, 
// которые следует заблокировать от использования на период обновления производственных календарей.
//
// Параметры:
//  БлокируемыеОбъекты - Массив - имена метаданных блокируемых объектов.
//
Процедура ПриЗаполненииБлокируемыхОбъектовЗависимыхОтПроизводственныхКалендарей(БлокируемыеОбъекты) Экспорт
	
КонецПроцедуры

// Вызывается при регистрации отложенного обработчика обновления данных, зависимых от производственных календарей.
// В ИзменяемыеОбъекты следует добавить имена метаданных объектов, 
// которые будут изменяться при обновлении производственных календарей.
//
// Параметры:
//  ИзменяемыеОбъекты - Массив - имена метаданных изменяемых объектов.
//
Процедура ПриЗаполненииИзменяемыхОбъектовЗависимыхОтПроизводственныхКалендарей(ИзменяемыеОбъекты) Экспорт
	
КонецПроцедуры

#КонецОбласти
