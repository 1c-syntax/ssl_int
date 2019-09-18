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
	
	Разрешение = Параметры.Разрешение;
	Цветность = Параметры.Цветность;
	Поворот = Параметры.Поворот;
	РазмерБумаги = Параметры.РазмерБумаги;
	ДвустороннееСканирование = Параметры.ДвустороннееСканирование;
	ИспользоватьImageMagickДляПреобразованияВPDF = Параметры.ИспользоватьImageMagickДляПреобразованияВPDF;
	ПоказыватьДиалогСканера = Параметры.ПоказыватьДиалогСканера;
	ФорматСканированногоИзображения = Параметры.ФорматСканированногоИзображения;
	КачествоJPG = Параметры.КачествоJPG;
	СжатиеTIFF = Параметры.СжатиеTIFF;
	ФорматХраненияОдностраничный = Параметры.ФорматХраненияОдностраничный;
	ФорматХраненияМногостраничный = Параметры.ФорматХраненияМногостраничный;
	
	Элементы.Поворот.Видимость = Параметры.ДоступностьПоворот;
	Элементы.РазмерБумаги.Видимость = Параметры.ДоступностьРазмерБумаги;
	Элементы.ДвустороннееСканирование.Видимость = Параметры.ДоступностьДвустороннееСканирование;
	
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ФорматМногостраничныйTIF = Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF;
	ФорматОдностраничныйPDF = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF;
	ФорматОдностраничныйJPG = Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG;
	ФорматОдностраничныйTIF = Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF;
	ФорматОдностраничныйPNG = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG;
	
	Если НЕ ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		ФорматХраненияМногостраничный = ФорматМногостраничныйTIF;
	КонецЕсли;
	
	Элементы.ГруппаФорматаХранения.Видимость = ИспользоватьImageMagickДляПреобразованияВPDF;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	ВидимостьФорматаСканирования = (ИспользоватьImageMagickДляПреобразованияВPDF И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF)) ИЛИ (НЕ ИспользоватьImageMagickДляПреобразованияВPDF);
	Элементы.ГруппаФорматаСканирования.Видимость = ВидимостьФорматаСканирования;
	
	Элементы.ФорматХраненияМногостраничный.Доступность = ИспользоватьImageMagickДляПреобразованияВPDF;
	ФорматХраненияОдностраничныйПредыдущее = ФорматХраненияОдностраничный;
	
	Если НЕ ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Формат'");
	Иначе
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Тип'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФорматСканированногоИзображенияПриИзменении(Элемент)
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматХраненияОдностраничныйПриИзменении(Элемент)
	
	ОтработатьИзмененияФорматХраненияОдностраничный();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ПоказыватьДиалогСканера",  ПоказыватьДиалогСканера);
	РезультатВыбора.Вставить("Разрешение",               Разрешение);
	РезультатВыбора.Вставить("Цветность",                Цветность);
	РезультатВыбора.Вставить("Поворот",                  Поворот);
	РезультатВыбора.Вставить("РазмерБумаги",             РазмерБумаги);
	РезультатВыбора.Вставить("ДвустороннееСканирование", ДвустороннееСканирование);
	
	РезультатВыбора.Вставить("ИспользоватьImageMagickДляПреобразованияВPDF",
		ИспользоватьImageMagickДляПреобразованияВPDF);
	
	РезультатВыбора.Вставить("ФорматСканированногоИзображения", ФорматСканированногоИзображения);
	РезультатВыбора.Вставить("КачествоJPG",                     КачествоJPG);
	РезультатВыбора.Вставить("СжатиеTIFF",                      СжатиеTIFF);
	РезультатВыбора.Вставить("ФорматХраненияОдностраничный",    ФорматХраненияОдностраничный);
	РезультатВыбора.Вставить("ФорматХраненияМногостраничный",   ФорматХраненияМногостраничный);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПреобразоватьФорматХраненияВФорматСканирования(ФорматХранения)
	
	Если ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.BMP Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.BMP;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.GIF Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.GIF;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.JPG;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.PNG; 
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.TIF;
	КонецЕсли;
	
	Возврат ФорматСканированногоИзображения; 
	
КонецФункции	

&НаСервере
Процедура ОтработатьИзмененияФорматХраненияОдностраничный()
	
	Элементы.ГруппаФорматаСканирования.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF);
	
	Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
		ФорматСканированногоИзображения = ПреобразоватьФорматХраненияВФорматСканирования(ФорматХраненияОдностраничныйПредыдущее);
	КонецЕсли;
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	ФорматХраненияОдностраничныйПредыдущее = ФорматХраненияОдностраничный;
	
КонецПроцедуры

#КонецОбласти
