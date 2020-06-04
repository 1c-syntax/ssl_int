﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Делает записи состояний оригиналов печатных форм регистр, после печати формы.
//
//	Параметры:
//	ОбъектыПечати - СписокЗначений - список документов.
//	ПечатныеФормы - СписокЗначений - наименование макетов и представление печатных форм.
//
Процедура ЗаписатьСостоянияОригиналовДокументаПослеПечатиФормы(ОбъектыПечати, ПечатныеФормы) Экспорт
	
	Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана");
	Если ЗначениеЗаполнено(ОбъектыПечати) Тогда
		Если ОбъектыПечати.Количество() > 1 Тогда
			Если ПечатныеФормы.Количество() > 1 Тогда
				Для Каждого Документ Из ОбъектыПечати Цикл
					Если УчетОригиналовПервичныхДокументов.ЭтоОбъектУчета(Документ.Значение) Тогда
					// Записываем общее состояние
						ЗаписатьОбщееСостояниеОригиналаДокумента(Документ.Значение,Состояние);
						Для Каждого Форма Из ПечатныеФормы Цикл //Если документов и форм несколько, записываем для каждого документа, состояние каждой формы
							ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Документ.Значение, Форма.Значение, Форма.Представление, Состояние, Ложь);
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
			Иначе
				Для Каждого Документ Из ОбъектыПечати Цикл
					Если УчетОригиналовПервичныхДокументов.ЭтоОбъектУчета(Документ.Значение) Тогда
						ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Документ.Значение, ПечатныеФормы[0].Значение,ПечатныеФормы[0].Представление, Состояние, Ложь);
						ЗаписатьОбщееСостояниеОригиналаДокумента(Документ.Значение,Состояние);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Иначе
			Документ = ОбъектыПечати[0].Значение;
			Если УчетОригиналовПервичныхДокументов.ЭтоОбъектУчета(Документ) Тогда
				Если ПечатныеФормы.Количество() > 1 Тогда
					Для Каждого Форма Из ПечатныеФормы Цикл
						ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Документ, Форма.Значение,Форма.Представление, Состояние, Ложь);
					КонецЦикла;
				Иначе
					ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Документ, ПечатныеФормы[0].Значение,ПечатныеФормы[0].Представление, Состояние, Ложь);
				КонецЕсли;
				ЗаписатьОбщееСостояниеОригиналаДокумента(Документ,Состояние);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Делает запись состояния оригинала печатной формы в регистр, после печати формы.
//
//	Параметры:
//	Документ - СсылкаДокумент - ссылка на документ.
//	ПечатнаяФорма - Строка - имя макета печатной формы.
//  Представление - Строка - наименование печатной формы.
//	Состояние - Строка
//	          - СсылкаСправочник - наименование или ссылка на состояние оригинала печатной формы.
//	Извне - Булево - признак, показывающий принадлежит ли форма системе 1С.
//
Процедура ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Документ, ПечатнаяФорма, Представление, Состояние, Извне) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка

		ЗаписьСостоянияОригинала = РегистрыСведений.СостоянияОригиналовПервичныхДокументов.СоздатьМенеджерЗаписи();
		ЗаписьСостоянияОригинала.Ссылка = Документ.Ссылка;
		ЗаписьСостоянияОригинала.ПервичныйДокумент = ПечатнаяФорма;
		ЗаписьСостоянияОригинала.ПервичныйДокументПредставление = Представление;
		ЗаписьСостоянияОригинала.Состояние = Справочники.СостоянияОригиналовПервичныхДокументов.НайтиПоНаименованию(Состояние);
		ЗаписьСостоянияОригинала.АвторИзменения = Пользователи.АвторизованныйПользователь();
		ЗаписьСостоянияОригинала.ОбщееСостояние = Ложь;
		ЗаписьСостоянияОригинала.ФормаИзвне = Извне;
		ЗаписьСостоянияОригинала.ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
		ЗаписьСостоянияОригинала.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение	
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

// Делает запись общего состояния оригинала документа в регистр.
//
//	Параметры:
//	Документ - СсылкаДокумент - ссылка на документ.
//	Состояние - Строка - наименование состояния оригинала.
//
Процедура ЗаписатьОбщееСостояниеОригиналаДокумента(Документ, Состояние) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		Элемент = Блокировка.Добавить("РегистрСведений.СостоянияОригиналовПервичныхДокументов");
		Элемент.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();

		ЗаписьСостоянияОригинала = РегистрыСведений.СостоянияОригиналовПервичныхДокументов.СоздатьМенеджерЗаписи();
		ЗаписьСостоянияОригинала.Ссылка = Документ.Ссылка;
		ЗаписьСостоянияОригинала.ПервичныйДокумент = "";
		
		ПроверкаЗаписьСостоянияОригинала = РегистрыСведений.СостоянияОригиналовПервичныхДокументов.СоздатьНаборЗаписей();
		ПроверкаЗаписьСостоянияОригинала.Отбор.Ссылка.Установить(Документ.Ссылка);
		ПроверкаЗаписьСостоянияОригинала.Отбор.ОбщееСостояние.Установить(Ложь);
		ПроверкаЗаписьСостоянияОригинала.Прочитать();
		Если ПроверкаЗаписьСостоянияОригинала.Количество() > 1 Тогда
			Для Каждого Запись Из ПроверкаЗаписьСостоянияОригинала Цикл
				Если Запись.АвторИзменения <> Пользователи.ТекущийПользователь() Тогда
					ЗаписьСостоянияОригинала.АвторИзменения = Неопределено;
				Иначе
					ЗаписьСостоянияОригинала.АвторИзменения = Пользователи.ТекущийПользователь();
				КонецЕсли;
			КонецЦикла;
		Иначе
			ЗаписьСостоянияОригинала.АвторИзменения = Пользователи.ТекущийПользователь();
		КонецЕсли;
		
		Если ПроверкаЗаписьСостоянияОригинала.Количество() > 0 Тогда
			Если УчетОригиналовПервичныхДокументов.СостояниеПечатныхФормОдинаково(Документ,Состояние) Тогда
				ЗаписьСостоянияОригинала.Состояние = Справочники.СостоянияОригиналовПервичныхДокументов.НайтиПоНаименованию(Состояние);
			Иначе
				ЗаписьСостоянияОригинала.Состояние = Справочники.СостоянияОригиналовПервичныхДокументов.ОригиналыНеВсе;
			КонецЕсли;
		Иначе
			ЗаписьСостоянияОригинала.Состояние = Справочники.СостоянияОригиналовПервичныхДокументов.НайтиПоНаименованию(Состояние);
		КонецЕсли;
		

		ЗаписьСостоянияОригинала.ОбщееСостояние = Истина;
		ЗаписьСостоянияОригинала.ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
		ЗаписьСостоянияОригинала.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение	
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

#КонецОбласти

#КонецЕсли

