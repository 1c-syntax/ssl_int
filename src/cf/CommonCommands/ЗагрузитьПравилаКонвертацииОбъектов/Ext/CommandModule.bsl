﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// вызов сервера
	ИмяПланаОбмена = ИмяПланаОбмена(ПараметрКоманды);
	
	// вызов сервера
	ВидПравил = ПредопределенноеЗначение("Перечисление.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов");
	
	Отбор              = Новый Структура("ИмяПланаОбмена, ВидПравил", ИмяПланаОбмена, ВидПравил);
	ЗначенияЗаполнения = Новый Структура("ИмяПланаОбмена, ВидПравил", ИмяПланаОбмена, ВидПравил);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "ПравилаДляОбменаДанными", ПараметрыВыполненияКоманды.Источник, "ПравилаКонвертацииОбъектов");
	
КонецПроцедуры

&НаСервере
Функция ИмяПланаОбмена(Знач УзелИнформационнойБазы)
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы);
	
КонецФункции

#КонецОбласти
