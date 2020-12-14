﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет, является ли переданная строка внутренней навигационной ссылкой.
//  
// Параметры:
//  Строка - Строка - навигационная ссылка.
//
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ЭтоНавигационнаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "e1cib/")
		Или СтрНачинаетсяС(Строка, "e1ccs/");
	
КонецФункции

// Конвертирует параметры запуска текущего сеанса в передаваемые параметры в скрипт
// Например, на вход программа может быть запущена с ключом:
// /C "ПараметрыЗапускаИзВнешнейОперации=/TestClient -TPort 48050 /C РежимОтладки;РежимОтладки"
// Пробросит в скрипт следует "/TestClient -TPort 48050 /C РежимОтладки"
//
// Возвращаемое значение:
//  Строка - значение параметра.
//
Функция ПараметрыЗапускаПредприятияИзСкрипта() Экспорт
	
	Перем ЗначениеПараметра;
	
	ПараметрыЗапуска = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ПараметрЗапуска);
	Если Не ПараметрыЗапуска.Свойство("ПараметрыЗапускаИзВнешнейОперации", ЗначениеПараметра) Тогда 
		ЗначениеПараметра = "";
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

#Область ВнешниеКомпоненты

// Параметры:
//  Контекст - Структура:
//      * Оповещение           - ОписаниеОповещения
//      * Идентификатор        - Строка
//      * Местоположение       - Строка
//      * Кэшировать           - Булево
//      * ПредложитьУстановить - Булево
//      * ТекстПояснения       - Строка
//      * ИдентификаторыСозданияОбъектов
//
Процедура ПодключитьКомпоненту(Контекст) Экспорт
	
	Если ПустаяСтрока(Контекст.Идентификатор) Тогда 
		КомпонентаСодержитЕдинственныйКлассОбъектов = (Контекст.ИдентификаторыСозданияОбъектов.Количество() = 0);
		
		Если КомпонентаСодержитЕдинственныйКлассОбъектов Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось подключить внешнюю компоненту на клиенте
				           |%1
				           |по причине:
				           |Не допустимо одновременно не указывать Идентификатор и ИдентификаторыСозданияОбъектов'"), 
				Контекст.Местоположение);
		Иначе
			// В случае, когда в компоненте есть несколько классов объектов
			// Идентификатор используется только для отображения компоненты в текстах ошибок.
			// Следует собрать идентификатор для отображения.
			Контекст.Идентификатор = СтрСоединить(Контекст.ИдентификаторыСозданияОбъектов, ", ");
		КонецЕсли;
	КонецЕсли;
	
	Если Не МестоположениеКомпонентыКорректно(Контекст.Местоположение) Тогда 
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
			           |по причине:
			           |указано некорректное местоположение внешней компоненты
			           |%2'"),
			Контекст.Идентификатор,
			Контекст.Местоположение);
	КонецЕсли;
	
	Если Контекст.Кэшировать Тогда 
		
		ПодключаемыйМодуль = ПолучитьОбъектКомпонентыИзКэша(Контекст.Местоположение);
		Если ПодключаемыйМодуль <> Неопределено Тогда 
			ПодключитьКомпонентуОповеститьОПодключении(ПодключаемыйМодуль, Контекст);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	// Проверка факта подключения внешней компоненты в этом сеансе ранее.
	СимволическоеИмя = ПолучитьСимволическоеИмяКомпонентыИзКэша(Контекст.Местоположение);
	
	Если СимволическоеИмя = Неопределено Тогда 
		
		// Генерация уникального имени.
		СимволическоеИмя = "С" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
		
		Контекст.Вставить("СимволическоеИмя", СимволическоеИмя);
		
		Оповещение = Новый ОписаниеОповещения(
			"ПодключитьКомпонентуПослеПопыткиПодключения", ЭтотОбъект, Контекст,
			"ПодключитьКомпонентуПриОбработкеОшибки", ЭтотОбъект);
		
		НачатьПодключениеВнешнейКомпоненты(Оповещение, Контекст.Местоположение, СимволическоеИмя);
		
	Иначе 
		
		// Если в кэше уже есть символическое имя - значит к этому сеансу ранее компонента уже подключалась.
		Подключено = Истина;
		Контекст.Вставить("СимволическоеИмя", СимволическоеИмя);
		ПодключитьКомпонентуПослеПопыткиПодключения(Подключено, Контекст);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуОповеститьОПодключении(ПодключаемыйМодуль, Контекст) Экспорт
	
	Результат = РезультатПодключенияКомпоненты();
	Результат.Подключено = Истина;
	Результат.ПодключаемыйМодуль = ПодключаемыйМодуль;
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуОповеститьОбОшибке(ОписаниеОшибки, Контекст) Экспорт
	
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Подключение внешней компоненты на клиенте'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			"Ошибка", ОписаниеОшибки,, Истина);
	КонецЕсли;
		
	Оповещение = Контекст.Оповещение;
	Результат = РезультатПодключенияКомпоненты();
	Результат.ОписаниеОшибки = ОписаниеОшибки;
	ВыполнитьОбработкуОповещения(Оповещение, Результат);
	
КонецПроцедуры

// Параметры:
//  Контекст - Структура:
//      * Оповещение     - ОписаниеОповещения
//      * Местоположение - Строка
//      * ТекстПояснения - Строка
//
Процедура УстановитьКомпоненту(Контекст) Экспорт
	
	Если Не МестоположениеКомпонентыКорректно(Контекст.Местоположение) Тогда 
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить внешнюю компоненту ""%1"" на клиенте
			           |%2
			           |по причине:
			           |Не допустимо устанавливать компоненты из указанного местоположения.'"), 
			Контекст.Идентификатор,
			Контекст.Местоположение);
	КонецЕсли;
	
	// Проверка факта подключения внешней компоненты в этом сеансе ранее.
	СимволическоеИмя = ПолучитьСимволическоеИмяКомпонентыИзКэша(Контекст.Местоположение);
	
	Если СимволическоеИмя = Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьКомпонентуПослеОтветаНаВопросОбУстановке", ЭтотОбъект, Контекст);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстПояснения", Контекст.ТекстПояснения);
		
		ОткрытьФорму("ОбщаяФорма.ВопросОбУстановкеВнешнейКомпоненты", 
			ПараметрыФормы,,,,, Оповещение);
		
	Иначе 
		
		// Если в кэше уже есть символическое имя - значит к этому сеансу ранее компонента уже подключалась,
		// значит внешняя компонента уже установлена.
		Результат = РезультатУстановкиКомпоненты();
		Результат.Вставить("Установлено", Истина);
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуОповеститьОбОшибке(ОписаниеОшибки, Контекст) Экспорт
	
	Оповещение = Контекст.Оповещение;
	
	Результат = РезультатУстановкиКомпоненты();
	Результат.ОписаниеОшибки = ОписаниеОшибки;
	ВыполнитьОбработкуОповещения(Оповещение, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ТабличныйДокумент

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с табличными документами.

// Выполняет расчет и вывод показателей выделенных областей ячеек табличного документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой выводятся значения расчетных показателей.
//  ИмяТабличногоДокумента - Строка - имя реквизита формы типа ТабличныйДокумент, показатели которого рассчитываются.
//  ТекущаяКоманда - Строка - имя команды расчета показателя, например, "РассчитатьСумму".
//                      Определяет, какой показатель является основным.
//
Процедура РассчитатьПоказатели(Форма, ИмяТабличногоДокумента, ТекущаяКоманда = "") Экспорт 
	
	Элементы = Форма.Элементы;
	ТабличныйДокумент = Форма[ИмяТабличногоДокумента];
	ПолеТабличногоДокумента = Элементы[ИмяТабличногоДокумента];
	
	Если Не ЗначениеЗаполнено(ТекущаяКоманда) Тогда 
		ТекущаяКоманда = ТекущаяКомандаРасчетаПоказателей(Элементы);
	КонецЕсли;
	
	// Расчет показателей.
	РасчетныеПоказатели = ОбщегоНазначенияКлиентСервер.РасчетныеПоказателиЯчеек(
		ТабличныйДокумент, ПолеТабличногоДокумента);
	
	// Установка значений показателей.
	ЗаполнитьЗначенияСвойств(Форма, РасчетныеПоказатели);
	
	// Переключение и форматирование показателей.
	КомандыПоказателей = КомандыПоказателей();
	
	Для Каждого Команда Из КомандыПоказателей Цикл 
		ИзменитьСвойствоЭлементаРасчетаПоказателей(Элементы, Команда.Ключ, "Пометка", Ложь);
		
		ЗначениеПоказателя = РасчетныеПоказатели[Команда.Значение];
		Элементы[Команда.Значение].ФорматРедактирования = ФорматРедактированияПоказателя(ЗначениеПоказателя);
	КонецЦикла;
	
	ИзменитьСвойствоЭлементаРасчетаПоказателей(Элементы, ТекущаяКоманда, "Пометка", Истина);
	
	// Вывод основного показателя.
	ТекущийПоказатель = КомандыПоказателей[ТекущаяКоманда];
	
	Форма.Показатель = Форма[ТекущийПоказатель];
	Элементы.Показатель.ФорматРедактирования = Элементы[ТекущийПоказатель].ФорматРедактирования;
	
	ИзменитьСвойствоЭлементаРасчетаПоказателей(
		Элементы, "КомандыВидовПоказателей", "Картинка", БиблиотекаКартинок[ТекущийПоказатель]);
	
	// Кэширование состояния выбора показателей.
	Форма.ОсновнойПоказатель = ТекущаяКоманда;
	Форма.РазвернутьОбластьПоказателей = Элементы.РассчитатьВсеПоказатели.Пометка;
	
КонецПроцедуры

// Управляет признаком видимости панели расчетных показателей.
//
// Параметры:
//  Видимость - Булево - признак включения / выключения видимости панели показателей.
//              См. также Синтакс-помощник: ГруппаФормы.Видимость.
//
Процедура УстановитьВидимостьПанелиПоказателей(ЭлементыФормы, Видимость = Ложь) Экспорт 
	
	ЭлементыФормы.ОбластьПоказателей.Видимость = Видимость;
	ИзменитьСвойствоЭлементаРасчетаПоказателей(ЭлементыФормы, "РассчитатьВсеПоказатели", "Пометка", Видимость);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Данные

#Область СкопироватьРекурсивно

Функция СкопироватьСтруктуру(СтруктураИсточник, ФиксироватьДанные) Экспорт 
	
	СтруктураРезультат = Новый Структура;
	
	Для Каждого КлючИЗначение Из СтруктураИсточник Цикл
		СтруктураРезультат.Вставить(КлючИЗначение.Ключ, 
			ОбщегоНазначенияКлиент.СкопироватьРекурсивно(КлючИЗначение.Значение, ФиксироватьДанные));
	КонецЦикла;
	
	Если ФиксироватьДанные = Истина 
		Или ФиксироватьДанные = Неопределено
		И ТипЗнч(СтруктураИсточник) = Тип("ФиксированнаяСтруктура") Тогда 
		Возврат Новый ФиксированнаяСтруктура(СтруктураРезультат);
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

Функция СкопироватьСоответствие(СоответствиеИсточник, ФиксироватьДанные) Экспорт 
	
	СоответствиеРезультат = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		СоответствиеРезультат.Вставить(КлючИЗначение.Ключ, 
			ОбщегоНазначенияКлиент.СкопироватьРекурсивно(КлючИЗначение.Значение, ФиксироватьДанные));
	КонецЦикла;
	
	Если ФиксироватьДанные = Истина 
		Или ФиксироватьДанные = Неопределено
		И ТипЗнч(СоответствиеИсточник) = Тип("ФиксированноеСоответствие") Тогда 
		Возврат Новый ФиксированноеСоответствие(СоответствиеРезультат);
	КонецЕсли;
	
	Возврат СоответствиеРезультат;
	
КонецФункции

Функция СкопироватьМассив(МассивИсточник, ФиксироватьДанные) Экспорт 
	
	МассивРезультат = Новый Массив;
	
	Для Каждого Элемент Из МассивИсточник Цикл
		МассивРезультат.Добавить(ОбщегоНазначенияКлиент.СкопироватьРекурсивно(Элемент, ФиксироватьДанные));
	КонецЦикла;
	
	Если ФиксироватьДанные = Истина 
		Или ФиксироватьДанные = Неопределено
		И ТипЗнч(МассивИсточник) = Тип("ФиксированныйМассив") Тогда 
		Возврат Новый ФиксированныйМассив(МассивРезультат);
	КонецЕсли;
	
	Возврат МассивРезультат;
	
КонецФункции

Функция СкопироватьСписокЗначений(СписокИсточник, ФиксироватьДанные) Экспорт
	
	СписокРезультат = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из СписокИсточник Цикл
		СписокРезультат.Добавить(
			ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ЭлементСписка.Значение, ФиксироватьДанные), 
			ЭлементСписка.Представление, 
			ЭлементСписка.Пометка, 
			ЭлементСписка.Картинка);
	КонецЦикла;
	
	Возврат СписокРезультат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Формы

Функция ИмяОбъектаМетаданных(Тип) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ИменаОбъектовМетаданных";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Соответствие);
	КонецЕсли;
	ИменаОбъектовМетаданных = ПараметрыПриложения[ИмяПараметра];
	
	Результат = ИменаОбъектовМетаданных[Тип];
	Если Результат = Неопределено Тогда
		Результат = СтандартныеПодсистемыВызовСервера.ИмяОбъектаМетаданных(Тип);
		ИменаОбъектовМетаданных.Вставить(Тип, Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПодтвердитьЗакрытиеФормы() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	Параметры = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеФормыЗавершение", ЭтотОбъект, Параметры);
	Если ПустаяСтрока(Параметры.ТекстПредупреждения) Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
	Иначе
		ТекстВопроса = Параметры.ТекстПредупреждения;
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, ,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормыЗавершение(Ответ, Параметры) Экспорт
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Неопределено;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеСохранитьИЗакрыть);
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
	Иначе
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормы() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	Параметры = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Неопределено;
	РежимВопроса = РежимДиалогаВопрос.ДаНет;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение", ЭтотОбъект, Параметры);
	
	ПоказатьВопрос(Оповещение, Параметры.ТекстПредупреждения, РежимВопроса);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение(Ответ, Параметры) Экспорт
	
	Форма = Параметры.Форма;
	Если Ответ = КодВозвратаДиалога.Да
		Или Ответ = КодВозвратаДиалога.ОК Тогда
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Истина;
		Если Параметры.ОписаниеОповещенияЗакрыть <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещенияЗакрыть);
		КонецЕсли;
		Форма.Закрыть();
	Иначе
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ФормыРедактирования

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	ПутьКРеквизитуФормы = СтрРазделить(ДополнительныеПараметры.ИмяРеквизита, ".");
	// Если реквизит вида "Объект.Комментарий" и т.п.
	Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
		Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
			РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
		КонецЦикла;
	КонецЕсли;	
	
	РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ВнешниеКомпоненты

#Область ПодключениеВнешнейКомпоненты

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуПослеПопыткиПодключения(Подключено, Контекст) Экспорт 
	
	Если Подключено Тогда 
		
		// Сохранение факта подключения внешней компоненты к этому сеансу.
		ЗаписатьСимволическоеИмяКомпонентыВКэш(Контекст.Местоположение, Контекст.СимволическоеИмя);
		
		ПодключаемыйМодуль = Неопределено;
		
		Попытка
			ПодключаемыйМодуль = НовыйОбъектКомпоненты(Контекст);
		Исключение
			// Текст ошибки уже скомпонован в НовыйОбъектКомпоненты, требуется только оповестить.
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
			Возврат;
		КонецПопытки;
		
		Если Контекст.Кэшировать Тогда 
			ЗаписатьОбъектКомпонентыВКэш(Контекст.Местоположение, ПодключаемыйМодуль)
		КонецЕсли;
		
		ПодключитьКомпонентуОповеститьОПодключении(ПодключаемыйМодуль, Контекст);
		
	Иначе 
		
		Если Контекст.ПредложитьУстановить Тогда 
			ПодключитьКомпонентуНачатьУстановку(Контекст);
		Иначе 
			ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"".
				           |Возможно компонента не предназначена для клиентского приложения: %2.
						   |
						   |Техническая информация:
				           |%3
						   |Метод НачатьПодключениеВнешнейКомпоненты вернул Ложь.'"),
				Контекст.Идентификатор,
				ВидПриложения(),
				Контекст.Местоположение);
				
			ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВидПриложения()

	СистемнаяИнформация = Новый СистемнаяИнформация();
	Результат = "";
#Если ВебКлиент Тогда
	Результат = НСтр("ru = 'Веб-клиент'") + СистемнаяИнформация.ИнформацияПрограммыПросмотра;
#ИначеЕсли ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Тогда
	Результат = НСтр("ru = 'Толстый клиент'");
#ИначеЕсли ТонкийКлиент Тогда
	Результат = НСтр("ru = 'Тонкий клиент'");
#КонецЕсли
	Возврат Результат + " (" + СистемнаяИнформация.ТипПлатформы + ")";

КонецФункции

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуНачатьУстановку(Контекст)
	
	Оповещение = Новый ОписаниеОповещения(
		"ПодключитьКомпонентуПослеУстановки", ЭтотОбъект, Контекст);
	
	КонтекстУстановки = Новый Структура;
	КонтекстУстановки.Вставить("Оповещение", Оповещение);
	КонтекстУстановки.Вставить("Местоположение", Контекст.Местоположение);
	КонтекстУстановки.Вставить("ТекстПояснения", Контекст.ТекстПояснения);
	
	УстановитьКомпоненту(КонтекстУстановки);
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуПослеУстановки(Результат, Контекст) Экспорт 
	
	Если Результат.Установлено Тогда 
		// Одна попытка установки уже прошла, если компонента не подключится в этот раз,
		// то и предлагать ее установить еще раз не следует.
		Контекст.ПредложитьУстановить = Ложь;
		ПодключитьКомпоненту(Контекст);
	Иначе 
		// Расшифровка ОписаниеОшибки не нужна, текст уже сформирован при установке.
		// При отказе от установки пользователем ОписаниеОшибки - пустая строка.
		ПодключитьКомпонентуОповеститьОбОшибке(Результат.ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
// 
// Параметры:
//  ИнформацияОбОшибке- ИнформацияОбОшибке
//  СтандартнаяОбработка - Булево
//  Контекст - см. ПодключитьКомпоненту.Контекст
//
Процедура ПодключитьКомпонентуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось подключить внешнюю компоненту ""%1"" на клиенте
		           |%2
		           |по причине:
		           |%3'"),
		Контекст.Идентификатор,
		Контекст.Местоположение,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
	ПодключитьКомпонентуОповеститьОбОшибке(ТекстОшибки, Контекст);
	
КонецПроцедуры

// Создает экземпляр внешней компоненты (или несколько)
Функция НовыйОбъектКомпоненты(Контекст)
	
	КомпонентаСодержитЕдинственныйКлассОбъектов = (Контекст.ИдентификаторыСозданияОбъектов.Количество() = 0);
	
	Если КомпонентаСодержитЕдинственныйКлассОбъектов Тогда 
		
		Попытка
			ПодключаемыйМодуль = Новый("AddIn." + Контекст.СимволическоеИмя + "." + Контекст.Идентификатор);
			Если ПодключаемыйМодуль = Неопределено Тогда 
				ВызватьИсключение НСтр("ru = 'Оператор Новый вернул Неопределено'");
			КонецЕсли;
		Исключение
			ПодключаемыйМодуль = Неопределено;
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		Если ПодключаемыйМодуль = Неопределено Тогда 
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать объект внешней компоненты ""%1"", подключенной на клиенте
				           |%2,
				           |по причине:
				           |%3'"),
				Контекст.Идентификатор,
				Контекст.Местоположение,
				ТекстОшибки);
			
		КонецЕсли;
		
	Иначе 
		
		ПодключаемыеМодули = Новый Соответствие;
		Для каждого ИдентификаторОбъекта Из Контекст.ИдентификаторыСозданияОбъектов Цикл 
			
			Попытка
				ПодключаемыйМодуль = Новый("AddIn." + Контекст.СимволическоеИмя + "." + ИдентификаторОбъекта);
				Если ПодключаемыйМодуль = Неопределено Тогда 
					ВызватьИсключение НСтр("ru = 'Оператор Новый вернул Неопределено'");
				КонецЕсли;
			Исключение
				ПодключаемыйМодуль = Неопределено;
				ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
			
			Если ПодключаемыйМодуль = Неопределено Тогда 
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось создать объект ""%1"" внешней компоненты ""%2"", подключенной на клиенте
					           |%3,
					           |по причине:
					           |%4'"),
					ИдентификаторОбъекта,
					Контекст.Идентификатор,
					Контекст.Местоположение,
					ТекстОшибки);
				
			КонецЕсли;
			
			ПодключаемыеМодули.Вставить(ИдентификаторОбъекта, ПодключаемыйМодуль);
			
		КонецЦикла;
		
		ПодключаемыйМодуль = Новый ФиксированноеСоответствие(ПодключаемыеМодули);
		
	КонецЕсли;
	
	Возврат ПодключаемыйМодуль;
	
КонецФункции

// Продолжение процедуры ПодключитьКомпоненту.
Функция РезультатПодключенияКомпоненты()
	
	Результат = Новый Структура;
	Результат.Вставить("Подключено", Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ПодключаемыйМодуль", Неопределено);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область УстановкаВнешнейКомпоненты

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуПослеОтветаНаВопросОбУстановке(Ответ, Контекст) Экспорт
	
	// Результат: 
	// - КодВозвратаДиалога.Да - Установить.
	// - КодВозвратаДиалога.Отмена - Отклонить.
	// - Неопределено - Закрыто окно.
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УстановитьКомпонентуНачатьУстановку(Контекст);
	Иначе
		Результат = РезультатУстановкиКомпоненты();
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуНачатьУстановку(Контекст)
	
	Оповещение = Новый ОписаниеОповещения(
		"УстановитьКомпонентуПослеПопыткиУстановки", ЭтотОбъект, Контекст,
		"УстановитьКомпонентуПриОбработкеОшибки", ЭтотОбъект);
	
	НачатьУстановкуВнешнейКомпоненты(Оповещение, Контекст.Местоположение);
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуПослеПопыткиУстановки(Контекст) Экспорт 
	
	Результат = РезультатУстановкиКомпоненты();
	Результат.Вставить("Установлено", Истина);
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
// 
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке
//  СтандартнаяОбработка - Булево
//  Контекст - см. ПодключитьКомпоненту.Контекст 
// 
Процедура УстановитьКомпонентуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось установить внешнюю компоненту ""%1"" на клиенте 
		           |%2
		           |по причине:
		           |%3'"),
		Контекст.Идентификатор,
		Контекст.Местоположение,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	Результат = РезультатУстановкиКомпоненты();
	Результат.ОписаниеОшибки = ТекстОшибки;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Функция РезультатУстановкиКомпоненты()
	
	Результат = Новый Структура;
	Результат.Вставить("Установлено", Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

Функция МестоположениеКомпонентыКорректно(Местоположение)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
		МодульВнешниеКомпонентыСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВнешниеКомпонентыСлужебныйКлиент");
		Если МодульВнешниеКомпонентыСлужебныйКлиент.ЭтоКомпонентаИзХранилища(Местоположение) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЭтоМакет(Местоположение);
	
КонецФункции

Функция ЭтоМакет(Местоположение)
	
	ШагиПути = СтрРазделить(Местоположение, ".");
	Если ШагиПути.Количество() < 2 Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Путь = Новый Структура;
	Попытка
		Для каждого ШагПути Из ШагиПути Цикл 
			Путь.Вставить(ШагПути);
		КонецЦикла;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Получает из кэша символическое имя внешней компоненты, если она была ранее подключена.
Функция ПолучитьСимволическоеИмяКомпонентыИзКэша(КлючОбъекта)
	
	СимволическоеИмя = Неопределено;
	КэшированныеСимволическоеИмена = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.СимволическиеИмена"];
	
	Если ТипЗнч(КэшированныеСимволическоеИмена) = Тип("ФиксированноеСоответствие") Тогда
		СимволическоеИмя = КэшированныеСимволическоеИмена.Получить(КлючОбъекта);
	КонецЕсли;
	
	Возврат СимволическоеИмя;
	
КонецФункции

// Записывает в кэш символическое имя внешней компоненты.
Процедура ЗаписатьСимволическоеИмяКомпонентыВКэш(КлючОбъекта, СимволическоеИмя)
	
	Соответствие = Новый Соответствие;
	КэшированныеСимволическоеИмена = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.СимволическиеИмена"];
	
	Если ТипЗнч(КэшированныеСимволическоеИмена) = Тип("ФиксированноеСоответствие") Тогда
		
		Если КэшированныеСимволическоеИмена.Получить(КлючОбъекта) <> Неопределено Тогда // Уже есть в кэше.
			Возврат;
		КонецЕсли;
		
		Для каждого Элемент Из КэшированныеСимволическоеИмена Цикл
			Соответствие.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	Соответствие.Вставить(КлючОбъекта, СимволическоеИмя);
	
	ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ВнешниеКомпоненты.СимволическиеИмена",
		Новый ФиксированноеСоответствие(Соответствие));
	
КонецПроцедуры

// Получает из кэша объект - экземпляр внешней компоненты
Функция ПолучитьОбъектКомпонентыИзКэша(КлючОбъекта)
	
	ПодключаемыйМодуль = Неопределено;
	КэшированныеОбъекты = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.Объекты"];
	
	Если ТипЗнч(КэшированныеОбъекты) = Тип("ФиксированноеСоответствие") Тогда
		ПодключаемыйМодуль = КэшированныеОбъекты.Получить(КлючОбъекта);
	КонецЕсли;
	
	Возврат ПодключаемыйМодуль;
	
КонецФункции

// Записывает в кэш экземпляр внешней компоненты
Процедура ЗаписатьОбъектКомпонентыВКэш(КлючОбъекта, ПодключаемыйМодуль)
	
	Соответствие = Новый Соответствие;
	КэшированныеОбъекты = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.Объекты"];
	
	Если ТипЗнч(КэшированныеОбъекты) = Тип("ФиксированноеСоответствие") Тогда
		Для каждого Элемент Из КэшированныеОбъекты Цикл
			Соответствие.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Соответствие.Вставить(КлючОбъекта, ПодключаемыйМодуль);
	
	ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ВнешниеКомпоненты.Объекты",
		Новый ФиксированноеСоответствие(Соответствие));
	
КонецПроцедуры

#КонецОбласти

#Область ВнешнееСоединение

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель.
Процедура ЗарегистрироватьCOMСоединительПриПроверкеРегистрации(Результат, Контекст) Экспорт
	
	ПриложениеЗапущено = Результат.ПриложениеЗапущено;
	ОписаниеОшибки = Результат.ОписаниеОшибки;
	КодВозврата = Результат.КодВозврата;
	ВыполнитьПерезагрузкуСеанса = Контекст.ВыполнитьПерезагрузкуСеанса;
	
	Если ПриложениеЗапущено Тогда
		
		Если ВыполнитьПерезагрузкуСеанса Тогда
			
			Оповещение = Новый ОписаниеОповещения("ЗарегистрироватьCOMСоединительПриПроверкеОтветаОПерезапускеСеанса", 
				ОбщегоНазначенияСлужебныйКлиент, Контекст);
			
			ТекстВопроса = 
				НСтр("ru = 'Для завершения перерегистрации компоненты comcntr необходимо перезапустить программу.
				           |Перезапустить сейчас?'");
			
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе 
			
			Оповещение = Контекст.Оповещение;
			
			Зарегистрировано = Истина;
			ВыполнитьОбработкуОповещения(Оповещение, Зарегистрировано);
			
		КонецЕсли;
		
	Иначе 
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при регистрации компоненты comcntr.
			           |Код ошибки regsvr32: %1'"),
			КодВозврата);
			
		Если КодВозврата = 5 Тогда
			ТекстСообщения = ТекстСообщения + " " + НСтр("ru = 'Недостаточно прав доступа.'");
		Иначе 
			ТекстСообщения = ТекстСообщения + Символы.ПС + ОписаниеОшибки;
		КонецЕсли;
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Регистрация компоненты comcntr'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			"Ошибка",
			ТекстСообщения,,
			Истина);
		
		Оповещение = Новый ОписаниеОповещения("ЗарегистрироватьCOMСоединительОповеститьОбОшибке", 
			ОбщегоНазначенияСлужебныйКлиент, Контекст);
		
		ПоказатьПредупреждение(Оповещение, ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель.
Процедура ЗарегистрироватьCOMСоединительПриПроверкеОтветаОПерезапускеСеанса(Ответ, Контекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		ЗавершитьРаботуСистемы(Истина, Истина);
	Иначе 
		ЗарегистрироватьCOMСоединительОповеститьОбОшибке(Контекст);
	КонецЕсли;

КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель.
Процедура ЗарегистрироватьCOMСоединительОповеститьОбОшибке(Контекст) Экспорт
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение <> Неопределено Тогда
		Зарегистрировано = Ложь;
		ВыполнитьОбработкуОповещения(Оповещение, Зарегистрировано);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель.
Функция ЗарегистрироватьCOMСоединительДоступнаРегистрация() Экспорт
	
#Если ВебКлиент Или МобильныйКлиент Тогда
	Возврат Ложь;
#Иначе
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Возврат Не ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер()
		И Не ПараметрыРаботыКлиентаПриЗапуске.ЭтоБазоваяВерсияКонфигурации
		И Не ПараметрыРаботыКлиентаПриЗапуске.ЭтоУчебнаяПлатформа;
#КонецЕсли
	
КонецФункции

#КонецОбласти

#Область ТабличныйДокумент

Функция ТекущаяКомандаРасчетаПоказателей(ЭлементыФормы)
	
	Перем ТекущаяКоманда;
	
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		
		Если ЭлементыФормы[Команда.Ключ].Пометка Тогда 
			
			ТекущаяКоманда = Команда.Ключ;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущаяКоманда = Неопределено Тогда 
		ТекущаяКоманда = "РассчитатьСумму";
	КонецЕсли;
	
	Возврат ТекущаяКоманда;
	
КонецФункции

// Определяет соответствие между командами расчета показателей и показателями.
//
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//     * Ключ - Строка - имя команды;
//     * Значение - Строка - имя показателя.
//
Функция КомандыПоказателей()
	
	КомандыПоказателей = Новый Соответствие();
	КомандыПоказателей.Вставить("РассчитатьСумму", "Сумма");
	КомандыПоказателей.Вставить("РассчитатьКоличество", "Количество");
	КомандыПоказателей.Вставить("РассчитатьСреднее", "Среднее");
	КомандыПоказателей.Вставить("РассчитатьМинимум", "Минимум");
	КомандыПоказателей.Вставить("РассчитатьМаксимум", "Максимум");
	
	Возврат КомандыПоказателей;
	
КонецФункции

Функция ФорматРедактированияПоказателя(ЗначениеПоказателя)
	
	ШаблонФорматаРедактирования = "ЧДЦ=%1; ЧРГ=' '; ЧН=0";
	
	ЗначениеДробнойЧасти = Макс(ЗначениеПоказателя, -ЗначениеПоказателя) % 1;
	РазрядностьДробнойЧасти = Мин(?(ЗначениеДробнойЧасти = 0, 0, СтрДлина(ЗначениеДробнойЧасти) - 2), 5);
	
	ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонФорматаРедактирования, РазрядностьДробнойЧасти);
	
	ПредставлениеПоказателя = Формат(ЗначениеПоказателя, ФорматРедактирования);
	
	Пока РазрядностьДробнойЧасти > 0
		И СтрЗаканчиваетсяНа(ПредставлениеПоказателя, "0") Цикл 
		
		ПредставлениеПоказателя = Сред(ПредставлениеПоказателя, 1, СтрДлина(ПредставлениеПоказателя) - 1);
		РазрядностьДробнойЧасти = РазрядностьДробнойЧасти - 1;
		
	КонецЦикла;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонФорматаРедактирования, РазрядностьДробнойЧасти);
	
КонецФункции

Процедура ИзменитьСвойствоЭлементаРасчетаПоказателей(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, ЗначениеСвойства)
	
	СписокИменЭлементов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1, %1%2", ИмяЭлемента, "Еще");
	ИменаЭлементов = СтрРазделить(СписокИменЭлементов, ", ", Ложь);
	
	Для Каждого Имя Из ИменаЭлементов Цикл 
		
		НайденныйЭлемент = ЭлементыФормы.Найти(Имя);
		
		Если НайденныйЭлемент <> Неопределено Тогда 
			НайденныйЭлемент[ИмяСвойства] = ЗначениеСвойства;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

#Область РасширениеДляРаботыСФайлами

// Устарела. Используется в ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено.
Процедура ПроверитьРасширениеРаботыСФайламиПодключеноЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗакрытии);
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ДополнительныеПараметры.ТекстПредупреждения;
	Если ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = НСтр("ru = 'Действие недоступно, так как не установлено расширение для работы с 1С:Предприятием.'")
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти