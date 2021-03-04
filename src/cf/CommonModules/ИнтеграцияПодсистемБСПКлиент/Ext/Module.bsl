﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийБТС
// Обработка программных событий, возникающих в подсистемах БТС.
// Только для вызовов из библиотеки БТС в БСП.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - см. ИнтеграцияПодсистемБТС.СобытияБТС.
//
Процедура ПриОпределенииПодписокНаСобытияБТС(Подписки) Экспорт
	
	// ИнформационныйЦентр
	Подписки.ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения = Истина;
	
КонецПроцедуры

#Область ИнформационныйЦентр

// См. ВызовОнлайнПоддержкиКлиент.ОбработкаОповещения.
Процедура ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения(ИмяСобытия, Элемент) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВызовОнлайнПоддержки") Тогда
		МодульВызовОнлайнПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВызовОнлайнПоддержкиКлиент");
		МодульВызовОнлайнПоддержкиКлиент.ОбработкаОповещения(ИмяСобытия, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийБИП
// Обработка программных событий, возникающих в подсистемах ИПП.
// Только для вызовов из библиотеки ИПП в БСП.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура - ключами свойств структуры являются имена событий, на которые
//           подписана эта библиотека.
//
Процедура ПриОпределенииПодписокНаСобытияБИП(Подписки) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область БазоваяФункциональность

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	// Начало замера времени запуска программы.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		Параметры.Модули.Добавить(МодульОценкаПроизводительностиКлиент);
	КонецЕсли;
	
	// Проверка минимальных прав на вход в программу.
	Параметры.Модули.Добавить(ПользователиСлужебныйКлиент);
	
	// Проверка блокировки информационной базы для обновления.
	Параметры.Модули.Добавить(ОбновлениеИнформационнойБазыКлиент);
	
	// Проверка минимально допустимой версии платформы для запуска.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", СтандартныеПодсистемыКлиент, 2));
	
	// Проверка необходимости восстановления связи с главным узлом.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", СтандартныеПодсистемыКлиент, 3));
	
	// Проверка необходимости выбора начальных неизменяемых настроек ИБ (основной язык, часовой пояс).
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", СтандартныеПодсистемыКлиент, 4));

	// Подтверждение легальности перед началом обновления ИБ.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует(
		   "СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
		
		МодульПроверкаЛегальностиПолученияОбновленияКлиент =
			ОбщегоНазначенияКлиент.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
		
		Параметры.Модули.Добавить(МодульПроверкаЛегальностиПолученияОбновленияКлиент);
	КонецЕсли;
	
	// Запрос у пользователя продолжения с повтором или без повтора загрузки сообщения обмена данными.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		Параметры.Модули.Добавить(МодульОбменДаннымиКлиент);
	КонецЕсли;
	
	// Проверка статуса обработчиков отложенного обновления.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 2));
	
	// Загрузка/обновление параметров работы программы.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 3));
	
	// Настройка автономного рабочего места при первом запуске.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		МодульАвтономнаяРаботаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("АвтономнаяРаботаСлужебныйКлиент");
		Параметры.Модули.Добавить(МодульАвтономнаяРаботаСлужебныйКлиент);
	КонецЕсли;
	
	// Проверка авторизации пользователя.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ПользователиСлужебныйКлиент, 2));
	
	// Проверка блокировки входа в информационную базу.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		Параметры.Модули.Добавить(МодульСоединенияИБКлиент);
	КонецЕсли;
	
	// Обновление информационной базы.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 4));
	
	// Обработка ключа запуска ВыполнитьОбновлениеИЗавершитьРаботу.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 5));
	
	// Смена пароля при входе, если требуется.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ПользователиСлужебныйКлиент, 3));
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПередНачаломРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПередНачаломРаботыСистемы(Параметры);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПередНачаломРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПередНачаломРаботыСистемы(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		МодульВариантыОтчетовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВариантыОтчетовКлиент");
		Параметры.Модули.Добавить(МодульВариантыОтчетовКлиент);
	КонецЕсли;
	
	// Открытие помощника настройки подчиненного узла РИБ при первом запуске.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		Параметры.Модули.Добавить(МодульОбменДаннымиКлиент);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		МодульОбменДаннымиВМоделиСервисаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиВМоделиСервисаКлиент");
		Параметры.Модули.Добавить(МодульОбменДаннымиВМоделиСервисаКлиент);
	КонецЕсли;
	
	// Открытие описания изменений системы.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеВерсииИБ") Тогда
		МодульОбновлениеИнформационнойБазыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеИнформационнойБазыКлиент");
		Параметры.Модули.Добавить(МодульОбновлениеИнформационнойБазыКлиент);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		Параметры.Модули.Добавить(МодульОбновлениеКонфигурацииКлиент);
	КонецЕсли;
	
	// Показывает форму блокировки работы с внешними ресурсами, если нужно.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульРегламентныеЗаданияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РегламентныеЗаданияКлиент");
		Параметры.Модули.Добавить(МодульРегламентныеЗаданияКлиент);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		Параметры.Модули.Добавить(МодульРезервноеКопированиеИБКлиент);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторингаКлиентСлужебный = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиентСлужебный");
		Параметры.Модули.Добавить(МодульЦентрМониторингаКлиентСлужебный);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриНачалеРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриНачалеРаботыСистемы(Параметры);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриНачалеРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриНачалеРаботыСистемы(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.ПослеНачалаРаботыСистемы();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульРаботаСБанкамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСБанкамиКлиент");
		МодульРаботаСБанкамиКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалютКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСКурсамиВалютКлиент");
		МодульРаботаСКурсамиВалютКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ИнформацияПриЗапуске") Тогда
		МодульИнформацияПриЗапускеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформацияПриЗапускеКлиент");
		МодульИнформацияПриЗапускеКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйКлиент");
		МодульКонтрольВеденияУчетаСлужебныйКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.НапоминанияПользователя") Тогда
		МодульНапоминанияПользователяКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("НапоминанияПользователяКлиент");
		МодульНапоминанияПользователяКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		МодульОбменДаннымиКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыКлиент.ПослеНачалаРаботыСистемы();
	ПользователиСлужебныйКлиент.ПослеНачалаРаботыСистемы();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульНастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент");
		МодульНастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПослеНачалаРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПослеНачалаРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриОбработкеПараметровЗапуска.
Процедура ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеПараметровЗапуска Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеПараметровЗапуска Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		МодульОбновлениеКонфигурацииКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		МодульОбменДаннымиВМоделиСервисаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиВМоделиСервисаКлиент");
		МодульОбменДаннымиВМоделиСервисаКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиСлужебныйКлиент");
		МодульРаботаСФайламиСлужебныйКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		МодульРезервноеКопированиеИБКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПередЗавершениемРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПередЗавершениемРаботыСистемы Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВариантыОтчетов

// См. ОтчетыКлиентПереопределяемый.ПослеФормирования.
Процедура ПослеФормирования(ФормаОтчета, ОтчетСформирован) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПослеФормирования Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПослеФормирования(ФормаОтчета, ОтчетСформирован);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПослеФормирования Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПослеФормирования(ФормаОтчета, ОтчетСформирован);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаРасшифровки.
Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.АнализЖурналаРегистрации") Тогда
		МодульАнализЖурналаРегистрацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("АнализЖурналаРегистрацииКлиент");
		МодульАнализЖурналаРегистрацииКлиент.ФормаОтчетаОбработкаРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйКлиент");
		МодульКонтрольВеденияУчетаСлужебныйКлиент.ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеДоступомСлужебныйКлиент");
		МодульУправлениеДоступомСлужебныйКлиент.ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеРасшифровки Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеРасшифровки Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаДополнительнойРасшифровки.
Процедура ПриОбработкеДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеДополнительнойРасшифровки Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеДополнительнойРасшифровки Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
Процедура ПриОбработкеКоманды(ФормаОтчета, Команда, Результат) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйКлиент");
		МодульКонтрольВеденияУчетаСлужебныйКлиент.ПриОбработкеКоманды(ФормаОтчета, Команда, Результат);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеКоманды Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеКоманды(ФормаОтчета, Команда, Результат);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеКоманды Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеКоманды(ФормаОтчета, Команда, Результат);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
Процедура ПриОбработкеВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеВыбора Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеВыбора Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаВыбораТабличногоДокумента.
Процедура ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтчетОДвиженияхДокумента") Тогда
		МодульОтчетОДвиженияхДокументаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОтчетОДвиженияхДокументаСлужебныйКлиент");
		МодульОтчетОДвиженияхДокументаСлужебныйКлиент.ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйКлиент");
		МодульКонтрольВеденияУчетаСлужебныйКлиент.ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеДоступомСлужебныйКлиент");
		МодульУправлениеДоступомСлужебныйКлиент.ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеВыбораТабличногоДокумента Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеВыбораТабличногоДокумента Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаОповещения.
Процедура ПриОбработкеОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриОбработкеОповещения Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОбработкеОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриОбработкеОповещения Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОбработкеОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ПриНажатииКнопкиВыбораПериода.
Процедура ПриНажатииКнопкиВыбораПериода(ФормаОтчета, Период, СтандартнаяОбработка, ОбработчикРезультата) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриНажатииКнопкиВыбораПериода Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриНажатииКнопкиВыбораПериода(ФормаОтчета, Период, СтандартнаяОбработка, ОбработчикРезультата);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриНажатииКнопкиВыбораПериода Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриНажатииКнопкиВыбораПериода(ФормаОтчета, Период, СтандартнаяОбработка, ОбработчикРезультата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеРаботыПользователей

// Вызывается при завершении сеанса средствами подсистемы ЗавершениеРаботыПользователей.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - из которой выполняется завершение сеанса,
//  НомераСеансов - Число - число длиной 8 символов, номер сеанса, который будет завершен,
//  СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки завершения сеанса
//    (подключение к агенту сервера через COM-соединение или сервер администрирования с
//    запросом параметров подключения к кластеру у текущего пользователя). Может быть
//    установлен в значение Ложь внутри обработчика события, в этом случае стандартная
//    обработка завершения сеанса выполняться не будет,
//  ОповещениеПослеЗавершенияСеанса - ОписаниеОповещения - описание оповещения, которое должно
//    быть вызвано после завершения сеанса (для автоматического обновления списка активных
//    пользователей). При установке значения параметра СтандартнаяОбработка равным Ложь,
//    после успешного завершения сеанса, для переданного описания оповещения должна быть
//    выполнена обработка с помощью метода ВыполнитьОбработкуОповещения (в качестве значения
//    параметра Результат следует передавать КодВозвратаДиалога.ОК при успешном завершении
//    сеанса). Параметр может быть опущен - в этом случае выполнять обработку оповещения не
//    следует.
//
Процедура ПриЗавершенииСеансов(ФормаВладелец, Знач НомераСеансов, СтандартнаяОбработка, Знач ОповещениеПослеЗавершенияСеанса = Неопределено) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриЗавершенииСеансов Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриЗавершенииСеансов(ФормаВладелец, НомераСеансов, СтандартнаяОбработка, ОповещениеПослеЗавершенияСеанса);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриЗавершенииСеансов Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриЗавершенииСеансов(ФормаВладелец, НомераСеансов, СтандартнаяОбработка, ОповещениеПослеЗавершенияСеанса);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовПослеОткрытия.
Процедура ПечатьДокументовПослеОткрытия(Форма) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПечатьДокументовПослеОткрытия Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПечатьДокументовПослеОткрытия(Форма);
	КонецЕсли;
		
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПечатьДокументовПослеОткрытия Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПечатьДокументовПослеОткрытия(Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовОбработкаНавигационнойСсылки.
Процедура ПечатьДокументовОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПечатьДокументовОбработкаНавигационнойСсылки Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПечатьДокументовОбработкаНавигационнойСсылки(
			Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	КонецЕсли;
		
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПечатьДокументовОбработкаНавигационнойСсылки Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПечатьДокументовОбработкаНавигационнойСсылки(
			Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
Процедура ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПечатьДокументовВыполнитьКоманду Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПечатьДокументовВыполнитьКоманду(
			Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры);
	КонецЕсли;
		
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПечатьДокументовВыполнитьКоманду Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПечатьДокументовВыполнитьКоманду(
			Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрофилиБезопасности

// См. РаботаВБезопасномРежимеКлиентПереопределяемый.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов.
Процедура ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(Идентификаторы, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(Идентификаторы, 
			ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
	КонецЕсли;
		
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(Идентификаторы, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РезервноеКопированиеИБ

// Проверяет возможность выполнения резервного копирования в пользовательском режиме.
//
// Параметры:
//  Результат - Булево - (возвращаемое значение).
//
Процедура ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		МодульРезервноеКопированиеИБКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при предложении создать резервную копию.
Процедура ПриПредложенииПользователюСоздатьРезервнуюКопию() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		МодульРезервноеКопированиеИБКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию();
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБТС().ПриПредложенииПользователюСоздатьРезервнуюКопию Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию();
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБСПКлиентПовтИсп.ПодпискиБИП().ПриПредложенииПользователюСоздатьРезервнуюКопию Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет события, на которые могут подписаться другие библиотеки.
//
// Возвращаемое значение:
//   Структура - ключами свойств структуры являются имена событий, на которые
//               могут быть подписаны библиотеки.
//
Функция СобытияБСП() Экспорт
	
	События = Новый Структура;
	
	// БазоваяФункциональность
	События.Вставить("ПередНачаломРаботыСистемы", Ложь);
	События.Вставить("ПриНачалеРаботыСистемы", Ложь);
	События.Вставить("ПослеНачалаРаботыСистемы", Ложь);
	События.Вставить("ПриОбработкеПараметровЗапуска", Ложь);
	События.Вставить("ПередЗавершениемРаботыСистемы", Ложь);
	
	// ВариантыОтчетов
	События.Вставить("ПослеФормирования", Ложь);
	События.Вставить("ПриОбработкеРасшифровки", Ложь);
	События.Вставить("ПриОбработкеДополнительнойРасшифровки", Ложь);
	События.Вставить("ПриОбработкеКоманды", Ложь);
	События.Вставить("ПриОбработкеВыбора", Ложь);
	События.Вставить("ПриОбработкеВыбораТабличногоДокумента", Ложь);
	События.Вставить("ПриОбработкеОповещения", Ложь);
	События.Вставить("ПриНажатииКнопкиВыбораПериода", Ложь);
	
	// ЗавершениеРаботыПользователей
	События.Вставить("ПриЗавершенииСеансов", Ложь);
	
	// Печать
	События.Вставить("ПечатьДокументовПослеОткрытия", Ложь);
	События.Вставить("ПечатьДокументовОбработкаНавигационнойСсылки", Ложь);
	События.Вставить("ПечатьДокументовВыполнитьКоманду", Ложь);
	
	// ПрофилиБезопасности
	События.Вставить("ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов", Ложь);
	
	// РезервноеКопированиеИБ
	События.Вставить("ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме", Ложь);
	События.Вставить("ПриПредложенииПользователюСоздатьРезервнуюКопию", Ложь);
	
	Возврат События;
	
КонецФункции

#КонецОбласти