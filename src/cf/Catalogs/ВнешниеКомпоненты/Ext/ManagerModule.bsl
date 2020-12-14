﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает ссылку на справочник внешней компоненты по идентификатору и версии.
//
// Параметры:
//  Идентификатор - Строка - идентификатор объекта внешнего компонента.
//  Версия        - Строка - версия компоненты.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеКомпоненты - ссылка на контейнер внешней компоненты в информационной базе.
//
Функция НайтиПоИдентификатору(Идентификатор, Версия = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Если Не ЗначениеЗаполнено(Версия) Тогда 
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
			|	ВнешниеКомпоненты.ДатаВерсии КАК ДатаВерсии,
			|	ВЫБОР
			|		КОГДА ВнешниеКомпоненты.Использование = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияВнешнихКомпонент.Используется)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Использование,
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
			|
			|УПОРЯДОЧИТЬ ПО
			|	Использование УБЫВ,
			|	ДатаВерсии УБЫВ";
	Иначе 
		Запрос.УстановитьПараметр("Версия", Версия);
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка,
			|	ВЫБОР
			|		КОГДА ВнешниеКомпоненты.Использование = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияВнешнихКомпонент.Используется)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Использование
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
			|	И ВнешниеКомпоненты.Версия = &Версия
			|
			|УПОРЯДОЧИТЬ ПО
			|	Использование УБЫВ";
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли