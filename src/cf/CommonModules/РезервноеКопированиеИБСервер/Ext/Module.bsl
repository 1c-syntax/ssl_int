﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Сохраняет параметры резервного копирования.
//
Процедура УстановитьНастройкиРезервногоКопирования(Знач Настройки, Знач Пользователь = Неопределено) Экспорт
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Настройки = НовыеНастройкиРезервногоКопирования();
	КонецЕсли;	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПараметрыРезервногоКопирования", "", Настройки);
	Если Пользователь <> Неопределено Тогда
		ПараметрыКопирования = Новый Структура("Пользователь", Пользователь);
		Константы.ПараметрыРезервногоКопирования.Установить(Новый ХранилищеЗначения(ПараметрыКопирования));
	КонецЕсли;
КонецПроцедуры

// Возвращает текущую настройку резервного копирования строкой.
// Два варианта использования функции - или с передачей всех параметров или без параметров.
//
Функция ТекущаяНастройкаРезервногоКопирования() Экспорт
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	Если НастройкиРезервногоКопирования = Неопределено Тогда
		Возврат НСтр("ru = 'Для настройки резервного копирования необходимо обратиться к администратору.'");
	КонецЕсли;
	
	ТекущаяНастройка = НСтр("ru = 'Резервное копирование не настроено, информационная база подвергается риску потери данных.'");
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Если НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
			
			Если НастройкиРезервногоКопирования.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно при завершении работы.'");
			ИначеЕсли НастройкиРезервногоКопирования.ВариантВыполнения = "ПоРасписанию" Тогда // По расписанию
				Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
				Если Не ПустаяСтрока(Расписание) Тогда
					ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно по расписанию: %1'");
					ТекущаяНастройка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекущаяНастройка, Расписание);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Если НастройкиРезервногоКопирования.РезервноеКопированиеНастроено Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано сторонними программами).'");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано средствами СУБД).'");
		
	КонецЕсли;
	
	Возврат ТекущаяНастройка;
	
КонецФункции

// Ссылка для подстановки в форматированную строку для открытия обработки резервного копирования ИБ.
//
// Возвращаемое значение:
//   Строка - навигационная ссылка.
//
Функция НавигационнаяСсылкаОбработкиРезервногоКопирования() Экспорт
	
	Возврат "e1cib/app/Обработка.РезервноеКопированиеИБ";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// Параметры:
