﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняемаяКоманда;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ИмяРаздела)
		И Параметры.ИмяРаздела <> ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы() Тогда
		СсылкаРаздела = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Подсистемы.Найти(Параметры.ИмяРаздела));
	КонецЕсли;
	
	ВидОбработок = ДополнительныеОтчетыИОбработки.ПолучитьВидОбработкиПоСтроковомуПредставлениюВида(Параметры.Вид);
	Если ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Команды заполнения объектов'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
		ЭтоНазначаемыеОбработки = Истина;
		ЭтоОтчеты = Истина;
		Заголовок = НСтр("ru = 'Отчеты'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Дополнительные печатные формы'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Команды создания связанных объектов'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
		ЭтоГлобальныеОбработки = Истина;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительные обработки (%1)'"), 
			ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СсылкаРаздела));
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		ЭтоГлобальныеОбработки = Истина;
		ЭтоОтчеты = Истина;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительные отчеты (%1)'"), 
			ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СсылкаРаздела));
	КонецЕсли;
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ЭтоНазначаемыеОбработки Тогда
		Элементы.НастроитьСписок.Видимость = Ложь;
		
		ОбъектыНазначения.ЗагрузитьЗначения(Параметры.ОбъектыНазначения.ВыгрузитьЗначения());
		Если ОбъектыНазначения.Количество() = 0 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ИнформацияОВладельце = ДополнительныеОтчетыИОбработкиПовтИсп.ПараметрыФормыНазначаемогоОбъекта(Параметры.ИмяФормы);
		МетаданныеРодителя = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектыНазначения[0].Значение));
		Если МетаданныеРодителя = Неопределено Тогда
			СсылкаРодителя = ИнформацияОВладельце.СсылкаРодителя;
		Иначе
			СсылкаРодителя = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеРодителя);
		КонецЕсли;
		Если ТипЗнч(ИнформацияОВладельце) = Тип("ФиксированнаяСтруктура") Тогда
			ЭтоФормаОбъекта = ИнформацияОВладельце.ЭтоФормаОбъекта;
		Иначе
			ЭтоФормаОбъекта = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТаблицуОбработок();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВыбранноеЗначение = "ВыполненаНастройкаМоихОтчетовИОбработок" Тогда
		ЗаполнитьТаблицуОбработок();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаКоманд

&НаКлиенте
Процедура ТаблицаКомандВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполнитьОбработкуПоПараметрам();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	ВыполнитьОбработкуПоПараметрам()
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСписок(Команда)
	ПараметрыФормы = Новый Структура("ВидОбработок, СсылкаРаздела");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.НастройкаМоихОтчетовИОбработок", ПараметрыФормы, ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыполнениеОбработки(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуОбработок()
	ТипыКоманд = Новый Массив;
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода);
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода);
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы);
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме);
	
	Запрос = ДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(ВидОбработок, ?(ЭтоГлобальныеОбработки, СсылкаРаздела, СсылкаРодителя), ЭтоФормаОбъекта, ТипыКоманд);
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	ТаблицаКоманд.Загрузить(ТаблицаРезультат);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуПоПараметрам()
	ДанныеОбработки = Элементы.ТаблицаКоманд.ТекущиеДанные;
	Если ДанныеОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняемаяКоманда = Новый Структура(
		"Ссылка, Представление, 
		|Идентификатор, ВариантЗапуска, ПоказыватьОповещение, 
		|Модификатор, ОбъектыНазначения, ЭтоОтчет, Вид");
	ЗаполнитьЗначенияСвойств(ВыполняемаяКоманда, ДанныеОбработки);
	Если НЕ ЭтоГлобальныеОбработки Тогда
		ВыполняемаяКоманда.ОбъектыНазначения = ОбъектыНазначения.ВыгрузитьЗначения();
	КонецЕсли;
	ВыполняемаяКоманда.ЭтоОтчет = ЭтоОтчеты;
	ВыполняемаяКоманда.Вид = ВидОбработок;
	
	Если ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		Закрыть();
		
	ИначеЕсли ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		Закрыть();
		
	ИначеЕсли ВидОбработок = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма")
		И ДанныеОбработки.Модификатор = "ПечатьMXL" Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		Закрыть();
		
	ИначеЕсли ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		// Изменение элементов формы
		Элементы.ПоясняющаяДекорация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполняется команда ""%1""...'"),
			ДанныеОбработки.Представление);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыполненияОбработки;
		Элементы.НастроитьСписок.Видимость = Ложь;
		Элементы.ВыполнитьОбработку.Видимость = Ложь;
		
		// Вызов сервера только после перехода формы в консистентное состояние.
		ПодключитьОбработчикОжидания("ВыполнитьСерверныйМетодОбработки", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСерверныйМетодОбработки()
	
	Задание = ЗапуститьФоновоеЗадание(ВыполняемаяКоманда, УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ВыполнитьСерверныйМетодОбработкиЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновоеЗадание(Знач ВыполняемаяКоманда, Знач УникальныйИдентификатор)
	ИмяМетода = "ДополнительныеОтчетыИОбработки.ВыполнитьКоманду";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Доп. отчеты и обработки: Выполнение команды ""%1""'"),
		ВыполняемаяКоманда.Представление);
	
	ПараметрыМетода = Новый Структура("ДополнительнаяОбработкаСсылка, ИдентификаторКоманды, ОбъектыНазначения");
	ПараметрыМетода.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыМетода.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыМетода.ОбъектыНазначения             = ВыполняемаяКоманда.ОбъектыНазначения;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции

&НаКлиенте
Процедура ВыполнитьСерверныйМетодОбработкиЗавершение(Задание, ДополнительныеПараметры) Экспорт
	
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус <> "Выполнено" Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Команда ""%1"" не выполнена:'"),
			ВыполняемаяКоманда.Представление);
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		ВызватьИсключение Текст + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
	КонецЕсли;
		
	// Показ всплывающего оповещения и закрытие этой формы.
	Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Команда выполнена'"),, ВыполняемаяКоманда.Представление);
	КонецЕсли;
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
	// Обновление формы владельца.
	Если ЭтоФормаОбъекта Тогда
		Попытка
			ВладелецФормы.Прочитать();
		Исключение
			// Действие не требуется.
		КонецПопытки;
	КонецЕсли;
	
	// Оповещение других форм.
	РезультатВыполнения = ПолучитьИзВременногоХранилища(Задание.АдресРезультата);
	ОповеститьФормы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатВыполнения, "ОповеститьФормы");
	Если ОповеститьФормы <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ОповеститьФормыОбИзменении(ОповеститьФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти