﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Описывает параметр шаблона для использования их во внешних обработках.
//
// Параметры:
//  ТаблицаПараметров           - ТаблицаЗначений - таблица с параметрами.
//  ИмяПараметра                - Строка - имя используемого параметра.
//  ОписаниеТипа                - ОписаниеТипов - тип параметра.
//  ЭтоПредопределенныйПараметр - Булево - если Ложь, то это произвольный параметр, иначе основной.
//  ПредставлениеПараметра      - Строка - выводимое представление параметра.
//
Процедура ДобавитьПараметрШаблона(ТаблицаПараметров, ИмяПараметра, ОписаниеТипа, ЭтоПредопределенныйПараметр, ПредставлениеПараметра = "") Экспорт

	НоваяСтрока                             = ТаблицаПараметров.Добавить();
	НоваяСтрока.ИмяПараметра                = ИмяПараметра;
	НоваяСтрока.ОписаниеТипа                = ОписаниеТипа;
	НоваяСтрока.ЭтоПредопределенныйПараметр = ЭтоПредопределенныйПараметр;
	НоваяСтрока.ПредставлениеПараметра      = ?(ПустаяСтрока(ПредставлениеПараметра),ИмяПараметра, ПредставлениеПараметра);
	
КонецПроцедуры

// Инициализирует структуру сообщения по шаблону, которую должна вернуть внешняя обработка.
//
// Возвращаемое значение:
//   Структура - созданная структура.
//
Функция ИнициализироватьСтруктуруСообщения() Экспорт
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("ТекстСообщенияSMS", "");
	СтруктураСообщения.Вставить("ТемаПисьма", "");
	СтруктураСообщения.Вставить("ТекстПисьма", "");
	СтруктураСообщения.Вставить("СтруктураВложений", Новый Структура);
	СтруктураСообщения.Вставить("ТекстПисьмаHTML", "<HTML></HTML>");
	
	Возврат СтруктураСообщения;
	
КонецФункции

// Инициализирует структуру Получатели для заполнения возможных получателей сообщения.
//
// Возвращаемое значение:
//   Структура - созданная структура.
//
Функция ИнициализироватьСтруктуруПолучатели() Экспорт
	
	Возврат Новый Структура("Получатель", Новый Массив);
	
КонецФункции

// Конструктор параметров шаблона.
//
// Возвращаемое значение:
//  Структура - список параметров шаблона, где:
//   * Тема - Строка - тема шаблонов (для  электронных писем).
//   * Текст - Строка - текст шаблона;
//   * ПодписьИПечать - Булево - признак подписи и печати в печатных формах;
//   * ПараметрыСообщения - Структура - дополнительные параметры сообщения;
//   * Наименование - Строка - наименование шаблона сообщения;
//   * Ссылка - Неопределено - ссылка на элемент справочника;
//   * ВладелецШаблона - Неопределено -  владельца контекстного шаблона;
//   * ПараметрыСКД - Соответствие - набор параметров при получении данных с использованием СКД;
//   * Параметры - Соответствие - параметры шаблона;
//   * Макет - Строка - имя макета СКД;
//   * ВыбранныеВложения - Соответствие - выбранные печатные формы и вложения в шаблон;
//   * ФорматыВложений - СписокЗначений - формат, в котором сохраняются печатные формы;
//   * РазворачиватьСсылочныеРеквизиты - Булево - если Истина, то у ссылочных реквизитов доступны их реквизиты.
//   * ШаблонПоВнешнейОбработке - Булево - если Истина, то шаблон формирует внешней обработкой;
//   * ВнешняяОбработка - Неопределено - ссылка на внешнюю обработку;
//   * Отправитель - Строка - электронная почта отправителя;
//   * ПеревестиВТранслит - Булево - если Истина, то сформированные  печатные формы и файлы будут иметь имена, 
//                                   содержащие только латинские буквы и цифры, для возможности переноса между
//                                   различными операционными системами. Например, файл "Счет на оплату.pdf" 
//                                   будет сохранен с именем "Schet na oplaty.pdf";
//   * УпаковатьВАрхив - Булево - признак того, что вложения и печатные формы должны быть упакованы в архив
//                                при отправке;
//   * ФорматПисьма - ПеречислениеСсылка.СпособыРедактированияЭлектронныхПисем - вид текста письма: HTML или ОбычныйТекст;
//   * ПолноеИмяТипаНазначения - Строка - полное имя объекта метаданных, на основании которого создается сообщения;
//   * Назначение - Строка - назначение шаблона сообщений;
//   * ТипШаблона - Строка - варианты: "Письмо" или "SMS".
//
Функция ОписаниеПараметровШаблона() Экспорт
	Результат = Новый Структура;
	
	Результат.Вставить("Текст", "");
	Результат.Вставить("Тема", "");
	Результат.Вставить("ТипШаблона", "Письмо");
	Результат.Вставить("Назначение", "");
	Результат.Вставить("ПолноеИмяТипаНазначения", "");
	Результат.Вставить("ФорматПисьма", ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML"));
	Результат.Вставить("УпаковатьВАрхив", Ложь);
	Результат.Вставить("ТранслитерироватьИменаФайлов", Ложь);
	Результат.Вставить("ПеревестиВТранслит", Ложь);
	Результат.Вставить("Отправитель", "");
	Результат.Вставить("ВнешняяОбработка", Неопределено);
	Результат.Вставить("ШаблонПоВнешнейОбработке", Ложь);
	Результат.Вставить("РазворачиватьСсылочныеРеквизиты", Истина);
	Результат.Вставить("ФорматыВложений", Новый СписокЗначений);
	Результат.Вставить("ВыбранныеВложения", Новый Соответствие);
	Результат.Вставить("Макет", "");
	Результат.Вставить("Параметры", Новый Соответствие);
	Результат.Вставить("ПараметрыСКД", Новый Соответствие);
	Результат.Вставить("ВладелецШаблона", Неопределено);
	Результат.Вставить("Ссылка", Неопределено);
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ПараметрыСообщения", Новый Структура);
	Результат.Вставить("ПодписьИПечать", Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяШаблонаЭлектронныхПисем() Экспорт
	Возврат "Email";
КонецФункции

Функция ИмяШаблонаSMS() Экспорт
	Возврат "SMS";
КонецФункции

Функция ИдентификаторОбщий() Экспорт
	Возврат "Общий";
КонецФункции

Функция ОбщийПредставление() Экспорт
	Возврат НСтр("ru = 'Общий'");
КонецФункции

// Параметры:
//  Шаблон - СправочникСсылка.ШаблоныСообщений
//  Предмет - ЛюбаяСсылка
//  УникальныйИдентификатор - УникальныйИдентификатор
// Возвращаемое значение:
//  Структура:
//    * ДополнительныеПараметры - Структура:
//       ** ПреобразовыватьHTMLДляФорматированногоДокумента - Булево
//       ** ВидСообщения - Строка
//       ** ОтправитьСразу - Булево
//       ** УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//       ** ПечатныеФормы - Массив
//       ** НастройкиСохранения - Произвольный
//       ** ПроизвольныеПараметры - Соответствие
//
Функция КонструкторПараметровОтправки(Шаблон, Предмет, УникальныйИдентификатор) Экспорт
	
	ПараметрыОтправки = Новый Структура();
	ПараметрыОтправки.Вставить("Шаблон", Шаблон);
	ПараметрыОтправки.Вставить("Предмет", Предмет);
	ПараметрыОтправки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтправки.Вставить("ДополнительныеПараметры", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ВидСообщения", "");
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ОтправитьСразу", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПараметрыСообщения", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("УчетнаяЗапись", Неопределено);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПечатныеФормы", Новый Массив);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("НастройкиСохранения");
	
	Возврат ПараметрыОтправки;
	
КонецФункции

Функция ЗаголовокПроизвольныхПараметров() Экспорт
	Возврат НСтр("ru = 'Произвольные'");
КонецФункции

// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы файла.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника с именем "*ПрисоединенныеФайлы".
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОпределитьФормуПрисоединенногоФайла(Источник, ВидФормы, Параметры,
				ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
				
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		
		МодульРаботаСФайламиСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебныйВызовСервера");
		МодульРаботаСФайламиСлужебныйВызовСервера.ОпределитьФормуПрисоединенногоФайла(Источник, ВидФормы, Параметры,
				ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
		
	#Иначе
		
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		
		МодульРаботаСФайламиСлужебныйВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиСлужебныйВызовСервера");
		МодульРаботаСФайламиСлужебныйВызовСервера.ОпределитьФормуПрисоединенногоФайла(Источник, ВидФормы, Параметры,
				ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
			
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти
