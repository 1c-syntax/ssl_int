﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ВыполняетсяПроверкаНастроек;
	Элементы.ФормаЗакрыть.Заголовок = НСтр("ru = 'Отмена'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ВыполнитьПроверкуНастроек", 0.1, Истина)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НужнаПомощьНажатие(Элемент)
	РаботаСПочтовымиСообщениямиКлиент.ПерейтиКДокументацииПоВводуУчетнойЗаписиЭлектроннойПочты();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПроверкуНастроек()
	ДлительнаяОперация = НачатьВыполнениеНаСервере();
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

&НаСервере
Функция НачатьВыполнениеНаСервере()
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "Справочники.УчетныеЗаписиЭлектроннойПочты.ПроверитьНастройкиУчетнойЗаписи",
		Параметры.УчетнаяЗапись);
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультат(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаЗакрыть.Заголовок = НСтр("ru = 'Закрыть'");
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	РезультатПроверки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	СообщенияОбОшибках = РезультатПроверки.ОшибкиПодключения;
	ВыполненныеПроверки = РезультатПроверки.ВыполненныеПроверки;
	Если ЗначениеЗаполнено(СообщенияОбОшибках) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ПриПроверкеОбнаруженыОшибки;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ПроверкаУспешноВыполнена;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
