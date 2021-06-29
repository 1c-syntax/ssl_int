﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отправляет SMS через настроенного поставщика услуги.
//
// Параметры:
//  ПараметрыОтправки - Структура:
//   * Провайдер          - ПеречислениеСсылка.ПровайдерыSMS - поставщик услуги по отправке SMS.
//   * НомераПолучателей  - Массив - массив строк номеров получателей в формате +7ХХХХХХХХХХ;
//   * Текст              - Строка - текст сообщения, максимальная длина у операторов может быть разной;
//   * ИмяОтправителя     - Строка - имя отправителя, которое будет отображаться вместо номера у получателей;
//   * Логин              - Строка - логин для доступа к услуге отправки SMS;
//   * Пароль             - Строка - пароль для доступа к услуге отправки SMS.
//   
//  Результат - Структура - возвращаемое значение. Результат отправки:
//    * ОтправленныеСообщения - Массив из Структура:
//     ** НомерПолучателя - Строка - номер получателя из массива НомераПолучателей;
//     ** ИдентификаторСообщения - Строка - идентификатор SMS, по которому можно запросить статус отправки.
//    ОписаниеОшибки - Строка - пользовательское представление ошибки, если пустая строка, то ошибки нет.
//
Процедура ОтправитьSMS(ПараметрыОтправки, Результат) Экспорт
	
	
	
КонецПроцедуры

// Запрашивает статус доставки SMS у поставщика услуг.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный SMS при отправке.
//  Провайдер - ПеречислениеСсылка.ПровайдерыSMS - провайдер услуги отправки SMS.
//  Логин              - Строка - логин для доступа к услуге отправки SMS.
//  Пароль             - Строка - пароль для доступа к услуге отправки SMS.
//  Результат          - см. ОтправкаSMS.СтатусДоставки.
//
Процедура СтатусДоставки(ИдентификаторСообщения, Провайдер, Логин, Пароль, Результат) Экспорт 
	
	
	
КонецПроцедуры

// Проверяет правильность сохраненных настроек отправки SMS.
//
// Параметры:
//  НастройкиОтправкиSMS - Структура - описание текущих настроек отправки SMS:
//   * Провайдер - ПеречислениеСсылка.ПровайдерыSMS
//   * Логин - Строка
//   * Пароль - Строка
//   * ИмяОтправителя - Строка
//  Отказ - Булево - установить этот параметр в Истина, если настройки не заполнены или заполнены неверно.
//
Процедура ПриПроверкеНастроекОтправкиSMS(НастройкиОтправкиSMS, Отказ) Экспорт

КонецПроцедуры

// Дополняет список разрешений для отправки SMS.
//
// Параметры:
//  Разрешения - Массив - массив объектов, возвращаемых одной из функций РаботаВБезопасномРежиме.Разрешение*().
//
Процедура ПриПолученииРазрешений(Разрешения) Экспорт
	
КонецПроцедуры

#КонецОбласти
