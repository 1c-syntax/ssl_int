﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнформацияПоОбновлению = ИнформацияПоОбновлению();
	
	СтандартнаяОбработка = Ложь;
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	ВнешниеНаборыДанных = Новый Структура("СводнаяИнформация, ОбластиСПроблемами",
		ИнформацияПоОбновлению.СводнаяИнформация, ИнформацияПоОбновлению.ИнформацияПоОбработчикам);
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
	
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(2);
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ИнформацияПоОбновлению.СводнаяИнформация.Количество() = 0);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнформацияПоОбновлению()
	
	ПрогрессОбновления = ОбновлениеИнформационнойБазы.ПрогрессОбновленияОбластейДанных("Отложенное");
	СводнаяИнформация = Новый ТаблицаЗначений;
	СводнаяИнформация.Колонки.Добавить("Обновлено");
	СводнаяИнформация.Колонки.Добавить("Выполняется");
	СводнаяИнформация.Колонки.Добавить("Ожидают");
	СводнаяИнформация.Колонки.Добавить("Проблемы");
	
	Строка = СводнаяИнформация.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, ПрогрессОбновления);
	
	Отбор = Новый Структура;
	Отбор.Вставить("РежимВыполнения", "Отложенно");
	Отбор.Вставить("Статус", "Ошибка");
	ИнформацияПоОбработчикам = ОбновлениеИнформационнойБазы.ОбработчикиОбновления(Отбор);
	
	Результат = Новый Структура;
	Результат.Вставить("СводнаяИнформация", СводнаяИнформация);
	Результат.Вставить("ИнформацияПоОбработчикам", ИнформацияПоОбработчикам);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли