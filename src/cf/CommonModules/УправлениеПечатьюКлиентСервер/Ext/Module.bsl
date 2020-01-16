﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ИменаПолейКоллекцииПечатныхФорм() Экспорт
	
	Поля = Новый Массив;
	Поля.Добавить("ИмяМакета");
	Поля.Добавить("ИмяВРЕГ");
	Поля.Добавить("СинонимМакета");
	Поля.Добавить("ТабличныйДокумент");
	Поля.Добавить("Экземпляров");
	Поля.Добавить("Картинка");
	Поля.Добавить("ПолныйПутьКМакету");
	Поля.Добавить("ИмяФайлаПечатнойФормы");
	Поля.Добавить("ОфисныеДокументы");
	
	Возврат Поля;
	
КонецФункции

// См. УправлениеПечатью.НапечататьВФайл.
Функция НастройкиСохранения() Экспорт
	
	НастройкиСохранения = Новый Структура;
	НастройкиСохранения.Вставить("ФорматыСохранения", Новый Массив);
	НастройкиСохранения.Вставить("УпаковатьВАрхив", Ложь);
	НастройкиСохранения.Вставить("ПереводитьИменаФайловВТранслит", Ложь);
	НастройкиСохранения.Вставить("ПодписьИПечать", Ложь);
	
	Возврат НастройкиСохранения;
	
КонецФункции

#КонецОбласти
