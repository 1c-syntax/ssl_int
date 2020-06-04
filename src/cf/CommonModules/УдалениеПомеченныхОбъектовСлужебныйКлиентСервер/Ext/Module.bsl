﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Параметры:
// 	Список - ДинамическийСписок
// 	ЗначениеОтбора - Булево
//
Процедура УстановитьОтборПоПометкеУдаления(Список, ЗначениеОтбора) Экспорт
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,,ЗначениеОтбора);
КонецПроцедуры

// Формирует результат вызова метода УдалениеПомеченныхОбъектовКлиент.НачатьУдалениеПомеченных
//
// Возвращаемое значение:
// 	Структура:
//   * УдаленныеКоличество - Число
//   * НеУдаленныеКоличество - Число
//   * АдресРезультата - Строка
//   * Успешно - Булево
//
Функция НовыйСведенияОРезультатахУдаления() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Удаленные", Новый Массив);
	Результат.Вставить("УдаленныеКоличество", 0);
	Результат.Вставить("НеУдаленныеКоличество", 0);
	Результат.Вставить("АдресРезультата", "");
	Результат.Вставить("Успешно", Ложь);
	Возврат Результат;
КонецФункции
#КонецОбласти