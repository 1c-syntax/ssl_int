﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает новое описание контакта взаимодействий.
// Для использования в ВзаимодействияКлиентСерверПереопределяемый.ПриОпределенииВозможныхКонтактов.
//
// Возвращаемое значение:
//   Структура - свойства контакта взаимодействий:
//     * Тип                                - Тип     - тип ссылки контакта.
//     * Имя                                 - Строка - имя типа контакта , как оно определено в метаданных.
//     * Представление                       - Строка - представление типа контакта для отображения пользователю.
//     * Иерархический                       - Булево - признак того, является ли справочник иерархическим.
//     * ЕстьВладелец                        - Булево - признак того, что у контакта есть владелец.
//     * ИмяВладельца                        - Строка - имя владельца контакта, как оно определено в метаданных.
//     * ИскатьПоДомену                      - Булево - признак того, что контакты данного типа будет подбираться
//                                                      по совпадению домена, а не по полному адресу электронной почты.
//     * Связь                               - Строка - описывает возможную связь данного контакта с другим контактом, в
//                                                      случае когда текущий контакт является реквизитом другого контакта.
//                                                      Описывается следующей строкой "ИмяТаблицы.ИмяРеквизита".
//     * ИмяРеквизитаПредставлениеКонтакта   - Строка - имя реквизита контакта, из которого будет получено
//                                                      представление контакта. Если не указано, то используется
//                                                      стандартный реквизит Наименование.
//     * ВозможностьИнтерактивногоСоздания   - Булево - признак возможности интерактивного создания контакта из
//                                                      документов - взаимодействий.
//     * ИмяФормыНовогоКонтакта              - Строка - полное имя формы для создания нового контакта,
//                                                      например, "Справочник.Партнеры.Форма.ПомощникНового".
//                                                      Если не заполнено, то открывается форма элемента по умолчанию.
Функция НовоеОписаниеКонтакта() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Тип",                               "");
	Результат.Вставить("Имя",                               "");
	Результат.Вставить("Представление",                     "");
	Результат.Вставить("Иерархический",                     Ложь);
	Результат.Вставить("ЕстьВладелец",                      Ложь);
	Результат.Вставить("ИмяВладельца",                      "");
	Результат.Вставить("ИскатьПоДомену",                    Истина);
	Результат.Вставить("Связь",                             "");
	Результат.Вставить("ИмяРеквизитаПредставлениеКонтакта", "Наименование");
	Результат.Вставить("ВозможностьИнтерактивногоСоздания", Истина);
	Результат.Вставить("ИмяФормыНовогоКонтакта",            "");
	Возврат Результат;
	
КонецФункции	

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ВзаимодействияКлиентСервер.НовоеОписаниеКонтакта.
// Добавляет элемент в массив структур контакта.
//
// Параметры:
//  МассивОписания                     - Массив - массив, в который будут добавлена структура описания контакта.
//  Тип                                - Тип    - тип ссылки контакта.
//  ВозможностьИнтерактивногоСоздания  - Булево - признак возможности интерактивного создания контакта из документов -
//                                                взаимодействий.
//  Имя                                 - Строка - имя типа контакта , как оно определено в метаданных.
//  Представление                       - Строка - представление типа контакта для отображения пользователю.
//  Иерархический                       - Булево - признак того, является ли справочник иерархическим.
//  ЕстьВладелец                        - Булево - признак того, что у контакта есть владелец.
//  ИмяВладельца                        - Строка - имя владельца контакта, как оно определено в метаданных.
//  ИскатьПоДомену                      - Булево - признак того, что по данному типу контакта будет осуществляться
//                                                 поиск по домену.
//  Связь                               - Строка - описывает возможную связь данного контакта с другим контактом, в
//                                                 случае когда текущий контакт является реквизитом другого контакта.
//                                                 Описывается следующей строкой "ИмяТаблицы.ИмяРеквизита".
//  ИмяРеквизитаПредставлениеКонтакта   - Строка - имя реквизита контакта, из которого будет получено представление контакта.
//
Процедура ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов(
	МассивОписания,
	Тип,
	ВозможностьИнтерактивногоСоздания,
	Имя,
	Представление,
	Иерархический,
	ЕстьВладелец,
	ИмяВладельца,
	ИскатьПоДомену,
	Связь,
	ИмяРеквизитаПредставлениеКонтакта = "Наименование") Экспорт
	
	СтруктураОписания = Новый Структура;
	СтруктураОписания.Вставить("Тип",                               Тип);
	СтруктураОписания.Вставить("ВозможностьИнтерактивногоСоздания", ВозможностьИнтерактивногоСоздания);
	СтруктураОписания.Вставить("Имя",                               Имя);
	СтруктураОписания.Вставить("Представление",                     Представление);
	СтруктураОписания.Вставить("Иерархический",                     Иерархический);
	СтруктураОписания.Вставить("ЕстьВладелец",                      ЕстьВладелец);
	СтруктураОписания.Вставить("ИмяВладельца",                      ИмяВладельца);
	СтруктураОписания.Вставить("ИскатьПоДомену",                    ИскатьПоДомену);
	СтруктураОписания.Вставить("Связь",                             Связь);
	СтруктураОписания.Вставить("ИмяРеквизитаПредставлениеКонтакта", ИмяРеквизитаПредставлениеКонтакта);

	
	МассивОписания.Добавить(СтруктураОписания);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Определение типа ссылки

// Определяет, является ли переданная в функцию ссылка взаимодействием.
//
// Параметры:
//  ОбъектСсылка  - Ссылка - для которой необходимо выполняется проверка.
//
// Возвращаемое значение:
//   Булево   - истина, если переданная ссылка является взаимодействием.
//
Функция ЯвляетсяВзаимодействием(ОбъектСсылка) Экспорт
	
	Если ТипЗнч(ОбъектСсылка) = Тип("Тип") Тогда
		ТипОбъекта = ОбъектСсылка;
	Иначе
		ТипОбъекта = ТипЗнч(ОбъектСсылка);
	КонецЕсли;
	
	Возврат ТипОбъекта = Тип("ДокументСсылка.Встреча")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ЗапланированноеВзаимодействие")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ТелефонныйЗвонок")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее")
		ИЛИ ТипОбъекта = Тип("ДокументСсылка.СообщениеSMS");
	
КонецФункции

// Определяет, является ли переданная в функцию ссылка присоединенным файлом взаимодействий.
//
// Параметры:
//  ОбъектСсылка  - Ссылка - для которой необходимо выполняется проверка.
//
// Возвращаемое значение:
//   Булево   - истина, если переданная ссылка является присоединенным файлом взаимодействий.
//
Функция ЯвляетсяПрисоединеннымФайломВзаимодействий(ОбъектСсылка) Экспорт
	
	Возврат ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ВстречаПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ЗапланированноеВзаимодействиеПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ТелефонныйЗвонокПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.СообщениеSMSПрисоединенныеФайлы");
	
КонецФункции

// Проверяет, является ли переданная ссылка предметом взаимодействий.
//
// Параметры:
//  ОбъектСсылка - Ссылка - ссылка, для которой выполняется проверка,
//                          является ли она ссылкой на предмет взаимодействий.
//
// Возвращаемое значение:
//   Булево   - Истина если является, Ложь в обратном случае.
//
Функция ЯвляетсяПредметом(ОбъектСсылка) Экспорт
	
	ПредметыВзаимодействий = ВзаимодействияКлиентСерверСлужебныйПовтИсп.ПредметыВзаимодействий();
	Для каждого Предмет Из ПредметыВзаимодействий Цикл
		Если ТипЗнч(ОбъектСсылка) = Тип(Предмет) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;	
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// Прочее

// Проверяет, является ли файл письмом по расширению файла.
//
// Параметры:
//  ИмяФайла  - Строка - имя проверяемого файла.
//
// Возвращаемое значение:
//   Булево   - Истина, если расширение файла, указывает на то, что он является письмом.
//
Функция ЭтоФайлПисьмо(ИмяФайла) Экспорт

	МассивРасширенийФайла = МассивРасширенийФайлаПисьма();
	РасширениеФайла       = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
	Возврат (МассивРасширенийФайла.Найти(РасширениеФайла) <> Неопределено);
	
КонецФункции

// Устанавливает состояние "Исходящее" для документа сообщение SMS и всех входящих в него сообщений.
//
// Параметры:
//  Объект       - Документ.СообщениеSMS - документ, для которого устанавливается состояние.
//
Процедура УстановитьСостояниеИсходящееДокументСообщениеSMS(Объект) Экспорт
	
	Для каждого Адресат Из Объект.Адресаты Цикл
		
		Адресат.СостояниеСообщения = ПредопределенноеЗначение("Перечисление.СостоянияСообщенияSMS.Исходящее");
		
	КонецЦикла;
	
	Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Исходящее");
	
КонецПроцедуры

// Формирует информационную строку о количестве сообщений и оставшихся символах.
//
// Параметры:
//  ОтправлятьВТранслите  - Булево - признак, того что сообщение при отправке будет автоматически 
//                                   преобразовано в латинские символы.
//  ТекстСообщения  - Строка       - текст сообщения, для которого формируется сообщение.
//
// Возвращаемое значение:
//   Строка   - сформированное информационное сообщение.
//
Функция СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(ОтправлятьВТранслите, ТекстСообщения) Экспорт

	СимволовВСообщении = ?(ОтправлятьВТранслите, 140, 50);
	ЧислоСимволов = СтрДлина(ТекстСообщения);
	КоличествоСообщений   = Цел(ЧислоСимволов / СимволовВСообщении) + 1;
	ОсталосьСимволов      = СимволовВСообщении - ЧислоСимволов % СимволовВСообщении;
	ШаблонТекстаСообщения = НСтр("ru = 'Сообщение - %1, осталось символов - %2'");
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаСообщения, КоличествоСообщений, ОсталосьСимволов);

КонецФункции

Функция ОписанияКонтактов() Экспорт
	
	Возврат ВзаимодействияКлиентСерверСлужебныйПовтИсп.КонтактыВзаимодействий();
	
КонецФункции

// Проверяет заполнение контактов в документе взаимодействий и обновляет форму документа взаимодействий//
// Параметры:
//  Объект - ДокументОбъект - документ взаимодействий, для которой выполняется проверка.
//  Форма - ФормаКлиентскогоПриложения - форма документа взаимодействий.
//  ВидДокумента - Строка - строковое имя документа взаимодействий.
//
Процедура ПроверитьЗаполнениеКонтактов(Объект,Форма,ВидДокумента) Экспорт
	
	КонтактыЗаполнены = КонтактыЗаполнены(Объект,ВидДокумента);
	
	Если КонтактыЗаполнены Тогда
		Форма.Элементы.СтраницыУказаныКонтакты.ТекущаяСтраница = Форма.Элементы.СтраницаКонтактыЗаполнены;
	Иначе
		Форма.Элементы.СтраницыУказаныКонтакты.ТекущаяСтраница = Форма.Элементы.СтраницаКонтактыНеЗаполнены;
	КонецЕсли;
	
КонецПроцедуры

// Получает строковое представление размера файла.
//
// Параметры:
//  РазмерВБайтах - Число - размер в байтах вложенного файла электронного письма.
//
// Возвращаемое значение:
//   Строка   - строковое представление размера вложенного файла электронного письма.
//
Функция ПолучитьСтроковоеПредставлениеРазмераФайла(РазмерВБайтах) Экспорт
	
	РазмерМб = РазмерВБайтах / (1024*1024);
	Если РазмерМб > 1 Тогда
		СтрокаРазмер = Формат(РазмерМб,"ЧДЦ=1") + " " + НСтр("ru = 'Мб'");
	Иначе
		СтрокаРазмер = Формат(РазмерВБайтах /1024,"ЧДЦ=0; ЧН=0") + " " + НСтр("ru = 'Кб'");
	КонецЕсли;
	
	Возврат СтрокаРазмер;
	
КонецФункции

// Обрабатывает изменение быстрого отбора динамического списка документов взаимодействий.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, для которой выполняется действий.
//  ИмяОтбора - Строка - имя изменяемого отбора.
//  ОтборПоПредмету - Булево - признак того, что форма списка параметрическая и на нее наложен отбор по предмету.
//
Процедура БыстрыйОтборСписокПриИзменении(Форма, ИмяОтбора, ДатаДляОтбора = Неопределено, ОтборПоПредмету = Истина) Экспорт
	
	Отбор = ОтборДинамическогоСписка(Форма.Список);
	
	Если ИмяОтбора = "Статус" Тогда
		
		// очистить связанные отборы
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Отбор, "РассмотретьПосле");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Отбор, "Рассмотрено");
		Если НЕ ОтборПоПредмету Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Отбор, "Предмет");
		КонецЕсли;
		
		// Установить отборы для режима.
		Если Форма[ИмяОтбора] = "КРассмотрению" Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Отбор, "Рассмотрено", Ложь,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Отбор, "РассмотретьПосле", ДатаДляОтбора, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, Истина);
			
		ИначеЕсли Форма[ИмяОтбора] = "Отложенные" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Отбор, "Рассмотрено", Ложь,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Отбор, "РассмотретьПосле", , ВидСравненияКомпоновкиДанных.Заполнено,, Истина);
		ИначеЕсли Форма[ИмяОтбора] = "Рассмотренные" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Отбор, "Рассмотрено", Истина,,, Истина);
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Отбор,ИмяОтбора,Форма[ИмяОтбора],,, ЗначениеЗаполнено(Форма[ИмяОтбора]));
		
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает изменение быстрого отбора по типу взаимодействий динамического списка документов взаимодействий.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Содержит динамический список, в котором расположен изменяемый отбор.
//  ТипВзаимодействия - Строка - имя накладываемого отбора.
//
Процедура ПриИзмененииОтбораТипВзаимодействий(Форма,ТипВзаимодействия) Экспорт
	
	Отбор = ОтборДинамическогоСписка(Форма.Список);
	
	// очистить связанные отборы
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Отбор.Элементы, НСтр("ru = 'Отбор по типу взаимодействий'"), ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	// установить отборы для типа
	Если ТипВзаимодействия = "ВсеПисьма" Тогда
		
		СписокТипыПисьма = Новый СписокЗначений;
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Тип", СписокТипыПисьма, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ВходящиеПисьма" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"), ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ИначеЕсли ТипВзаимодействия = "ПисьмаЧерновики" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"), ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СтатусИсходящегоПисьма", ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Черновик"),
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ИсходящиеПисьма" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
		"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СтатусИсходящегоПисьма", ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Исходящее"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "Отправленные" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"СтатусИсходящегоПисьма", ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Отправлено"),
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "УдаленныеПисьма" Тогда
		
		СписокТипыПисьма = Новый СписокЗначений;
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
		СписокТипыПисьма.Добавить(Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", СписокТипыПисьма, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"ПометкаУдаления", Истина,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "Встречи" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.Встреча"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ЗапланированныеВзаимодействия" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ЗапланированноеВзаимодействие"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ТелефонныеЗвонки" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.ТелефонныйЗвонок"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ИсходящиеЗвонки" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Тип", Тип("ДокументСсылка.ТелефонныйЗвонок"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Входящий",Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ТипВзаимодействия = "ВходящиеЗвонки" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.ТелефонныйЗвонок"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора,
			"Входящий", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
			
	ИначеЕсли ТипВзаимодействия = "СообщенияSMS" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, 
			"Тип", Тип("ДокументСсылка.СообщениеSMS"),ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
			
		Отбор.Элементы.Удалить(ГруппаОтбора);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление адресата электронной почты.
//
// Параметры:
//  Имя     - Строка - имя адресата.
//  Адрес   - Строка - адрес электронной почты адресата.
//  Контакт - СправочникСсылка - контакт, которому принадлежит имя и адрес почты.
//
// Возвращаемое значение:
//   Строка - сформированное представление адресата электронной почты.
//
Функция ПолучитьПредставлениеАдресата(Имя, Адрес, Контакт) Экспорт
	
	Результат = ?(Имя = Адрес ИЛИ Имя = "", Адрес,?(ПустаяСтрока(Адрес),Имя, ?(СтрНайти(Имя, Адрес) > 0, Имя, Имя + " <" + Адрес + ">")));
	Если ЗначениеЗаполнено(Контакт) И ТипЗнч(Контакт) <> Тип("Строка") Тогда
		Результат = Результат + " [" + ПолучитьПредставлениеКонтакта(Контакт) + "]";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует представление списка адресатов электронной почты для коллекции адресатов.
//
// Параметры:
//  ТаблицаАдресатов    - ТаблицаЗначений - таблица с данным адресатов.
//  ВключатьИмяКонтакта - Булево - признак необходимости включения в представление данных контакта.
//  Контакт             - СправочникСсылка - контакт, которому принадлежит имя и адрес почты.
//
// Возвращаемое значение:
//  Строка - сформированное представление списка адресатов электронной почты.
//
Функция ПолучитьПредставлениеСпискаАдресатов(ТаблицаАдресатов, ВключатьИмяКонтакта = Истина) Экспорт

	Представление = "";
	Для Каждого СтрокаТаблицы Из ТаблицаАдресатов Цикл
		Представление = Представление 
	              + ПолучитьПредставлениеАдресата(СтрокаТаблицы.Представление,
	                                              СтрокаТаблицы.Адрес, 
	                                             ?(ВключатьИмяКонтакта, СтрокаТаблицы.Контакт, "")) + "; ";
	КонецЦикла;

	Возврат Представление;

КонецФункции

// Проверяет заполнение контактов в документах взаимодействий.
//
// Параметры:
//  ВзаимодействиеОбъект    - ДокументОбъект - документ взаимодействий для которого выполняется проверка.
//  ВидДокумента - Строка - имя документа.
//
// Возвращаемое значение:
//  Булево - Истина если заполнены и Ложь в обратном случае.
//
Функция КонтактыЗаполнены(ВзаимодействиеОбъект,ВидДокумента)
	
	МассивТабличныхЧастей = Новый Массив;
	
	Если ВидДокумента = "ЭлектронноеПисьмоИсходящее" Тогда
		
		МассивТабличныхЧастей.Добавить("ПолучателиПисьма");
		МассивТабличныхЧастей.Добавить("ПолучателиКопий");
		МассивТабличныхЧастей.Добавить("ПолучателиОтвета");
		МассивТабличныхЧастей.Добавить("ПолучателиСкрытыхКопий");
		
	ИначеЕсли ВидДокумента = "ЭлектронноеПисьмоВходящее" Тогда
		
		Если НЕ ЗначениеЗаполнено(ВзаимодействиеОбъект.ОтправительКонтакт) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		МассивТабличныхЧастей.Добавить("ПолучателиПисьма");
		МассивТабличныхЧастей.Добавить("ПолучателиКопий");
		МассивТабличныхЧастей.Добавить("ПолучателиОтвета");
		
	ИначеЕсли ВидДокумента = "Встреча" 
		ИЛИ ВидДокумента = "ЗапланированноеВзаимодействие" Тогда
				
		МассивТабличныхЧастей.Добавить("Участники");
		
	ИначеЕсли ВидДокумента = "СообщениеSMS" Тогда
		
		МассивТабличныхЧастей.Добавить("Адресаты");
		
	ИначеЕсли ВидДокумента = "ТелефонныйЗвонок" Тогда
		
		Если НЕ ЗначениеЗаполнено(ВзаимодействиеОбъект.АбонентКонтакт) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Для каждого ИмяТабличнойЧасти Из МассивТабличныхЧастей Цикл
		Для каждого СтрокаТабличнойЧасти Из ВзаимодействиеОбъект[ИмяТабличнойЧасти] Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Контакт) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Устанавливает значение свойства для всех подчиненных элементов группы.
Процедура УстановитьСвойствоЭлементовГруппы(ГруппаЭлементов, ИмяСвойства, ЗначениеСвойства) Экспорт
	
	Для каждого ПодчиненныйЭлемент Из ГруппаЭлементов.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
			
			УстановитьСвойствоЭлементовГруппы(ПодчиненныйЭлемент, ИмяСвойства, ЗначениеСвойства);
			
		Иначе
			
			ПодчиненныйЭлемент[ИмяСвойства] = ЗначениеСвойства;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПредставлениеКонтакта(Контакт)

	Возврат Строка(Контакт);

КонецФункции

// Определяет отбор динамического списка в зависимости от наличия режима совместимости.
//
// Параметры:
//  Список  - ДинамическийСписок - список, для которого надо определить отбор.
//
// Возвращаемое значение:
//   Отбор   - требуемый отбор.
//
Функция ОтборДинамическогоСписка(Список) Экспорт

	Возврат Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;

КонецФункции

Процедура ОбработкаПолученияПредставления(МенеджерОбъекта, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Тема = ТемаВзаимодействия(Данные.Тема);
	Дата = Формат(Данные.Дата, "ДЛФ=D");
	ТипДокумента = "";
	Если ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.Встреча") Тогда
		ТипДокумента = НСтр("ru = 'Встреча'");
		Дата = Формат(Данные.ДатаНачала, "ДЛФ=D");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ЗапланированноеВзаимодействие") Тогда
		ТипДокумента = НСтр("ru = 'Запланированное взаимодействие'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.СообщениеSMS") Тогда
		ТипДокумента = НСтр("ru = 'SMS'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ТелефонныйЗвонок") Тогда
		ТипДокумента = НСтр("ru = 'Телефонный звонок'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ЭлектронноеПисьмоВходящее") Тогда
		ТипДокумента = НСтр("ru = 'Входящее письмо'");
	ИначеЕсли ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ЭлектронноеПисьмоИсходящее") Тогда
		ТипДокумента = НСтр("ru = 'Исходящее письмо'");
	КонецЕсли;
	
	ШаблонПредставления = НСтр("ru = '%1 от %2 (%3)'");
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Тема, Дата, ТипДокумента);
	
	СтандартнаяОбработка = Ложь;
	 
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(МенеджерОбъекта, Поля, СтандартнаяОбработка) Экспорт
	
	Поля.Добавить("Тема");
	Поля.Добавить("Дата");
	Если ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.Встреча") Тогда
		Поля.Добавить("ДатаНачала");
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Функция МассивРасширенийФайлаПисьма()
	
	МассивРасширенийФайла = Новый Массив;
	МассивРасширенийФайла.Добавить("msg");
	МассивРасширенийФайла.Добавить("eml");
	
	Возврат МассивРасширенийФайла;
	
КонецФункции

Функция ТемаВзаимодействия(Тема) Экспорт

	Возврат ?(ПустаяСтрока(Тема), НСтр("ru = '<Без темы>'"), Тема);

КонецФункции 

#КонецОбласти