//   ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если ОбщегоНазначения.ЭтоВебКлиент()
		Или ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	ОтключеноУведомлениеОНастройкеРезервногоКопирования = МодульТекущиеДелаСервер.ДелоОтключено("НастроитьРезервноеКопирование");
	ОтключеноУведомлениеОВыполненииРезервногоКопирования = МодульТекущиеДелаСервер.ДелоОтключено("ВыполнитьРезервноеКопирование");
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Обработки.НастройкаРезервногоКопированияИБ)
		Или (ОтключеноУведомлениеОНастройкеРезервногоКопирования
			И ОтключеноУведомлениеОВыполненииРезервногоКопирования) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	Если НастройкиРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВариантОповещения = НастройкиРезервногоКопирования.ПараметрОповещения;
	
	// Процедура вызывается только при наличии подсистемы "Текущие дела", поэтому здесь
	// не делается проверка существования подсистемы.
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Обработки.НастройкаРезервногоКопированияИБ.ПолноеИмя());
	
	Для Каждого Раздел Из Разделы Цикл
		
		Если Не ОтключеноУведомлениеОНастройкеРезервногоКопирования Тогда
			
			ИмяФормыНастройкиРезервногоКопирования = ?(ОбщегоНазначения.ИнформационнаяБазаФайловая(),
				"Обработка.НастройкаРезервногоКопированияИБ.Форма.НастройкаРезервногоКопирования",
				"Обработка.НастройкаРезервногоКопированияИБ.Форма.НастройкаРезервногоКопированияКлиентСервер");
			
			Дело = ТекущиеДела.Добавить();
			Дело.Идентификатор  = "НастроитьРезервноеКопирование" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
			Дело.ЕстьДела       = ВариантОповещения = "ЕщеНеНастроено";
			Дело.Представление  = НСтр("ru = 'Настроить резервное копирование'");
			Дело.Важное         = Истина;
			Дело.Форма          = ИмяФормыНастройкиРезервногоКопирования;
			Дело.Владелец       = Раздел;
		КонецЕсли;
		
		Если Не ОтключеноУведомлениеОВыполненииРезервногоКопирования Тогда
			Дело = ТекущиеДела.Добавить();
			Дело.Идентификатор  = "ВыполнитьРезервноеКопирование" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
			Дело.ЕстьДела       = ВариантОповещения = "Просрочено";
			Дело.Представление  = НСтр("ru = 'Резервное копирование не выполнено'");
			Дело.Важное         = Истина;
			Дело.Форма          = "Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных";
			Дело.Владелец       = Раздел;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", НастройкиРезервногоКопирования(Истина));
	Параметры.Вставить("РезервноеКопированиеИБПриЗавершенииРаботы", ПараметрыПриЗавершенииРаботы());
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", НастройкиРезервногоКопирования());
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриВключенииИспользованияПрофилейБезопасности.
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	Настройки = НастройкиРезервногоКопирования();
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("ПарольАдминистратораИБ") Тогда
		Настройки.ПарольАдминистратораИБ = "";
		УстановитьНастройкиРезервногоКопирования(Настройки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает параметры подсистемы РезервногоКопированияИБ, которые необходимы при завершении работы
// пользователей.
//
// Возвращаемое значение:
//  Структура - параметры.
//
Функция ПараметрыПриЗавершенииРаботы()
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	ВыполнятьПриЗавершенииРаботы = ?(НастройкиРезервногоКопирования = Неопределено, Ложь,
		НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование
		И НастройкиРезервногоКопирования.ВариантВыполнения = "ПриЗавершенииРаботы");
	
	ПараметрыПриЗавершении = Новый Структура;
	ПараметрыПриЗавершении.Вставить("ДоступностьРолейОповещения",   Пользователи.ЭтоПолноправныйПользователь(,Истина));
	ПараметрыПриЗавершении.Вставить("ВыполнятьПриЗавершенииРаботы", ВыполнятьПриЗавершенииРаботы);
	
	Возврат ПараметрыПриЗавершении;
	
КонецФункции

// Возвращает начальное заполнение настроек автоматического резервного копирования.
//
Функция НовыеНастройкиРезервногоКопирования()
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("ВыполнятьАвтоматическоеРезервноеКопирование", Ложь);
	Параметры.Вставить("РезервноеКопированиеНастроено", Ложь);
	
	Параметры.Вставить("ДатаПоследнегоОповещения", '00010101');
	Параметры.Вставить("ДатаПоследнегоРезервногоКопирования", '00010101');
	Параметры.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", '29990101');
	
	Параметры.Вставить("РасписаниеКопирования", ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Новый РасписаниеРегламентногоЗадания));
	Параметры.Вставить("КаталогХраненияРезервныхКопий", "");
	Параметры.Вставить("КаталогХраненияРезервныхКопийПриРучномЗапуске", ""); // При ручном выполнении
	Параметры.Вставить("ПроведеноКопирование", Ложь);
	Параметры.Вставить("ПроведеноВосстановление", Ложь);
	Параметры.Вставить("РезультатКопирования", Неопределено);
	Параметры.Вставить("ИмяФайлаРезервнойКопии", "");
	Параметры.Вставить("ВариантВыполнения", "ПоРасписанию");
	Параметры.Вставить("ПроцессВыполняется", Ложь);
	Параметры.Вставить("АдминистраторИБ", "");
	Параметры.Вставить("ПарольАдминистратораИБ", "");
	Параметры.Вставить("ПараметрыУдаления", ПараметрыУдаленияРезервныхКопийПоУмолчанию());
	Параметры.Вставить("РучнойЗапускПоследнегоРезервногоКопирования", Истина);
	
	Возврат Параметры;
	
КонецФункции

// Возвращает сохраненные параметры резервного копирования.
//
// Возвращаемое значение:
//   Структура - параметры резервного копирования.
//
Функция ПараметрыРезервногоКопирования() Экспорт
	
	Параметры = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыРезервногоКопирования", "");
	Если Параметры = Неопределено Тогда
		Параметры = НовыеНастройкиРезервногоКопирования();
		УстановитьНастройкиРезервногоКопирования(Параметры);
	Иначе
		ДополнитьПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	Возврат Параметры;
	
КонецФункции

// Параметры:
//  ПараметрыРезервногоКопирования - Структура - параметры резервного копирования ИБ.
//
Процедура ДополнитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования)
	
	ПараметрыИзменены = Ложь;
	
	Параметры = НовыеНастройкиРезервногоКопирования();
	Для Каждого ЭлементСтруктуры Из Параметры Цикл
		НайденноеЗначение = Неопределено;
		Если ПараметрыРезервногоКопирования.Свойство(ЭлементСтруктуры.Ключ, НайденноеЗначение) Тогда
			Если НайденноеЗначение = Неопределено И ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		Иначе
			Если ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПараметрыИзменены Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьНастройкиРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Возвращаемое значение:
//   Булево - Истина, если настал момент проведения резервного копирования.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования()
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Параметры = ПараметрыРезервногоКопирования();
	Если Параметры = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Расписание = Параметры.РасписаниеКопирования;
	Если Расписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроцессВыполняется") И Параметры.ПроцессВыполняется Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаПроверки = ТекущаяДатаСеанса();
	ДатаСледующегоКопирования = Параметры.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	Если ДатаСледующегоКопирования = '29990101' Или ДатаСледующегоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаНачалаПроверки = Параметры.ДатаПоследнегоРезервногоКопирования;
	РасписаниеЗначение = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, ДатаНачалаПроверки);
	
КонецФункции

Процедура СброситьПризнакРезервногоКопирования() Экспорт
	
	Настройки = НастройкиРезервногоКопирования();
	Настройки.ПроведеноКопирование = Ложь;
	УстановитьНастройкиРезервногоКопирования(Настройки);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		ИмяОперации = "СтандартныеПодсистемы.РезервноеКопированиеИБ.ВыполненоРезервноеКопирование";
		МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
		МодульЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, 1);
	КонецЕсли;
	
КонецПроцедуры

// Параметры: 
//  ДатаНапоминания - Дата - дата и время последнего оповещения пользователя о необходимости проведения резервного
//	                         копирования.
//
Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	
	Настройки = ПараметрыРезервногоКопирования();
	Настройки.ДатаПоследнегоОповещения = ДатаНапоминания;
	УстановитьНастройкиРезервногоКопирования(Настройки);
	
КонецПроцедуры

// Параметры: 
//  ИмяЭлемента - Строка - имя параметра.
//   ЗначениеЭлемента - Произвольный - значение параметра.
//
Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента) Экспорт
	
	Настройки = ПараметрыРезервногоКопирования();
	Настройки.Вставить(ИмяЭлемента, ЗначениеЭлемента);
	УстановитьНастройкиРезервногоКопирования(Настройки);
	
КонецПроцедуры

// Параметры: 
//  НачалоРаботы - Булево - признак вызова при начале работы программы.
//
// Возвращаемое значение:
//  Структура - параметры резервного копирования.
//
Функция НастройкиРезервногоКопирования(НачалоРаботы = Ложь) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено; 
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(,Истина) Тогда
		Возврат Неопределено; 
	КонецЕсли;
	
	Результат = ПараметрыРезервногоКопирования();
	
	// Определение варианта оповещения пользователя.
	ВариантОповещения = "НеОповещать";
	ОповещатьОНеобходимостиРезервногоКопирования = ТекущаяДатаСеанса() >= (Результат.ДатаПоследнегоОповещения + 3600 * 24);
	Если ИспользуетсяОблачныйАрхив() Тогда 
		ВариантОповещения = "НеОповещать";
	ИначеЕсли Результат.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
		ВариантОповещения = ?(НеобходимостьАвтоматическогоРезервногоКопирования(), "Просрочено", "Настроено");
	ИначеЕсли Не Результат.РезервноеКопированиеНастроено Тогда
		Если ОповещатьОНеобходимостиРезервногоКопирования Тогда	
			НастройкиРезервногоКопирования = Константы.ПараметрыРезервногоКопирования.Получить().Получить();
			Если НастройкиРезервногоКопирования <> Неопределено
				И НастройкиРезервногоКопирования.Пользователь <> Пользователи.ТекущийПользователь() Тогда
				ВариантОповещения = "НеОповещать";
			Иначе
				ВариантОповещения = "ЕщеНеНастроено";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Результат.Вставить("ПараметрОповещения", ВариантОповещения);
	
	Если Результат.ПроведеноКопирование И Результат.РезультатКопирования  Тогда
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		Результат.ДатаПоследнегоРезервногоКопирования = ТекущаяДатаСеанса;
		// Сохранение даты последнего резервного копирования в хранилище общих настроек.
		Настройки = ПараметрыРезервногоКопирования();
		Настройки.ДатаПоследнегоРезервногоКопирования = ТекущаяДатаСеанса;
		УстановитьНастройкиРезервногоКопирования(Настройки);
	КонецЕсли;
	
	Если Результат.ПроведеноВосстановление Тогда
		ОбновитьРезультатВосстановления();
	КонецЕсли;
	
	Если НачалоРаботы И Результат.ПроцессВыполняется Тогда
		Результат.ПроцессВыполняется = Ложь;
		УстановитьЗначениеНастройки("ПроцессВыполняется", Ложь);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИспользуетсяОблачныйАрхив()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		Возврат МодульОблачныйАрхив.РазрешенаРаботаСОблачнымАрхивом();
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ОбновитьРезультатВосстановления()
	
	Настройки = ПараметрыРезервногоКопирования();
	Настройки.ПроведеноВосстановление = Ложь;
	УстановитьНастройкиРезервногоКопирования(Настройки);
	
КонецПроцедуры

Функция ИнформацияОПользователе() Экспорт
	
	ИнформацияОПользователе = Новый Структура("Имя, ТребуетсяВводПароля", "", Ложь);
	ИспользуютсяПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0;
	
	Если Не ИспользуютсяПользователи Тогда
		Возврат ИнформацияОПользователе;
	КонецЕсли;
	
	ТекущийПользователь = СтандартныеПодсистемыСервер.ТекущийПользователь();
	ТребуетсяВводПароля = ТекущийПользователь.ПарольУстановлен И ТекущийПользователь.АутентификацияСтандартная;
	
	ИнформацияОПользователе.Имя = ТекущийПользователь.Имя;
	ИнформацияОПользователе.ТребуетсяВводПароля = ТребуетсяВводПароля;
	
	Возврат ИнформацияОПользователе;
	
КонецФункции

// Записывает признак того, что резервное копирование выполнено.
// Вызывается из скрипта через COM-соединение.
// 
// Параметры:
//  Результат - Булево - результат копирования.
//  ИмяФайлаРезервнойКопии - Строка - имя файла резервной копии.
//
Процедура ЗавершитьРезервноеКопирование(Результат, ИмяФайлаРезервнойКопии =  "") Экспорт
	
	Настройки = НастройкиРезервногоКопирования();
	Настройки.ПроведеноКопирование = Истина;
	Настройки.РезультатКопирования = Результат;
	Настройки.ИмяФайлаРезервнойКопии = ИмяФайлаРезервнойКопии;
	УстановитьНастройкиРезервногоКопирования(Настройки);
	
КонецПроцедуры

// Записывает признак того, что выполнено восстановление из резервной копии.
// Вызывается из скрипта через COM-соединение.
//
// Параметры:
//  Результат - Булево - результат восстановления.
//
Процедура ЗавершитьВосстановление(Результат) Экспорт
	
	Настройки = НастройкиРезервногоКопирования();
	Настройки.ПроведеноВосстановление = Истина;
	УстановитьНастройкиРезервногоКопирования(Настройки);
	
КонецПроцедуры

Функция ПараметрыУдаленияРезервныхКопийПоУмолчанию()
	
	ПараметрыУдаления = Новый Структура;
	ПараметрыУдаления.Вставить("ТипОграничения", "ПоПериоду");
	ПараметрыУдаления.Вставить("КоличествоКопий", 10);
	ПараметрыУдаления.Вставить("ЕдиницаИзмеренияПериода", "Месяц");
	ПараметрыУдаления.Вставить("ЗначениеВЕдиницахИзмерения", 6);
	Возврат ПараметрыУдаления;
	
