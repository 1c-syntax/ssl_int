﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Подключается в ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных.
//
// Параметры:
//   Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
//   МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы
//   Сериализатор - СериализаторXDTO
//   Объект - КонстантаМенеджерЗначения
//          - СправочникОбъект
//          - ДокументОбъект
//          - БизнесПроцессОбъект
//          - ЗадачаОбъект
//          - ПланСчетовОбъект
//          - ПланОбменаОбъект
//          - ПланВидовХарактеристикОбъект
//          - ПланВидовРасчетаОбъект
//          - РегистрСведенийНаборЗаписей
//          - РегистрНакопленияНаборЗаписей
//          - РегистрБухгалтерииНаборЗаписей
//          - РегистрРасчетаНаборЗаписей
//          - ПоследовательностьНаборЗаписей
//          - ПерерасчетНаборЗаписей
//   Артефакты - Массив из ОбъектXDTO
//   Отказ - Булево
//
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	УправлениеДоступомСлужебный.ПередВыгрузкойНабораЗаписей(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ);
	
КонецПроцедуры

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Список - ДинамическийСписок
//  ИмяПоля - Строка
//
Процедура ОформитьПредставлениеТипаЗначенияДоступа(Список, ИмяПоля) Экспорт
	
	ТипыЗначенийДоступа = Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип.Типы();
	
	Для Каждого Тип Из ТипыЗначенийДоступа Цикл
		Типы = Новый Массив;
		Типы.Добавить(Тип);
		ОписаниеТипа = Новый ОписаниеТипов(Типы);
		ПустаяСсылкаТипа = ОписаниеТипа.ПривестиЗначение(Неопределено);
		
		// Оформление.
		ЭлементОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", Строка(Тип));
		
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ПустаяСсылкаТипа;
		ЭлементОтбора.Использование  = Истина;
		
		ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
		ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементПоля.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
