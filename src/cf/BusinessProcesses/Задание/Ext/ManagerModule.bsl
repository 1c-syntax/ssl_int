﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
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
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("Исполнитель");
	Результат.Добавить("ПроверитьВыполнение");
	Результат.Добавить("Проверяющий");
	Результат.Добавить("СрокИсполнения");
	Результат.Добавить("СрокПроверки");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.Задание - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", "БизнесПроцесс.Задание.Форма.Действие" + ТочкаМаршрутаБизнесПроцесса.Имя);
	Возврат Результат;
	
КонецФункции

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
	// АПК:1327-выкл Блокировка бизнес-процесса установлена ранее
	// в вызывающей функции БизнесПроцессыИЗадачиВызовСервера.ПеренаправитьЗадачи.
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) 
		+ БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	// АПК:1327-вкл
	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   БизнесПроцессСсылка - БизнесПроцессСсылка - бизнес-процесс, по которому сформирована задача ЗадачаСсылка.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	ЭтоТочкаМаршрутаВыполнить = (ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить);
	ЭтоТочкаМаршрутаПроверить = (ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Задание.ТочкиМаршрута.Проверить);
	Если Не ЭтоТочкаМаршрутаВыполнить И Не ЭтоТочкаМаршрутаПроверить Тогда
		Возврат;
	КонецЕсли;
	
	// Устанавливаем значения по умолчанию для пакетного выполнения задач.
	НачатьТранзакцию();
	Попытка
		БизнесПроцессыИЗадачиСервер.ЗаблокироватьБизнесПроцессы(БизнесПроцессСсылка);
		
		УстановитьПривилегированныйРежим(Истина);
		ЗаданиеОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
		
		Если ЭтоТочкаМаршрутаВыполнить Тогда
			ЗаданиеОбъект.Выполнено = Истина;	
		ИначеЕсли ЭтоТочкаМаршрутаПроверить Тогда
			ЗаданиеОбъект.Выполнено = Истина;
			ЗаданиеОбъект.Подтверждено = Истина;
		КонецЕсли;
		ЗаданиеОбъект.Записать(); // АПК:1327 Блокировка в БизнесПроцессыИЗадачиСервер.ЗаблокироватьБизнесПроцессы.
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;	
	
КонецПроцедуры	

// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Задание
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ПО
	|	ИсполнителиЗадач.РольИсполнителя = Задание.Исполнитель
	|	И ИсполнителиЗадач.ОсновнойОбъектАдресации = Задание.ОсновнойОбъектАдресации
	|	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = Задание.ДополнительныйОбъектАдресации
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ПроверяющиеЗадач
	|ПО
	|	ПроверяющиеЗадач.РольИсполнителя = Задание.Проверяющий
	|	И ПроверяющиеЗадач.ОсновнойОбъектАдресации = Задание.ОсновнойОбъектАдресацииПроверяющий
	|	И ПроверяющиеЗадач.ДополнительныйОбъектАдресации = Задание.ДополнительныйОбъектАдресацииПроверяющий
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)
	|	ИЛИ ЗначениеРазрешено(Исполнитель КРОМЕ Справочник.РолиИсполнителей)
	|	ИЛИ ЗначениеРазрешено(ИсполнителиЗадач.Исполнитель)
	|	ИЛИ ЗначениеРазрешено(Проверяющий КРОМЕ Справочник.РолиИсполнителей)
	|	ИЛИ ЗначениеРазрешено(ПроверяющиеЗадач.Исполнитель)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Команда = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.БизнесПроцессы.Задание);
		Если Команда <> Неопределено Тогда
			Команда.ФункциональныеОпции = "ИспользоватьБизнесПроцессыИЗадачи";
		КонецЕсли;
		Возврат Команда;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие

// Устанавливает состояние элементов формы задачи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения:
//   * Элементы - ВсеЭлементыФормы:
//    ** Предмет - РасширениеПоляФормыДляПоляНадписи
// 
Процедура УстановитьСостояниеЭлементовФормыЗадачи(Форма) Экспорт
	
	Если Форма.Элементы.Найти("РезультатВыполнения") <> Неопределено 
		И Форма.Элементы.Найти("ИсторияВыполнения") <> Неопределено Тогда
			Форма.Элементы.ИсторияВыполнения.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Форма.ЗаданиеРезультатВыполнения);
	КонецЕсли;
	
	Форма.Элементы.Предмет.Гиперссылка = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
	Форма.ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Форма.Объект.Предмет);	
	
КонецПроцедуры

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = "%1, %2 " + НСтр("ru = 'перенаправил(а) задачу'") + ":
		|%3
		|";
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаСсылка.ДатаИсполнения, ЗадачаСсылка.Исполнитель, Комментарий);
	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли