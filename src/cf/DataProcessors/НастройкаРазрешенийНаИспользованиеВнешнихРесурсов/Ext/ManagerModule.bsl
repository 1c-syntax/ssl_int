﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Управление разрешениями в профилях безопасности из текущей ИБ.
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Логика работы мастера настройки разрешений на использование внешних ресурсов.
//

// Для внутреннего использования.
//
Процедура ВыполнитьОбработкуЗапросов(Знач ИдентификаторыЗапросов, Знач АдресВременногоХранилища, Знач АдресВременногоХранилищаСостояния, Знач ДобавитьОчисткуЗапросовПередПрименением = Ложь) Экспорт
	
	Менеджер = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.МенеджерПримененияРазрешений(ИдентификаторыЗапросов);
	
	Если ДобавитьОчисткуЗапросовПередПрименением Тогда
		Менеджер.ДобавитьОчисткуРазрешенийПередПрименением();
	КонецЕсли;
	
	Состояние = Новый Структура();
	
	Если Менеджер.ТребуетсяПрименениеРазрешенийВКластереСерверов() Тогда
		
		Состояние.Вставить("ТребуетсяПрименениеРазрешений", Истина);
		
		Результат = Новый Структура();
		Результат.Вставить("Представление", Менеджер.Представление());
		Результат.Вставить("Сценарий", Менеджер.СценарийПрименения());
		Результат.Вставить("Состояние", Менеджер.ЗаписатьСостояниеВСтрокуXML());
		ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
		
		Состояние.Вставить("АдресХранилища", АдресВременногоХранилища);
		
	Иначе
		
		Состояние.Вставить("ТребуетсяПрименениеРазрешений", Ложь);
		Менеджер.ЗавершитьПрименениеЗапросовНаИспользованиеВнешнихРесурсов();
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Состояние, АдресВременногоХранилищаСостояния);
	
КонецПроцедуры

// Для внутреннего использования.
//
Процедура ВыполнитьОбработкуЗапросовОбновления(Знач АдресВременногоХранилища, Знач АдресВременногоХранилищаСостояния) Экспорт
	
	ВызовПриОтключенныхПрофилях = Не Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить();
	
	Если ВызовПриОтключенныхПрофилях Тогда
		
		НачатьТранзакцию();
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
		
		ИдентификаторыЗапросов = РаботаВБезопасномРежимеСлужебный.ЗапросыОбновленияРазрешенийКонфигурации();
		СериализацияЗапросов = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ЗаписатьЗапросыВСтрокуXML(ИдентификаторыЗапросов);
		
	КонецЕсли;
	
	ВыполнитьОбработкуЗапросов(ИдентификаторыЗапросов, АдресВременногоХранилища, АдресВременногоХранилищаСостояния);
	
	Если ВызовПриОтключенныхПрофилях Тогда
		
		ОтменитьТранзакцию();
		РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ПрочитатьЗапросыИзСтрокиXML(СериализацияЗапросов);
		
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования.
//
Процедура ВыполнитьОбработкуЗапросовОтключения(Знач АдресВременногоХранилища, Знач АдресВременногоХранилищаСостояния) Экспорт
	
	Запросы = Новый Массив();
	
	НачатьТранзакцию();
	
	Попытка
		
		ИдентификаторЗапросаУдаленияПрофиляИБ = РаботаВБезопасномРежимеСлужебный.ЗапросУдаленияПрофиляБезопасности(
			Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
		
		Запросы.Добавить(ИдентификаторЗапросаУдаленияПрофиляИБ);
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РежимыПодключенияВнешнихМодулей.ТипПрограммногоМодуля КАК ТипПрограммногоМодуля,
			|	РежимыПодключенияВнешнихМодулей.ИдентификаторПрограммногоМодуля КАК ИдентификаторПрограммногоМодуля
			|ИЗ
			|	РегистрСведений.РежимыПодключенияВнешнихМодулей КАК РежимыПодключенияВнешнихМодулей";
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Запросы.Добавить(РаботаВБезопасномРежимеСлужебный.ЗапросУдаленияПрофиляБезопасности(
				РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(Выборка.ТипПрограммногоМодуля, Выборка.ИдентификаторПрограммногоМодуля)));
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	ВыполнитьОбработкуЗапросов(Запросы, АдресВременногоХранилища, АдресВременногоХранилищаСостояния);
	
КонецПроцедуры

// Для внутреннего использования.
//
Процедура ВыполнитьОбработкуЗапросовВосстановления(Знач АдресВременногоХранилища, Знач АдресВременногоХранилищаСостояния) Экспорт
	
	НачатьТранзакцию();
	
	ОчиститьПредоставленныеРазрешения(, Ложь);
	
	ИдентификаторыЗапросов = Новый Массив();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИдентификаторыЗапросов, РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ЗапросыЗамещенияДляВсехПредоставленныхРазрешений());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИдентификаторыЗапросов, РаботаВБезопасномРежимеСлужебный.ЗапросыОбновленияРазрешенийКонфигурации(Ложь));
	
	ЗапросыXML = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ЗаписатьЗапросыВСтрокуXML(ИдентификаторыЗапросов);
	ВыполнитьОбработкуЗапросов(ИдентификаторыЗапросов, АдресВременногоХранилища, АдресВременногоХранилищаСостояния, Истина);
	
	ОтменитьТранзакцию();
	
	РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ПрочитатьЗапросыИзСтрокиXML(ЗапросыXML);
	
КонецПроцедуры

// Для внутреннего использования.
//
Функция ВыполнитьОбработкуЗапросовПроверкиПрименения() Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Транзакция активна'");
	КонецЕсли;
	
	Результат = Новый Структура();
	
	НачатьТранзакцию();
	
	ИдентификаторыЗапросов = Новый Массив();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИдентификаторыЗапросов, РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ЗапросыЗамещенияДляВсехПредоставленныхРазрешений());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИдентификаторыЗапросов, РаботаВБезопасномРежимеСлужебный.ЗапросыОбновленияРазрешенийКонфигурации(Ложь));
	
	Менеджер = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.МенеджерПримененияРазрешений(ИдентификаторыЗапросов);
	
	ЗапросыXML = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ЗаписатьЗапросыВСтрокуXML(ИдентификаторыЗапросов);
	
	ОтменитьТранзакцию();
	
	Если Менеджер.ТребуетсяПрименениеРазрешенийВКластереСерверов() Тогда
		
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
		
		РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ПрочитатьЗапросыИзСтрокиXML(ЗапросыXML);
		
		Результат.Вставить("РезультатПроверки", Ложь);
		Результат.Вставить("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
		
		СостояниеЗапросаРазрешений = Новый Структура();
		СостояниеЗапросаРазрешений.Вставить("Представление", Менеджер.Представление());
		СостояниеЗапросаРазрешений.Вставить("Сценарий", Менеджер.СценарийПрименения());
		СостояниеЗапросаРазрешений.Вставить("Состояние", Менеджер.ЗаписатьСостояниеВСтрокуXML());
		
		ПоместитьВоВременноеХранилище(СостояниеЗапросаРазрешений, АдресВременногоХранилища);
		Результат.Вставить("АдресВременногоХранилища", АдресВременногоХранилища);
		
		АдресВременногоХранилищаСостояния = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
		
		Состояние = Новый Структура();
		Состояние.Вставить("ТребуетсяПрименениеРазрешений", Истина);
		Состояние.Вставить("АдресХранилища", АдресВременногоХранилища);
		
		ПоместитьВоВременноеХранилище(Состояние, АдресВременногоХранилищаСостояния);
		Результат.Вставить("АдресВременногоХранилищаСостояния", АдресВременногоХранилищаСостояния);
		
	Иначе
		
		Если Менеджер.ТребуетсяЗаписьРазрешенийВРегистр() Тогда
			Менеджер.ЗавершитьПрименениеЗапросовНаИспользованиеВнешнихРесурсов();
		КонецЕсли;
		
		Результат.Вставить("РезультатПроверки", Истина);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Для внутреннего использования.
//
Процедура ЗафиксироватьПрименениеЗапросов(Знач Состояние) Экспорт
	
	Менеджер = Создать();
	Менеджер.ПрочитатьСостояниеИзСтрокиXML(Состояние);
	
	Менеджер.ЗавершитьПрименениеЗапросовНаИспользованиеВнешнихРесурсов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с регистрами, используемыми для хранения предоставленных
// разрешений на использование внешних ресурсов.
//

// Устанавливает исключительную управляемую блокировку на таблицы всех регистров, использующихся
// для хранения перечня предоставленных разрешений.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на элемент справочника, соответствующая внешнему модулю, информацию
//    о ранее предоставленных разрешениях по которому требуется очистить. Если значение параметра не задано -
//    будет заблокирована информация о предоставленных разрешениях по всем внешним модулям.
//   ЗаблокироватьРежимыПодключения - Булево - флаг необходимости дополнительной блокировки режимов подключения
//    внешних модулей.
//
Процедура ЗаблокироватьРегистрыПредоставленныхРазрешений(Знач ПрограммныйМодуль = Неопределено, Знач ЗаблокироватьРежимыПодключения = Истина) Экспорт
	
	Если Не ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Должна быть активная транзакция'");
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных();
	
	Регистры = Новый Массив();
	Регистры.Добавить(РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсов);
	
	Если ЗаблокироватьРежимыПодключения Тогда
		Регистры.Добавить(РегистрыСведений.РежимыПодключенияВнешнихМодулей);
	КонецЕсли;
	
	Для Каждого Регистр Из Регистры Цикл
		БлокировкаРегистра = Блокировка.Добавить(Регистр.СоздатьНаборЗаписей().Метаданные().ПолноеИмя());
		Если ПрограммныйМодуль <> Неопределено Тогда
			СвойстваПрограммногоМодуля = РаботаВБезопасномРежимеСлужебный.СвойстваДляРегистраРазрешений(ПрограммныйМодуль);
			БлокировкаРегистра.УстановитьЗначение("ТипПрограммногоМодуля", СвойстваПрограммногоМодуля.Тип);
			БлокировкаРегистра.УстановитьЗначение("ИдентификаторПрограммногоМодуля", СвойстваПрограммногоМодуля.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Блокировка.Заблокировать();
	
КонецПроцедуры

// Очищает регистры сведений, которые используются для хранения в ИБ перечня предоставленных разрешений.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка, ссылка на элемент справочника, соответствующая внешнему модулю, информацию
//    о ранее предоставленных разрешениях по которому требуется очистить. Если значение параметра не задано -
//    будет очищена информация о предоставленных разрешениях по всем внешним модулям.
//   ОчиститьРежимыПодключения - Булево - флаг необходимости дополнительной очистки режимов подключения
//    внешних модулей.
//
Процедура ОчиститьПредоставленныеРазрешения(Знач ПрограммныйМодуль = Неопределено, Знач ОчиститьРежимыПодключения = Истина) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		ЗаблокироватьРегистрыПредоставленныхРазрешений(ПрограммныйМодуль, ОчиститьРежимыПодключения);
		
		Менеджеры = Новый Массив();
		Менеджеры.Добавить(РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсов);
		
		Если ОчиститьРежимыПодключения Тогда
			Менеджеры.Добавить(РегистрыСведений.РежимыПодключенияВнешнихМодулей);
		КонецЕсли;
		
		Для Каждого Менеджер Из Менеджеры Цикл
			Набор = Менеджер.СоздатьНаборЗаписей();
			Если ПрограммныйМодуль <> Неопределено Тогда
				СвойстваПрограммногоМодуля = РаботаВБезопасномРежимеСлужебный.СвойстваДляРегистраРазрешений(ПрограммныйМодуль);
				Набор.Отбор.ТипПрограммногоМодуля.Установить(СвойстваПрограммногоМодуля.Тип);
				Набор.Отбор.ИдентификаторПрограммногоМодуля.Установить(СвойстваПрограммногоМодуля.Идентификатор);
			КонецЕсли;
			Набор.Записать(Истина);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с таблицами разрешений.
//

// Возвращает строку таблицы разрешений, соответствующую отбору.
// Если в таблице нет строк, соответствующих отбору - может быть добавлена новая.
// Если в таблице больше одной строки, соответствующей отбору - генерируется исключение.
//
// Параметры:
//  ТаблицаРазрешений - ТаблицаЗначений:
//    * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//    * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор
//    * Операция - ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности
//    * Имя - Строка - имя профиля безопасности.
//  Отбор - Структура
//  ДобавитьПриОтсутствии - Булево
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено
//
Функция СтрокаТаблицыРазрешений(Знач ТаблицаРазрешений, Знач Отбор, Знач ДобавитьПриОтсутствии = Истина) Экспорт
	
	Строки = ТаблицаРазрешений.НайтиСтроки(Отбор);
	
	Если Строки.Количество() = 0 Тогда
		
		Если ДобавитьПриОтсутствии Тогда
			
			Строка = ТаблицаРазрешений.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Отбор);
			Возврат Строка;
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	ИначеЕсли Строки.Количество() = 1 Тогда
		
		Возврат Строки.Получить(0);
		
	Иначе
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Нарушение уникальности строк в таблице разрешений по отбору %1'"),
			ОбщегоНазначения.ЗначениеВСтрокуXML(Отбор));
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

