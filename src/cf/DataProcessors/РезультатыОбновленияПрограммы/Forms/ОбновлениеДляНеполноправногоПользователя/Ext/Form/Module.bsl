﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ФормаЗавершитьРаботу.Видимость = Ложь;
	
	СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "Обновление");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ЗапуститьОбновление", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Не ЗавершениеРаботы Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	ЗавершениеРаботы = Истина;
	ПрекратитьРаботуСистемы(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапуститьОбновление()
	Результат = ЗапускОбновленияНаСервере();
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗапуститьОбновлениеЗавершение(Результат, Неопределено);
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗапуститьОбновлениеЗавершение", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗапускОбновленияНаСервере()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Фоновое обновление информационной базы под ограниченными правами'");
	
	Результат = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"ОбновлениеИнформационнойБазыСлужебный.ОбновлениеПодОграниченнымиПравами");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОбновлениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РезультатОбновления = Неопределено;
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		РезультатОбновления = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	КонецЕсли;
	
	Если РезультатОбновления = Истина Тогда
		ЗавершениеРаботы = Истина;
		ПрекратитьРаботуСистемы(Истина);
	Иначе
		НастроитьФорму();
		ОжиданиеСчетчик = 60;
		ПродолжитьОбратныйОтсчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОбратныйОтсчет()
	ОжиданиеСчетчик = ОжиданиеСчетчик - 1;
	
	Если ОжиданиеСчетчик <= 0 Тогда
		ЗавершениеРаботы = Истина;
		ПрекратитьРаботуСистемы(Ложь);
	Иначе
		НовыйЗаголовок = (
			НСтр("ru = 'Завершить работу'")
			+ " ("
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'осталось %1 сек.'"), Строка(ОжиданиеСчетчик))
			+ ")");
			
		Элементы.ФормаЗавершитьРаботу.Заголовок = НовыйЗаголовок;
		
		ПодключитьОбработчикОжидания("ПродолжитьОбратныйОтсчет", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибкаПодготовки;
	Элементы.ФормаЗавершитьРаботу.Видимость = Истина;
	
	СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ОшибкаОбновления");
КонецПроцедуры

#КонецОбласти