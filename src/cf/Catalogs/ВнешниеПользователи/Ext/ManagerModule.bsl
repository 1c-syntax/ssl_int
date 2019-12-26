﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка -
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ОбъектАвторизации");
	НеРедактируемыеРеквизиты.Добавить("УстановитьРолиНепосредственно");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Ссылка)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("ОбъектАвторизации") Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаЭлемента";
		
		НайденныйВнешнийПользователь = Неопределено;
		ЕстьПравоДобавленияВнешнегоПользователя = Ложь;
		
		ОбъектАвторизацииИспользуется = ПользователиСлужебный.ОбъектАвторизацииИспользуется(
			Параметры.ОбъектАвторизации,
			Неопределено,
			НайденныйВнешнийПользователь,
			ЕстьПравоДобавленияВнешнегоПользователя);
		
		Если ОбъектАвторизацииИспользуется Тогда
			Параметры.Вставить("Ключ", НайденныйВнешнийПользователь);
			
		ИначеЕсли ЕстьПравоДобавленияВнешнегоПользователя Тогда
			
			Параметры.Вставить(
				"ОбъектАвторизацииНовогоВнешнегоПользователя", Параметры.ОбъектАвторизации);
		Иначе
			ОписаниеОшибкиКакПредупреждения =
				НСтр("ru = 'Разрешение на вход в программу не предоставлялось.'");
				
			ВызватьИсключение ОписаниеОшибкиКакПредупреждения;
		КонецЕсли;
		
		Параметры.Удалить("ОбъектАвторизации");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
