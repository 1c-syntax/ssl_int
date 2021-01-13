﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Задает настройки мультиязычных данных.
//
// Параметры:
//   Настройки - Структура - коллекция настроек подсистемы. Реквизиты:
//     * КодДополнительногоЯзыка1 - Строка - код первого дополнительного языка по умолчанию.
//     * КодДополнительногоЯзыка2 - Строка - код второго дополнительного языка по умолчанию.
//     * МультиязычныеДанные - Булево - если Истина, то у реквизитов поддерживающих возможность ввода данных на нескольких
//                                       языках будет автоматически добавлен интерфейс ввода мультиязычных данных.
//
// Пример:
//  Настройки.КодДополнительногоЯзыка1 = "en";
//  Настройки.КодДополнительногоЯзыка2 = "it";
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти
