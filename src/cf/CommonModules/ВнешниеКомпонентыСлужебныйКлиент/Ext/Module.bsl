﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоКомпонентаИзХранилища(Местоположение) Экспорт
	
	Если СтрНачинаетсяС(Местоположение, "e1cib/data/Справочник.ВнешниеКомпоненты.ХранилищеКомпоненты") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
		МодульВнешниеКомпонентыВМоделиСервисаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебныйКлиент");
		Если МодульВнешниеКомпонентыВМоделиСервисаСлужебныйКлиент.ЭтоКомпонентаИзХранилища(Местоположение) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверитьДоступностьКомпоненты

// Параметры:
//  Оповещение - ОписаниеОповещения - 
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты
//
Процедура ПроверитьДоступностьКомпоненты(Оповещение, Контекст)
	
	Информация = ВнешниеКомпонентыСлужебныйВызовСервера.ИнформацияОСохраненнойКомпоненте(
		Контекст.Идентификатор, 
		Контекст.Версия);
	
	Контекст.Вставить("Местоположение", Информация.Местоположение);
	
	// Информация.Состояние:
	// * НеНайдена
	// * НайденаВХранилище
	// * НайденаВОбщемХранилище
	// * ОтключенаАдминистратором
	
	Результат = РезультатДоступностиКомпоненты();
	
	Если Информация.Состояние = "ОтключенаАдминистратором" Тогда 
		
		Результат.ОписаниеОшибки = НСтр("ru = 'Отключена администратором.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		
	ИначеЕсли Информация.Состояние = "НеНайдена" Тогда 
		
		Если Информация.ДоступнаЗагрузкаСПортала 
			И Контекст.ПредложитьЗагрузить Тогда 
			
			КонтекстПоиска = Новый Структура;
			КонтекстПоиска.Вставить("Оповещение", Оповещение);
			КонтекстПоиска.Вставить("Контекст", Контекст);
			
			ОповещениеФормы = Новый ОписаниеОповещения(
				"ПроверитьДоступностьКомпонентыПослеПоискаКомпонентыНаПортале", 
				ЭтотОбъект, 
				КонтекстПоиска);
			
			ПоискКомпонентыНаПортале(ОповещениеФормы, Контекст);
			
		Иначе 
			Результат.ОписаниеОшибки = НСтр("ru = 'Компонента отсутствует в списке разрешенных внешних компонент.'");
			ВыполнитьОбработкуОповещения(Оповещение, Результат);
		КонецЕсли;
		
	Иначе
		
		Если ТекущийКлиентПоддерживаетсяКомпонентой(Информация.Реквизиты) Тогда
			
			Результат.Доступна = Истина;
			ВыполнитьОбработкуОповещения(Оповещение, Результат);
			
		Иначе 
			
			ОповещениеФормы = Новый ОписаниеОповещения(
				"ПроверитьДоступностьКомпонентыПослеОтображенияДоступныхВидовКлиентов", 
				ЭтотОбъект, 
				Оповещение);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ТекстПояснения", Контекст.ТекстПояснения);
			ПараметрыФормы.Вставить("ПоддерживаемыеКлиенты", Информация.Реквизиты);
			
			ОткрытьФорму("ОбщаяФорма.УстановкаВнешнейКомпонентыНевозможна", 
				ПараметрыФормы,,,,, ОповещениеФормы);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДоступностьКомпонентыПослеПоискаКомпонентыНаПортале(Загружена, КонтекстПоиска) Экспорт
	
	Оповещение = КонтекстПоиска.Оповещение;
	Контекст   = КонтекстПоиска.Контекст;
	
	Если Загружена Тогда
		Контекст.ПредложитьЗагрузить = Ложь;
		ПроверитьДоступностьКомпоненты(Оповещение, Контекст);
	Иначе 
		ВыполнитьОбработкуОповещения(Оповещение, РезультатДоступностиКомпоненты());
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДоступностьКомпонентыПослеОтображенияДоступныхВидовКлиентов(Результат, Оповещение) Экспорт
	
	ВыполнитьОбработкуОповещения(Оповещение, РезультатДоступностиКомпоненты());
	
КонецПроцедуры

Функция РезультатДоступностиКомпоненты()
	
	Результат = Новый Структура;
	Результат.Вставить("Доступна", Ложь);
	Результат.Вставить("ОписаниеОшибки");
	
	Возврат Результат;
	
КонецФункции

Функция ТекущийКлиентПоддерживаетсяКомпонентой(Реквизиты)
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Браузер = Неопределено;
#Если ВебКлиент Тогда
	Строка = СистемнаяИнформация.ИнформацияПрограммыПросмотра;
	
	Если СтрНайти(Строка, "Chrome/") > 0 Тогда
		Браузер = "Chrome";
	ИначеЕсли СтрНайти(Строка, "MSIE") > 0 Тогда
		Браузер = "MSIE";
	ИначеЕсли СтрНайти(Строка, "Safari/") > 0 Тогда
		Браузер = "Safari";
	ИначеЕсли СтрНайти(Строка, "Firefox/") > 0 Тогда
		Браузер = "Firefox";
	КонецЕсли;
#КонецЕсли
	
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		
		Если Браузер = Неопределено Тогда
			Возврат Реквизиты.Linux_x86;
		КонецЕсли;
		
		Если Браузер = "Firefox" Тогда
			Возврат Реквизиты.Linux_x86_Firefox;
		КонецЕсли;
		
		Если Браузер = "Chrome" Тогда
			Возврат Реквизиты.Linux_x86_Chrome;
		КонецЕсли;
			
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		
		Если Браузер = Неопределено Тогда
			Возврат Реквизиты.Linux_x86_64;
		КонецЕсли;
		
		Если Браузер = "Firefox" Тогда
			Возврат Реквизиты.Linux_x86_64_Firefox;
		КонецЕсли;
		
		Если Браузер = "Chrome" Тогда
			Возврат Реквизиты.Linux_x86_64_Chrome;
		КонецЕсли;
		
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда
		
		Если Браузер = Неопределено Тогда
			Возврат Реквизиты.MacOS_x86_64;
		КонецЕсли;
		
		Если Браузер = "Safari" Тогда
			Возврат Реквизиты.MacOS_x86_64_Safari;
		КонецЕсли;
		
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		
		Если Браузер = Неопределено Тогда
			Возврат Реквизиты.Windows_x86;
		КонецЕсли;
		
		Если Браузер = "Firefox" Тогда
			Возврат Реквизиты.Windows_x86_Firefox;
		КонецЕсли;
		
		Если Браузер = "Chrome" Тогда
			Возврат Реквизиты.Windows_x86_Chrome;
		КонецЕсли;
		
		Если Браузер = "MSIE" Тогда
			Возврат Реквизиты.Windows_x86_MSIE;
		КонецЕсли;
		
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		Если Браузер = Неопределено Тогда
			Возврат Реквизиты.Windows_x86_64;
		КонецЕсли;
		
		Если Браузер = "Firefox" Тогда
			Возврат Реквизиты.Windows_x86_Firefox;
		КонецЕсли;
		
		Если Браузер = "Chrome" Тогда
			Возврат Реквизиты.Windows_x86_Chrome;
		КонецЕсли;
		
		Если Браузер = "MSIE" Тогда
			Возврат Реквизиты.Windows_x86_64_MSIE;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область ПодключитьКомпоненту

Процедура ПодключитьКомпоненту(Контекст) Экспорт 
	
	Оповещение = Новый ОписаниеОповещения(
		"ПодключитьКомпонентуПослеПроверкиДоступности", 
		ЭтотОбъект, 
		Контекст);
	
	ПроверитьДоступностьКомпоненты(Оповещение, Контекст);
	
КонецПроцедуры

// Параметры:
//  Результат - Структура - результат подключения компоненты:
//    * Подключено - Булево - признак подключения;
//    * ПодключаемыйМодуль - AddIn - экземпляр объекта внешней компоненты.
//    * ОписаниеОшибки - Строка - краткое описание ошибки. При отмене пользователем пустая строка
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты
//
Процедура ПодключитьКомпонентуПослеПроверкиДоступности(Результат, Контекст) Экспорт
	
	Если Результат.Доступна Тогда 
		ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпоненту(Контекст);
	Иначе
		Если Не ПустаяСтрока(Результат.ОписаниеОшибки) Тогда 
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
				           |из хранилища внешних компонент
				           |по причине:
				           |%2'"),
				Контекст.Идентификатор,
				Результат.ОписаниеОшибки);
		КонецЕсли;
		
		ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключитьКомпонентуИзРеестраWindows

// см. функцию ВнешниеКомпонентыКлиент.ПодключитьКомпонентуИзРеестраWindows.
//
// Параметры:
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты
//
Процедура ПодключитьКомпонентуИзРеестраWindows(Контекст) Экспорт
	
	Если ПодключитьКомпонентуИзРеестраWindowsДоступноПодключение() Тогда
		
		Оповещение = Новый ОписаниеОповещения(
		"ПодключитьКомпонентуИзРеестраWindowsПослеПопыткиПодключения", ЭтотОбъект, Контекст,
		"ПодключитьКомпонентуИзРеестраWindowsПриОбработкеОшибки", ЭтотОбъект);
		
		НачатьПодключениеВнешнейКомпоненты(Оповещение, "AddIn." + Контекст.Идентификатор);
		
	Иначе 
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
			           |из реестра Windows
			           |по причине:
			           |Подключить компоненту из реестра Windows возможно только в тонком или толстом клиентах Windows.'"),
		Контекст.Идентификатор);
		
		ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпонентуИзРеестраWindows.
//
// Параметры:
//  Подключено - Булево - 
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты
//
Процедура ПодключитьКомпонентуИзРеестраWindowsПослеПопыткиПодключения(Подключено, Контекст) Экспорт
	
	Если Подключено Тогда 
		
		ИдентификаторСозданияОбъекта = Контекст.ИдентификаторСозданияОбъекта;
			
		Если ИдентификаторСозданияОбъекта = Неопределено Тогда 
			ИдентификаторСозданияОбъекта = Контекст.Идентификатор;
		КонецЕсли;
		
		Попытка
			ПодключаемыйМодуль = Новый("AddIn." + ИдентификаторСозданияОбъекта);
			Если ПодключаемыйМодуль = Неопределено Тогда 
				ВызватьИсключение НСтр("ru = 'Оператор Новый вернул Неопределено'");
			КонецЕсли;
		Исключение
			ПодключаемыйМодуль = Неопределено;
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		Если ПодключаемыйМодуль = Неопределено Тогда 
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать объект внешней компоненты ""%1"", подключенной на клиенте
				           |из реестра Windows,
				           |по причине:
				           |%2'"),
				Контекст.Идентификатор,
				ТекстОшибки);
				
			ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
			
		Иначе 
			ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпонентуОповеститьОПодключении(ПодключаемыйМодуль, Контекст);
		КонецЕсли;
		
	Иначе 
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
			           |из реестра Windows
			           |по причине:
			           |Метод НачатьПодключениеВнешнейКомпоненты вернул Ложь.'"),
			Контекст.Идентификатор);
			
		ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпонентуИзРеестраWindows.
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке - 
//  СтандартнаяОбработка - Булево - 
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты
//
Процедура ПодключитьКомпонентуИзРеестраWindowsПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
		           |из реестра Windows
		           |по причине:
		           |%2'"),
		Контекст.Идентификатор,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
	ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпонентуИзРеестраWindows.
Функция ПодключитьКомпонентуИзРеестраWindowsДоступноПодключение()
	
#Если ВебКлиент Тогда
	Возврат Ложь;
#Иначе
	Возврат ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
#КонецЕсли
	
КонецФункции

#КонецОбласти

#Область УстановитьКомпоненту

Процедура УстановитьКомпоненту(Контекст) Экспорт
	
	Оповещение = Новый ОписаниеОповещения(
		"УстановитьКомпонентуПослеПроверкиДоступности", 
		ЭтотОбъект, 
		Контекст);
	
	ПроверитьДоступностьКомпоненты(Оповещение, Контекст);
	
КонецПроцедуры

// Параметры:
//  Результат - Структура - результат подключения компоненты:
//    * Подключено - Булево - признак подключения;
//    * ПодключаемыйМодуль - AddIn - экземпляр объекта внешней компоненты.
//    * ОписаниеОшибки - Строка - краткое описание ошибки. При отмене пользователем пустая строка.
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты 
//
Процедура УстановитьКомпонентуПослеПроверкиДоступности(Результат, Контекст) Экспорт
	
	Если Результат.Доступна Тогда 
		ОбщегоНазначенияСлужебныйКлиент.УстановитьКомпоненту(Контекст);
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
			           |из хранилища внешних компонент
			           |по причине:
			           |%2'"),
			Контекст.Идентификатор,
			Результат.ОписаниеОшибки);
			
		ОбщегоНазначенияСлужебныйКлиент.УстановитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузитьКомпонентуИзФайла

// см. функцию ВнешниеКомпонентыКлиент.ЗагрузитьКомпонентуИзФайла.
//
// Параметры:
//  Контекст - см. ВнешниеКомпонентыКлиент.КонтекстПодключенияКомпоненты
//
Процедура ЗагрузитьКомпонентуИзФайла(Контекст) Экспорт 
	
	Информация = ВнешниеКомпонентыСлужебныйВызовСервера.ИнформацияОСохраненнойКомпоненте(Контекст.Идентификатор, Контекст.Версия);
	
	Если Информация.ДоступнаЗагрузкаИзФайла Тогда
		
		ПараметрыПоискаДополнительнойИнформации = Контекст.ПараметрыПоискаДополнительнойИнформации;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказатьДиалогЗагрузкиИзФайлаПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ВернутьРезультатЗагрузкиИзФайла", Истина);
		ПараметрыФормы.Вставить("ПараметрыПоискаДополнительнойИнформации", ПараметрыПоискаДополнительнойИнформации);
		
		Если Информация.Состояние = "НайденаВХранилище"
			Или Информация.Состояние = "ОтключенаАдминистратором" Тогда
			
			ПараметрыФормы.Вставить("ПоказатьДиалогЗагрузкиИзФайлаПриОткрытии", Ложь);
			ПараметрыФормы.Вставить("Ключ", Информация.Ссылка);
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьКомпонентуИзФайлаПослеЗагрузки", ЭтотОбъект, Контекст);
		ОткрытьФорму("Справочник.ВнешниеКомпоненты.ФормаОбъекта", ПараметрыФормы,,,,, Оповещение);
		
	Иначе 
		
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьКомпонентуИзФайлаПослеПредупрежденияДоступности", ЭтотОбъект, Контекст);
		ПоказатьПредупреждение(Оповещение, 
			НСтр("ru = 'Загрузка внешней компоненты прервана
			           |по причине:
			           |Требуются права администратора'"));
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЗагрузитьКомпонентуИзФайла.
Процедура ЗагрузитьКомпонентуИзФайлаПослеПредупрежденияДоступности(Контекст) Экспорт
	
	Результат = РезультатЗагрузкиКомпоненты();
	Результат.Загружена = Ложь;
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ЗагрузитьКомпонентуИзФайла.
Процедура ЗагрузитьКомпонентуИзФайлаПослеЗагрузки(Результат, Контекст) Экспорт
	
	// Результат: 
	// - Структура - Загружено.
	// - Неопределено - Закрыто окно. 
	
	ПользовательЗакрылОкно = (Результат = Неопределено);
	
	Оповещение = Контекст.Оповещение;
	
	Если ПользовательЗакрылОкно Тогда 
		Результат = РезультатЗагрузкиКомпоненты();
		Результат.Загружена = Ложь;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ЗагрузитьКомпонентуИзФайла.
Функция РезультатЗагрузкиКомпоненты() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Загружена", Ложь);
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Версия", "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ДополнительнаяИнформация", Новый Соответствие);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПоискКомпонентыНаПортале

// Параметры:
//  Оповещение - ОписаниеОповещения - .
//  Контекст - Структура - контекст процедуры:
//      * ТекстПояснения - Строка   - .
//      * Идентификатор - Строка - .
//      * Версия        - Строка, Неопределено - .
//
Процедура ПоискКомпонентыНаПортале(Оповещение, Контекст)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекстПояснения", Контекст.ТекстПояснения);
	ПараметрыФормы.Вставить("Идентификатор", Контекст.Идентификатор);
	ПараметрыФормы.Вставить("Версия", Контекст.Версия);
	
	ОповещениеФормы = Новый ОписаниеОповещения("ПоискКомпонентыНаПорталеПриФормированииРезультата", ЭтотОбъект, Оповещение);
	
	ОткрытьФорму("Справочник.ВнешниеКомпоненты.Форма.ПоискКомпонентыНаПортале1СИТС", 
		ПараметрыФормы,,,,, ОповещениеФормы)
	
КонецПроцедуры

Процедура ПоискКомпонентыНаПорталеПриФормированииРезультата(Результат, Оповещение) Экспорт
	
	Загружена = (Результат = Истина); // При закрытии формы будет Неопределено.
	ВыполнитьОбработкуОповещения(Оповещение, Загружена);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновитьКомпонентыСПортала

// Параметры:
//  МассивСсылок - Массив - .
//
Процедура ОбновитьКомпонентыСПортала(Оповещение, МассивСсылок) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивСсылок", МассивСсылок);
	
	ОповещениеФормы = Новый ОписаниеОповещения("ОбновитьКомпонентыСПорталаПриФормированииРезультата", ЭтотОбъект, Оповещение);
	
	ОткрытьФорму("Справочник.ВнешниеКомпоненты.Форма.ОбновлениеКомпонентСПортала1СИТС", 
		ПараметрыФормы,,,,, ОповещениеФормы);
	
КонецПроцедуры

Процедура ОбновитьКомпонентыСПорталаПриФормированииРезультата(Результат, Оповещение) Экспорт
	
	ВыполнитьОбработкуОповещения(Оповещение, Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СохранитьКомпонентуВФайл

// Параметры:
//  Ссылка - СправочникСсылка.ВнешниеКомпоненты - контейнер внешней компоненты в информационной базе.
//
Процедура СохранитьКомпонентуВФайл(Ссылка) Экспорт 
	
	Местоположение = ПолучитьНавигационнуюСсылку(Ссылка, "ХранилищеКомпоненты");
	ИмяФайла = ВнешниеКомпонентыСлужебныйВызовСервера.ИмяФайлаКомпоненты(Ссылка);
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения внешней компоненты'");
	ПараметрыСохранения.Диалог.Фильтр    = НСтр("ru = 'Файлы внешних компонент (*.zip)|*.zip|Все файлы (*.*)|*.*'");
	
	Контекст = Новый Структура;
	Контекст.Вставить("Ссылка", Ссылка);
	
	Оповещение = Новый ОписаниеОповещения("СохранитьКомпонентуВФайлПослеПолученияФайлов", ЭтотОбъект, Контекст);
	
	ФайловаяСистемаКлиент.СохранитьФайл(Оповещение, Местоположение, ИмяФайла, ПараметрыСохранения);
	
КонецПроцедуры

// Продолжение процедуры СохранитьКомпонентуВФайл.
Процедура СохранитьКомпонентуВФайлПослеПолученияФайлов(ПолученныеФайлы, Контекст) Экспорт
	
	Если ПолученныеФайлы <> Неопределено 
		И ПолученныеФайлы.Количество() > 0 Тогда
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Сохранение в файл'"),,
			НСтр("ru = 'Внешняя компонента успешно сохранена в файл.'"), БиблиотекаКартинок.Успешно32);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
