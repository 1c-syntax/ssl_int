﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	УстановитьУсловноеОформление();
	
	РазрешеноНастраиватьПравилаПроверкиУчета = ПравоДоступа("Изменение", Метаданные.Справочники.ПравилаПроверкиУчета);
	Элементы.ФормаВыполнитьПроверку.Видимость = РазрешеноНастраиватьПравилаПроверкиУчета;
	Элементы.СписокКонтекстноеМенюВыполнитьПроверку.Видимость = РазрешеноНастраиватьПравилаПроверкиУчета;
	Элементы.ФормаВосстановитьПоНачальномуЗаполнению.Видимость = РазрешеноНастраиватьПравилаПроверкиУчета;
	
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	Если Не ( (Не ОбщегоНазначения.РазделениеВключено() И РазрешеноНастраиватьПравилаПроверкиУчета)
		Или (ОбщегоНазначения.РазделениеВключено() И ЭтоАдминистраторСистемы) ) Тогда
		
		Элементы.ПредставлениеОбщегоРасписания.Видимость    = Ложь;
		Элементы.РегламентноеЗаданиеПредставление.Видимость = Ложь;
		
	Иначе
		
		ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
		Если ОбщееРегламентноеЗадание <> Неопределено Тогда
			Если Не ОбщегоНазначения.РазделениеВключено() Тогда
				ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Расписание)
			Иначе
				Если ЭтоАдминистраторСистемы Тогда
					ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Шаблон.Расписание.Получить());
					Элементы.РегламентноеЗаданиеПредставление.Видимость = Истина;
				Иначе
					Элементы.РегламентноеЗаданиеПредставление.Видимость = Ложь;
					Элементы.ПредставлениеОбщегоРасписания.Видимость    = Ложь;
					ОбщееРасписаниеПредставление                        = "";
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если (ОбщегоНазначения.РазделениеВключено() И ЭтоАдминистраторСистемы) Или Не ОбщегоНазначения.РазделениеВключено() Тогда
				ОбщееРасписаниеПредставление = НСтр("ru = 'Регламентное задание не доступно'");
			Иначе
				ОбщееРасписаниеПредставление                     = "";
				Элементы.ПредставлениеОбщегоРасписания.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПредставлениеОбщегоРасписания", ОбщееРасписаниеПредставление);
		
		Элементы.ПредставлениеОбщегоРасписания.Заголовок = СформироватьСтрокуСРасписанием();
		
	КонецЕсли;
	
	Элементы.ПредставлениеОбщегоРасписания.Доступность = ОбновлениеИнформационнойБазы.ОбъектОбработан(
		Метаданные.Справочники.ПравилаПроверкиУчета.ПолноеИмя()).Обработан;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ДополнительныеСвойстваКомпоновщика = Настройки.ДополнительныеСвойства;
	Если Не ДополнительныеСвойстваКомпоновщика.Свойство("ПредставлениеОбщегоРасписания") Тогда
		Возврат;
	КонецЕсли;
	
	КлючиСтрок = Строки.ПолучитьКлючи();
	Для Каждого КлючСтроки Из КлючиСтрок Цикл
		ДанныеСтроки = Строки[КлючСтроки].Данные;
		Если ДанныеСтроки.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		Если ДанныеСтроки.СпособВыполнения = Перечисления.СпособыВыполненияПроверки.Вручную Тогда
			ДанныеСтроки.РегламентноеЗаданиеПредставление = НСтр("ru = 'Вручную'");
		ИначеЕсли ДанныеСтроки.СпособВыполнения = Перечисления.СпособыВыполненияПроверки.ПоОбщемуРасписанию Тогда
			ДанныеСтроки.РегламентноеЗаданиеПредставление = НСтр("ru = 'По общему расписанию'")
		ИначеЕсли ДанныеСтроки.СпособВыполнения = Перечисления.СпособыВыполненияПроверки.ПоОтдельномуРасписанию Тогда
			ИдентификаторЗадания = ДанныеСтроки.ИдентификаторРегламентногоЗадания;
			Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
				ДанныеСтроки.РегламентноеЗаданиеПредставление = НСтр("ru = 'Расписание не задано'");
			Иначе
				НайденноеРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Новый УникальныйИдентификатор(ИдентификаторЗадания));
				Если НайденноеРегламентноеЗадание <> Неопределено Тогда
					РасписаниеСтрокой = Строка(НайденноеРегламентноеЗадание.Расписание);
				Иначе
					
					ОбъектПравила = КлючСтроки.ПолучитьОбъект();
					
					Параметры = Новый Структура;
					Параметры.Вставить("Использование", Истина);
					Параметры.Вставить("Метаданные",    Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
					Параметры.Вставить("Расписание",    ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(
						ОбъектПравила.РасписаниеВыполненияПроверки.Получить()));
					
					ВосстановленноеЗадание = РегламентныеЗаданияСервер.ДобавитьЗадание(Параметры);
					
					ПараметрыЗадания = Новый Структура;
					МассивПараметров = Новый Массив;
					МассивПараметров.Добавить(Строка(ВосстановленноеЗадание.УникальныйИдентификатор));
					ПараметрыЗадания.Вставить("Параметры", МассивПараметров);
					
					РегламентныеЗаданияСервер.ИзменитьЗадание(ВосстановленноеЗадание.УникальныйИдентификатор, ПараметрыЗадания);
					
					ОбъектПравила.ИдентификаторРегламентногоЗадания = Строка(ВосстановленноеЗадание.УникальныйИдентификатор);
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектПравила);
					
					РасписаниеСтрокой = Строка(ВосстановленноеЗадание.Расписание);
					
				КонецЕсли;
				ДанныеСтроки.РегламентноеЗаданиеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'По расписанию: ""%1""'"), РасписаниеСтрокой);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	
	ЕстьГруппы = Ложь;
	Проверки = ВыделенныеПроверки(ЕстьГруппы);
	Если Проверки.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Необходимо выбрать в списке одну или несколько проверок.'");
	КонецЕсли;
		
	Если ЕстьГруппы Тогда
		Проверки = ВсеВыделенныеПроверки(Проверки);
	КонецЕсли;

	Если Проверки.Количество() > 0 Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполнить выбранные проверки (%1)?
				|Это может занять некоторое время.'"),
			Проверки.Количество());
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполнить выбранную проверку ""%1""?
				|Это может занять некоторое время.'"),
			Проверки[0]);
	КонецЕсли;
	ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьПроверкуПродолжение", ЭтотОбъект, Проверки),
		ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ВыполнитьВсеПроверки(Команда)
	Проверки = ВсеВыделенныеПроверки();
	Если Проверки.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Необходимо выбрать в списке одну или несколько проверок.'");
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнить все проверки (%1)?
			|Это может занять некоторое время.'"),
		Проверки.Количество());
	ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьПроверкуПродолжение", ЭтотОбъект, Проверки),
		ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ВосстановитьПоНачальномуЗаполнению(Команда)
	ВосстановитьПоНачальномуЗаполнениюНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	// Не выводить, если не описаны причины возникновения проблемы.
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.Причины.Имя);
	ОформляемоеПоле.Использование = Истина;
	
	ЭлементОтбораДанных = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Причины");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = Элемент.Оформление.Элементы.Найти("Видимость");
	ЭлементЦветаОформления.Значение = Ложь;   
	ЭлементЦветаОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПроверкиНаСервере(Проверки)
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выполнение проверок ведения учета'");
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "КонтрольВеденияУчетаСлужебный.ВыполнитьПроверки", Проверки);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПроверкуПродолжение(РезультатВопроса, Проверки) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ВыполнитьПроверкиНаСервере(Проверки);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ВыполнитьПроверкуЗавершение", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется проверка. Это может занять некоторое время.'");
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		Оповестить("КонтрольВеденияУчета_УспешнаяПроверка");
		ПоказатьОповещениеПользователя(НСтр("ru = 'Проверка выполнена'"),
			"e1cib/data/Отчет.РезультатыПроверкиУчета",
			НСтр("ru = 'Проверка ведения учета завершена успешно.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьПоНачальномуЗаполнениюНаСервере()
	
	КонтрольВеденияУчетаСлужебный.ОбновитьПараметрыПроверокУчета();
	Если КонтрольВеденияУчетаСлужебный.ЕстьИзмененияПараметровПроверокУчета() Тогда
		КонтрольВеденияУчетаСлужебный.ОбновитьВспомогательныеДанныеПоИзменениямКонфигурации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВыделенныеПроверки(ЕстьГруппы)
	
	Результат = Новый Массив;
	Для Каждого Проверка Из Элементы.Список.ВыделенныеСтроки Цикл
		ДанныеПроверки = Элементы.Список.ДанныеСтроки(Проверка);
		Если ДанныеПроверки <> Неопределено Тогда
			Результат.Добавить(ДанныеПроверки.Ссылка);
			Если ДанныеПроверки.ЭтоГруппа Тогда
				ЕстьГруппы = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеВыделенныеПроверки(Проверки = Неопределено)
	
	Если Проверки = Неопределено Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПравилаПроверкиУчета.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ПравилаПроверкиУчета КАК ПравилаПроверкиУчета
			|ГДЕ
			|	НЕ ПравилаПроверкиУчета.ЭтоГруппа");
	Иначе	
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПравилаПроверкиУчета.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ПравилаПроверкиУчета КАК ПравилаПроверкиУчета
			|ГДЕ
			|	ПравилаПроверкиУчета.Ссылка В ИЕРАРХИИ(&Проверки)
			|	И НЕ ПравилаПроверкиУчета.ЭтоГруппа");
		
		Запрос.УстановитьПараметр("Проверки", Проверки);
	КонецЕсли;	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Функция СформироватьСтрокуСРасписанием()
	
	ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
	Если ОбщееРегламентноеЗадание <> Неопределено Тогда
		Если Не ОбщегоНазначения.РазделениеВключено() Тогда
			ОбщееРасписание              = ОбщееРегламентноеЗадание.Расписание;
			ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Расписание);
		Иначе
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
				ОбщееРасписание              = ОбщееРегламентноеЗадание.Шаблон.Расписание.Получить();
				ОбщееРасписаниеПредставление = Строка(ОбщееРасписание);
			Иначе
				ОбщееРасписание = Неопределено;
				ОбщееРасписаниеПредставление = НСтр("ru = 'Просмотр расписания недоступен'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОбщееРасписание              = Неопределено;
		ОбщееРасписаниеПредставление = НСтр("ru = 'Регламентное задание недоступно'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		ТекстоваяСсылка = ПоместитьВоВременноеХранилище(ОбщееРасписание, УникальныйИдентификатор);
	
		Возврат Новый ФорматированнаяСтрока(НСтр("ru = 'Общее расписание выполнения проверок:'") + " ",
			Новый ФорматированнаяСтрока(ОбщееРасписаниеПредставление, , , , ТекстоваяСсылка));
			
	Иначе
			
		Возврат Новый ФорматированнаяСтрока(НСтр("ru = 'Общее расписание выполнения проверок:'") + " ",
			Новый ФорматированнаяСтрока(ОбщееРасписаниеПредставление, , ЦветаСтиля.ГиперссылкаЦвет));
			
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПредставлениеОбщегоРасписанияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог     = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьИзВременногоХранилища(НавигационнаяСсылкаФорматированнойСтроки));
	Оповещение = Новый ОписаниеОповещения("ПредставлениеОбщегоРасписанияНажатиеНаКлиентеЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОбщегоРасписанияНажатиеНаКлиентеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	ПредставлениеОбщегоРасписанияНажатиеНаСервереЗавершение(Расписание, ДополнительныеПараметры);
КонецПроцедуры

&НаСервере
Процедура ПредставлениеОбщегоРасписанияНажатиеНаСервереЗавершение(Расписание, ДополнительныеПараметры)
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторОбщегоЗадания = РегламентныеЗаданияСервер.УникальныйИдентификатор(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
	РегламентныеЗаданияСервер.ИзменитьЗадание(ИдентификаторОбщегоЗадания, Новый Структура("Расписание", Расписание));
	
	Элементы.ПредставлениеОбщегоРасписания.Заголовок = СформироватьСтрокуСРасписанием();
	
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПредставлениеОбщегоРасписания", Строка(Расписание));
	Элементы.Список.Обновить();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