КонецФункции

// Параметры:
//   ПараметрыСкрипта - см. РезервноеКопированиеИБКлиент.ОбщиеПараметрыСкрипта.
//
Функция ПодготовитьОбщиеПараметрыСкрипта(Знач ПараметрыСкрипта) Экспорт
	
	ПараметрыПодключения = ПараметрыСкрипта.ПараметрыСкрипта;
	СтрокаСоединенияИнформационнойБазы = ПараметрыПодключения.СтрокаСоединенияИнформационнойБазы + ПараметрыПодключения.СтрокаПодключения;
	
	Если СтрЗаканчиваетсяНа(СтрокаСоединенияИнформационнойБазы, ";") Тогда
		СтрокаСоединенияИнформационнойБазы = Лев(СтрокаСоединенияИнформационнойБазы, СтрДлина(СтрокаСоединенияИнформационнойБазы) - 1);
	КонецЕсли;
	
	КаталогПрограммы = ?(ПустаяСтрока(ПараметрыСкрипта.КаталогПрограммы), КаталогПрограммы(), ПараметрыСкрипта.КаталогПрограммы);
	ИмяИсполняемогоФайлаПрограммы = КаталогПрограммы + ПараметрыСкрипта.ИмяФайлаПрограммы;
	
	// Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе; 
	СтрокаПутиКИнформационнойБазе	= ?(ПризнакФайловогоРежима, ПутьКИнформационнойБазе, "");
	
	ПараметрыТекста = Новый Соответствие;
	ПараметрыТекста["[ИмяИсполняемогоФайлаПрограммы]"] = ПодготовитьТекст(ИмяИсполняемогоФайлаПрограммы);
	ПараметрыТекста["[ПараметрПутиКИнформационнойБазе]"] = ПодготовитьТекст(ПараметрПутиКИнформационнойБазе);
	ПараметрыТекста["[СтрокаПутиКФайлуИнформационнойБазы]"] = ПодготовитьТекст(
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", "")));
	ПараметрыТекста["[СтрокаСоединенияИнформационнойБазы]"] = ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы);
	ПараметрыТекста["[ИмяАдминистратора]"] = ПодготовитьТекст(ИмяПользователя());
	ПараметрыТекста["[СобытиеЖурналаРегистрации]"] = ПодготовитьТекст(ПараметрыСкрипта.СобытиеЖурналаРегистрации);
	ПараметрыТекста["[СоздаватьРезервнуюКопию]"] = "true";
	ПараметрыТекста["[ИмяCOMСоединителя]"] = ПодготовитьТекст(ПараметрыСкрипта.ИмяCOMСоединителя);
	ПараметрыТекста["[ИспользоватьCOMСоединитель]"] = ?(ПараметрыСкрипта.ЭтоБазоваяВерсияКонфигурации, "false", "true");
	ПараметрыТекста["[ПараметрыЗапускаПредприятия]"] = ПодготовитьТекст(ПараметрыСкрипта.ПараметрыЗапускаПредприятия);
	ПараметрыТекста["[КодРазблокировки]"] = "РезервноеКопирование";
	
	Возврат ПараметрыТекста;
	
КонецФункции

Функция ПодставитьПараметрыВТекст(Знач Текст, Знач ПараметрыТекста) Экспорт
	
	Результат = Текст;
	Для каждого ПараметрТекста Из ПараметрыТекста Цикл
		Результат = СтрЗаменить(Результат, ПараметрТекста.Ключ, ПараметрТекста.Значение);
	КонецЦикла;
	Возврат Результат; 
	
КонецФункции

Функция ПодготовитьТекст(Знач Текст) Экспорт 
	
	Текст = СтрЗаменить(Текст, "\", "\\");
	Текст = СтрЗаменить(Текст, """", "\""");
	Текст = СтрЗаменить(Текст, "'", "\'");
	Возврат "'" + Текст + "'";
	
КонецФункции

#КонецОбласти
