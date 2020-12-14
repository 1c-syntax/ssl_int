﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает строки вида "день", "дня", "дней".
//
// Параметры:
//   Число                       - Число  - целое число, к которому нужно добавить предмет исчисления.
//   ФорматнаяСтрока             - Строка - см. одноименный параметр метода ЧислоПрописью,
//                                          например: "ДП=Истина".
//   ПараметрыПредметаИсчисления - Строка - см. одноименный параметр метода ЧислоПрописью,
//                                          например: НСтр("ru = 'день,дня,дней,,,,,,0'").
//
//  Возвращаемое значение:
//   Строка
//
Функция ПредметЦелогоЧисла(Число, ФорматнаяСтрока, ПараметрыПредметаИсчисления) Экспорт
	
	ЦелоеЧисло = Цел(Число);
	
	ПрописьЧисла = ЧислоПрописью(ЦелоеЧисло, ФорматнаяСтрока, НСтр("ru = ',,,,,,,,0'"));
	
	ПрописьЧислаИПредмета = ЧислоПрописью(ЦелоеЧисло, ФорматнаяСтрока, ПараметрыПредметаИсчисления);
	
	Возврат СтрЗаменить(ПрописьЧислаИПредмета, ПрописьЧисла, "");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Восстановление паролей пользователей

Функция ВерсияПредприятияПоддерживаетВосстановлениеПаролей() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	Поддерживает = 
	    (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.15.2106") > 0
	      И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.16.0") < 0)
	Или (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.16.1790") > 0
	      И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.17.0") < 0)
	Или (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.17.1822") > 0
	      И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.18.0") < 0)
	Или ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.18.1200") > 0;
	
	Возврат Поддерживает;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вычисляет начальное имя для входа по полному имени пользователя.
Функция ПолучитьКраткоеИмяПользователяИБ(Знач ПолноеИмя) Экспорт
	
	Разделители = Новый Массив;
	Разделители.Добавить(" ");
	Разделители.Добавить(".");
	
	КраткоеИмя = "";
	Для Счетчик = 1 По 3 Цикл
		
		Если Счетчик <> 1 Тогда
			КраткоеИмя = КраткоеИмя + ВРег(Лев(ПолноеИмя, 1));
		КонецЕсли;
		
		ПозицияРазделителя = 0;
		Для каждого Разделитель Из Разделители Цикл
			ПозицияТекущегоРазделителя = СтрНайти(ПолноеИмя, Разделитель);
			Если ПозицияТекущегоРазделителя > 0
			   И (    ПозицияРазделителя = 0
			      ИЛИ ПозицияРазделителя > ПозицияТекущегоРазделителя ) Тогда
				ПозицияРазделителя = ПозицияТекущегоРазделителя;
			КонецЕсли;
		КонецЦикла;
		
		Если ПозицияРазделителя = 0 Тогда
			Если Счетчик = 1 Тогда
				КраткоеИмя = ПолноеИмя;
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
		Если Счетчик = 1 Тогда
			КраткоеИмя = Лев(ПолноеИмя, ПозицияРазделителя - 1);
		КонецЕсли;
		
		ПолноеИмя = Прав(ПолноеИмя, СтрДлина(ПолноеИмя) - ПозицияРазделителя);
		Пока Разделители.Найти(Лев(ПолноеИмя, 1)) <> Неопределено Цикл
			ПолноеИмя = Сред(ПолноеИмя, 2);
		КонецЦикла;
	КонецЦикла;
	
	Возврат КраткоеИмя;
	
КонецФункции

// Для форма элементов справочников Пользователи и ВнешниеПользователи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОбъектов:
//    * Элементы - ВсеЭлементыФормы:
//        ** ВходВПрограммуРазрешен - ПолеФормы
//                                  - РасширениеПоляФормыДляПоляФлажка
//        ** ИзменитьОграничениеНаВходВПрограмму - ПолеФормы
//                                               - РасширениеПоляФормыДляПоляФлажка
//
Процедура ОбновитьОграничениеСрокаДействия(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ИзменитьОграничениеНаВходВПрограмму.Видимость =
		Элементы.СвойстваПользователяИБ.Видимость И Форма.УровеньДоступа.УправлениеСписком;
	
	Если Не Элементы.СвойстваПользователяИБ.Видимость Тогда
		Элементы.ВходВПрограммуРазрешен.Заголовок = "";
		Возврат;
	КонецЕсли;
	
	Элементы.ИзменитьОграничениеНаВходВПрограмму.Доступность = Форма.УровеньДоступа.НастройкиДляВхода;
	
	ЗаголовокСОграничением = "";
	
	Если Форма.СрокДействияНеОграничен Тогда
		ЗаголовокСОграничением = НСтр("ru = 'Вход в программу разрешен (без ограничения срока)'");
		
	ИначеЕсли ЗначениеЗаполнено(Форма.СрокДействия) Тогда
		ЗаголовокСОграничением = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вход в программу разрешен (до %1)'"),
			Формат(Форма.СрокДействия, "ДЛФ=D"));
			
	ИначеЕсли ЗначениеЗаполнено(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода) Тогда
		ЗаголовокСОграничением = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вход в программу разрешен (запретить, если не работает более %1)'"),
			Формат(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода, "ЧГ=") + " "
				+ ПредметЦелогоЧисла(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода,
					"", НСтр("ru = 'день,дня,дней,,,,,,0'")));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаголовокСОграничением) Тогда
		Элементы.ВходВПрограммуРазрешен.Заголовок = ЗаголовокСОграничением;
		Элементы.ИзменитьОграничениеНаВходВПрограмму.Заголовок = НСтр("ru = 'Изменить ограничение'");
	Иначе
		Элементы.ВходВПрограммуРазрешен.Заголовок = "";
		Элементы.ИзменитьОграничениеНаВходВПрограмму.Заголовок = НСтр("ru = 'Установить ограничение'");
	КонецЕсли;
	
КонецПроцедуры

// Для форма элементов справочников Пользователи и ВнешниеПользователи.
//
// Параметры:
//  Форма - см. Справочник.Пользователи.Форма.ФормаЭлемента
//        - см. Справочник.ВнешниеПользователи.Форма.ФормаЭлемента
//  ПарольУстановлен - Булево
//  АвторизованныйПользователь - СправочникСсылка.Пользователи
//                             - СправочникСсылка.ВнешниеПользователи
//
Процедура УстановитьНаличиеПароля(Форма, ПарольУстановлен, АвторизованныйПользователь) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если ПарольУстановлен Тогда
		Элементы.НадписьНаличиеПароля.Заголовок = НСтр("ru = 'Пароль установлен'");
		Элементы.ПотребоватьСменуПароляПриВходе.Заголовок =
			НСтр("ru = 'Потребовать смену пароля при входе'");
	Иначе
		Элементы.НадписьНаличиеПароля.Заголовок = НСтр("ru = 'Пустой пароль'");
		Элементы.ПотребоватьСменуПароляПриВходе.Заголовок =
			НСтр("ru = 'Потребовать установку пароля при входе'");
	КонецЕсли;
	
	Если ПарольУстановлен
	   И Форма.Объект.Ссылка = АвторизованныйПользователь Тогда
		
		Элементы.СменитьПароль.Заголовок = НСтр("ru = 'Сменить пароль...'");
	Иначе
		Элементы.СменитьПароль.Заголовок = НСтр("ru = 'Установить пароль...'");
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ТекущийПользователь(АвторизованныйПользователь) Экспорт
	
	Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
		ВызватьИсключение
			НСтр("ru = 'Невозможно получить текущего пользователя
			           |в сеансе внешнего пользователя.'");
	КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

// Только для внутреннего использования.
Функция ТекущийВнешнийПользователь(АвторизованныйПользователь) Экспорт
	
	Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ВызватьИсключение
			НСтр("ru = 'Невозможно получить текущего внешнего пользователя
			           |в сеансе пользователя.'");
	КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

#КонецОбласти
