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

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ФормироватьСразу = Истина;
	
	Если Форма <> Неопределено Тогда
		УстановитьПредопределенныйПоВариантуВнедрения(Форма, КлючВарианта);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("НаборДанных", ДатыЗапретаПодготовленные(Настройки.ПараметрыДанных));
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.НачатьВывод();
	ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	Пока ЭлементРезультата <> Неопределено Цикл
		ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПредопределенныйПоВариантуВнедрения(Форма, КлючВарианта)
	
	Если Форма.Параметры.КлючВарианта <> Неопределено Тогда
		Возврат; // Вариант отчета указан при открытии.
	КонецЕсли;
	
	Попытка
		Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	Исключение
		Свойства = Новый Структура("ПоказыватьРазделы, ВсеРазделыБезОбъектов", Ложь, Истина);
	КонецПопытки;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		
		Если КлючВарианта <> "ДатыЗапретаИзмененияПоПользователям"
		   И КлючВарианта <> "ДатыЗапретаИзмененияПоРазделамОбъектамДляПользователей" Тогда
		   
			Форма.Параметры.КлючВарианта = "ДатыЗапретаИзмененияПоПользователям";
		КонецЕсли;
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		
		Если КлючВарианта <> "ДатыЗапретаИзмененияПоПользователямБезОбъектов"
		   И КлючВарианта <> "ДатыЗапретаИзмененияПоРазделамДляПользователей" Тогда
		   
			Форма.Параметры.КлючВарианта = "ДатыЗапретаИзмененияПоПользователямБезОбъектов";
		КонецЕсли;
	Иначе
		Если КлючВарианта <> "ДатыЗапретаИзмененияПоПользователямБезРазделов"
		   И КлючВарианта <> "ДатыЗапретаИзмененияПоОбъектамДляПользователей" Тогда
			
			Форма.Параметры.КлючВарианта = "ДатыЗапретаИзмененияПоПользователямБезРазделов";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ДатыЗапретаПодготовленные(ПараметрыДанных)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса();
	Запрос.УстановитьПараметр("ЗаданныеАдресаты",     ЗначениеПользовательскогоПараметра(ПараметрыДанных, "Адресаты"));
	Запрос.УстановитьПараметр("ЗаданныеРазделы",      ЗначениеПользовательскогоПараметра(ПараметрыДанных, "Разделы"));
	Запрос.УстановитьПараметр("ЗаданныеОбъекты",      ЗначениеПользовательскогоПараметра(ПараметрыДанных, "Объекты"));
	Запрос.УстановитьПараметр("ДатыЗапретаИзменения", ДатыЗапретаИзмененияСлужебный.РассчитанныеДатыЗапретаИзменения());
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Таблица.Колонки.Добавить("ОбъектПредставление",            Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("РазделПредставление",            Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("АдресатНастройкиПредставление",  Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ВладелецНастройкиПредставление", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("НастройкаОбщаяДата",             Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("НастройкаДляРаздела",            Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("НастройкаДляВсехАдресатов",      Новый ОписаниеТипов("Булево"));
	
	Для Каждого Строка Из Таблица Цикл
		
		Если Строка.Объект <> Строка.Раздел Тогда
			Строка.ОбъектПредставление = Строка(Строка.Объект);
			
		ИначеЕсли ЗначениеЗаполнено(Строка.Раздел) Тогда
			Строка.ОбъектПредставление = НСтр("ru = 'Для всех объектов, кроме указанных'");
		Иначе
			Строка.ОбъектПредставление = НСтр("ru = 'Для всех разделов и объектов, кроме указанных'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Раздел) Тогда
			Строка.РазделПредставление = Строка(Строка.Раздел);
		Иначе
			Строка.РазделПредставление = "<" + НСтр("ru = 'Общая дата'") + ">";
		КонецЕсли;
		
		Если Строка.АдресатНастройки = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей Тогда
			Строка.АдресатНастройкиПредставление = НСтр("ru = 'Для всех пользователей, кроме указанных'");
		Иначе
			Строка.АдресатНастройкиПредставление = Строка(Строка.АдресатНастройки);
		КонецЕсли;
		
		Если Строка.ВладелецНастройки = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей Тогда
			Строка.ВладелецНастройкиПредставление = НСтр("ru = 'Для всех пользователей, кроме указанных'");
		Иначе
			Строка.ВладелецНастройкиПредставление = Строка(Строка.ВладелецНастройки);
		КонецЕсли;
		
		Строка.НастройкаОбщаяДата  = Не ЗначениеЗаполнено(Строка.Раздел);
		Строка.НастройкаДляРаздела = Строка.Объект = Строка.Раздел;
		Строка.НастройкаДляВсехАдресатов =
			Строка.АдресатНастройки = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ЗначениеПользовательскогоПараметра(ПараметрыДанных, ИмяПараметра)
	
	Параметр = ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	
	Если Не Параметр.Использование Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Параметр.Значение) = Тип("СписокЗначений") Тогда
		Возврат Параметр.Значение.ВыгрузитьЗначения();
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(Параметр.Значение);
	
	Возврат Массив;
	
КонецФункции

Функция ТекстЗапроса()
	
	// АПК:494-выкл: допустимо, так как объем данных небольшой (от единиц до сотен).
	// АПК:96-выкл: допустимо, так как строки не должны повторятся и объем данных небольшой (от единиц до сотен).
	Возврат
	"ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел КАК Раздел,
	|	ДатыЗапретаИзменения.Объект КАК Объект,
	|	ДатыЗапретаИзменения.Пользователь КАК Пользователь,
	|	ДатыЗапретаИзменения.ДатаЗапрета КАК ДатаЗапрета,
	|	ДатыЗапретаИзменения.Комментарий КАК Комментарий
	|ПОМЕСТИТЬ ДатыЗапретаИзменения
	|ИЗ
	|	&ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастроенныеПользователиСГруппами.Пользователь КАК Пользователь,
	|	ДатыЗапретаИзменения.Пользователь КАК ВладелецНастройки,
	|	ДатыЗапретаИзменения.Раздел КАК Раздел,
	|	ДатыЗапретаИзменения.Объект КАК Объект,
	|	ДатыЗапретаИзменения.ДатаЗапрета КАК ДатаЗапрета,
	|	КодыПриоритетов.Значение КАК Приоритет
	|ПОМЕСТИТЬ ДатыЗапрета
	|ИЗ
	|	ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			0 КАК Код,
	|			1 КАК Значение
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1,
	|			2
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			10,
	|			3
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1000,
	|			4
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1001,
	|			5
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1010,
	|			6
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1100,
	|			7
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1101,
	|			8
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1110,
	|			9) КАК КодыПриоритетов
	|		ПО (ВЫБОР
	|				КОГДА ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей)
	|					ТОГДА 0
	|				КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ГруппыПользователей)
	|					ТОГДА 1
	|				КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ГруппыВнешнихПользователей)
	|					ТОГДА 1
	|				ИНАЧЕ 10
	|			КОНЕЦ + ВЫБОР
	|				КОГДА ДатыЗапретаИзменения.Объект = ДатыЗапретаИзменения.Раздел
	|					ТОГДА 0
	|				ИНАЧЕ 100
	|			КОНЕЦ + ВЫБОР
	|				КОГДА ДатыЗапретаИзменения.Раздел = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)
	|					ТОГДА 0
	|				ИНАЧЕ 1000
	|			КОНЕЦ = КодыПриоритетов.Код)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			НастроенныеПользователи.Пользователь КАК Пользователь,
	|			СоставыГруппПользователей.ГруппаПользователей КАК ГруппаПользователей
	|		ИЗ
	|			(ВЫБРАТЬ
	|				СоставыГруппПользователей.Пользователь КАК Пользователь
	|			ИЗ
	|				ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|					ПО ДатыЗапретаИзменения.Пользователь = СоставыГруппПользователей.ГруппаПользователей
	|						И (ЛОЖЬ В (&ЗаданныеАдресаты))
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				СоставыГруппПользователей.Пользователь
	|			ИЗ
	|				РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|			ГДЕ
	|				СоставыГруппПользователей.Пользователь В(&ЗаданныеАдресаты)) КАК НастроенныеПользователи
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|				ПО НастроенныеПользователи.Пользователь = СоставыГруппПользователей.Пользователь
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей),
	|			ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей)
	|		ГДЕ
	|			(ЛОЖЬ В (&ЗаданныеАдресаты)
	|					ИЛИ ИСТИНА В (&ЗаданныеАдресаты))) КАК НастроенныеПользователиСГруппами
	|		ПО (ДатыЗапретаИзменения.Пользователь В (ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей), НастроенныеПользователиСГруппами.ГруппаПользователей))
	|			И (ДатыЗапретаИзменения.Объект <> НЕОПРЕДЕЛЕНО)
	|			И (НЕ(ДатыЗапретаИзменения.Объект <> ДатыЗапретаИзменения.Раздел
	|					И ДатыЗапретаИзменения.Раздел = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДатыЗапрета.Пользователь КАК АдресатНастройки,
	|	ДатыЗапрета.ВладелецНастройки КАК ВладелецНастройки,
	|	ДатыЗапрета.Раздел КАК Раздел,
	|	ДатыЗапрета.Объект КАК Объект,
	|	ПриоритетныеДатыСПричинамиИсключения.ДатаЗапрета КАК ДатаЗапрета,
	|	ДатыЗапрета.ДатаЗапрета КАК ДатаЗапретаНастройки,
	|	ДатыЗапрета.Приоритет КАК ПриоритетНастройки,
	|	ДатыЗапретаИзменения.Комментарий КАК КомментарийНастройки,
	|	ПриоритетныеДатыСПричинамиИсключения.Комментарий КАК Комментарий
	|ИЗ
	|	ДатыЗапрета КАК ДатыЗапрета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ПриоритетныеДаты.Пользователь КАК Пользователь,
	|			ПриоритетныеДаты.Раздел КАК Раздел,
	|			ПриоритетныеДаты.Объект КАК Объект,
	|			ПриоритетныеДаты.ДатаЗапрета КАК ДатаЗапрета,
	|			МАКСИМУМ(ДатыЗапретаИзменения.Комментарий) КАК Комментарий
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ДатыЗапрета.Пользователь КАК Пользователь,
	|				ДатыЗапрета.Раздел КАК Раздел,
	|				ДатыЗапрета.Объект КАК Объект,
	|				МАКСИМУМ(ДатыЗапрета.ДатаЗапрета) КАК ДатаЗапрета,
	|				МАКСИМУМ(ДатыЗапрета.Приоритет) КАК Приоритет
	|			ИЗ
	|				ДатыЗапрета КАК ДатыЗапрета
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|						ДатыЗапрета.Пользователь КАК Пользователь,
	|						ДатыЗапрета.Раздел КАК Раздел,
	|						ДатыЗапрета.Объект КАК Объект,
	|						МАКСИМУМ(ДатыЗапрета.Приоритет) КАК Приоритет
	|					ИЗ
	|						ДатыЗапрета КАК ДатыЗапрета
	|					
	|					СГРУППИРОВАТЬ ПО
	|						ДатыЗапрета.Пользователь,
	|						ДатыЗапрета.Раздел,
	|						ДатыЗапрета.Объект) КАК МаксимальныйПриоритет
	|					ПО ДатыЗапрета.Пользователь = МаксимальныйПриоритет.Пользователь
	|						И ДатыЗапрета.Раздел = МаксимальныйПриоритет.Раздел
	|						И ДатыЗапрета.Объект = МаксимальныйПриоритет.Объект
	|						И ДатыЗапрета.Приоритет = МаксимальныйПриоритет.Приоритет
	|			
	|			СГРУППИРОВАТЬ ПО
	|				ДатыЗапрета.Пользователь,
	|				ДатыЗапрета.Раздел,
	|				ДатыЗапрета.Объект) КАК ПриоритетныеДаты
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыЗапрета КАК ДатыЗапрета
	|				ПО (ДатыЗапрета.Пользователь = ПриоритетныеДаты.Пользователь)
	|					И (ДатыЗапрета.Раздел = ПриоритетныеДаты.Раздел)
	|					И (ДатыЗапрета.Объект = ПриоритетныеДаты.Объект)
	|					И (ДатыЗапрета.Приоритет = ПриоритетныеДаты.Приоритет)
	|					И (ДатыЗапрета.ДатаЗапрета = ПриоритетныеДаты.ДатаЗапрета)
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|				ПО (ДатыЗапрета.ВладелецНастройки = ДатыЗапретаИзменения.Пользователь)
	|					И (ДатыЗапрета.Раздел = ДатыЗапретаИзменения.Раздел)
	|					И (ДатыЗапрета.Объект = ДатыЗапретаИзменения.Объект)
	|					И (ДатыЗапрета.ДатаЗапрета = ДатыЗапретаИзменения.ДатаЗапрета)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ПриоритетныеДаты.Пользователь,
	|			ПриоритетныеДаты.Раздел,
	|			ПриоритетныеДаты.Объект,
	|			ПриоритетныеДаты.Приоритет,
	|			ПриоритетныеДаты.ДатаЗапрета) КАК ПриоритетныеДатыСПричинамиИсключения
	|		ПО ДатыЗапрета.Пользователь = ПриоритетныеДатыСПричинамиИсключения.Пользователь
	|			И ДатыЗапрета.Раздел = ПриоритетныеДатыСПричинамиИсключения.Раздел
	|			И ДатыЗапрета.Объект = ПриоритетныеДатыСПричинамиИсключения.Объект
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|		ПО ДатыЗапрета.ВладелецНастройки = ДатыЗапретаИзменения.Пользователь
	|			И ДатыЗапрета.Раздел = ДатыЗапретаИзменения.Раздел
	|			И ДатыЗапрета.Объект = ДатыЗапретаИзменения.Объект
	|ГДЕ
	|	(ЛОЖЬ В (&ЗаданныеРазделы)
	|			ИЛИ ДатыЗапрета.Раздел = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)
	|			ИЛИ ДатыЗапрета.Раздел В (&ЗаданныеРазделы))
	|	И (ЛОЖЬ В (&ЗаданныеОбъекты)
	|			ИЛИ ДатыЗапрета.Объект = ДатыЗапрета.Раздел
	|			ИЛИ ДатыЗапрета.Объект В (&ЗаданныеОбъекты))";
	// АПК:96-вкл: допустимо, так как строки не должны повторятся и объем данных небольшой (от единиц до сотен).
	// АПК:494-вкл: допустимо, так как объем данных небольшой (от единиц до сотен).
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли