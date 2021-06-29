﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Начинает замер времени ключевой операции.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
// Поскольку клиентские замеры хранятся в клиентском буфере и записываются с периодичностью,
// указанной в константе ОценкаПроизводительностиПериодЗаписи (по умолчанию, каждую минуту),
// в случае завершения сеанса часть замеров может быть потеряна.
//
// Параметры:
//  КлючеваяОперация - Строка - 	имя ключевой операции. Если Неопределено, то ключевую операцию
//									необходимо указать явно вызовом процедуры
//									УстановитьКлючевуюОперациюЗамера.
//  ФиксироватьСОшибкой - Булево -	признак автоматической фиксации ошибки. 
//									Истина - при автоматическом завершении замера, он будет записан
//									с признаком "Выполнен с ошибкой". В том месте кода, где ошибка явно
//									не может возникнуть, необходимо либо явно завершить замер методом
//									ЗавершитьЗамерВремени, либо снять признак ошибки с помощью метода
//									УстановитьПризнакОшибкиЗамера.
//									Ложь - замер будет считаться корректным при автоматическом завершении.
//  АвтоЗавершение - Булево	 - 		признак автоматического завершения замера.
//									Истина - завершение замера будет выполнено автоматически
//									через глобальный обработчик ожидания.
//									Ложь - завершить замер необходимо явно вызовом процедуры
//									ЗавершитьЗамерВремени.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция ЗамерВремени(КлючеваяОперация = Неопределено, ФиксироватьСОшибкой = Ложь, АвтоЗавершение = Истина) Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("ВыполненаСОшибкой", ФиксироватьСОшибкой);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

// Начинает технологический замер времени ключевой операции.
// Результат замера будет записан в РегистрСведений.ЗамерыВремени.
//
// Параметры:
//  АвтоЗавершение - Булево	 - 	признак автоматического завершения замера.
//								Истина - завершение замера будет выполнено автоматически
//								через глобальный обработчик ожидания.
//								Ложь - завершить замер необходимо явно вызовом процедуры
//								ЗавершитьЗамерВремени.
//  КлючеваяОперация - Строка - имя ключевой операции. Если Неопределено> то ключевую операцию
//								необходимо указать явно вызовом процедуры
//								УстановитьКлючевуюОперациюЗамера.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция НачатьЗамерВремениТехнологический(АвтоЗавершение = Истина, КлючеваяОперация = Неопределено) Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("Технологический", Истина);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
		
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

// Завершает замер времени на клиенте.
//
// Параметры:
//  УИДЗамера - УникальныйИдентификатор - уникальный идентификатор замера.
//  ВыполненСОшибкой - Булево - признак того, что замер не был выполнен до конца,
//  							а выполнение ключевой операции завершилось с ошибкой.
//
Процедура ЗавершитьЗамерВремени(УИДЗамера, ВыполненСОшибкой = Ложь) Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ЗавершитьЗамерВремениСлужебный(УИДЗамера, ВремяОкончания);
		
		ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
		Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
			Замеры = ОценкаПроизводительностиЗамерВремени["Замеры"];
			Замер = Замеры[УИДЗамера];
			Если Замер <> Неопределено Тогда
				Замер["ВыполненаСОшибкой"] = ВыполненСОшибкой;
				ЗамерыЗавершенные = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["ЗамерыЗавершенные"];
				ЗамерыЗавершенные.Вставить(УИДЗамера, Замер);
				Замеры.Удалить(УИДЗамера);
			КонецЕсли;
		КонецЕсли;   
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает параметры замера.
//
// Параметры:
//  УИДЗамера	- УникальныйИдентификатор - уникальный идентификатор замера.
//  ПараметрыЗамера	- Структура:
//    * КлючеваяОперация 	- Строка					- имя ключевой операции.
//    * ВесЗамера			- Число						- количественный показатель сложности замера
//    * Комментарий		- Строка
//		             		- Соответствие - дополнительная произвольной информации замера.
//    * ВыполненаСОшибкой - Булево					- признак выполнения замера с ошибкой,
//														  см. процедуру УстановитьПризнакОшибкиЗамера.
//
Процедура УстановитьПараметрыЗамера(УИДЗамера, ПараметрыЗамера) Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];
		Для Каждого Параметр Из ПараметрыЗамера Цикл
			Замеры[УИДЗамера][Параметр.Ключ] = Параметр.Значение;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает ключевую операцию замера.
//
// Параметры:
//  УИДЗамера 			- УникальныйИдентификатор - уникальный идентификатор замера.
//  КлючеваяОперация	- Строка - наименование ключевой операции.
//
// Если на момент начала замера имя ключевой операции еще неизвестно,
// то с помощью этой процедуры в любой момент до завершения замера можно
// доопределить имя ключевой операции.
// Например, при проведении документа, т.к. в момент начала проведения
// мы не можем гарантировать, что проведение документа завершиться и не будет отказа.
// 
// &НаКлиенте
// Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
//	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
//		ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
//	КонецЕсли;
// КонецПроцедуры
//
// &НаКлиенте
// Процедура ПослеЗаписи(ПараметрыЗаписи)
//	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
//		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, "_ДемоПроведениеДокумента");
//	КонецЕсли;
// КонецПроцедуры
//
Процедура УстановитьКлючевуюОперациюЗамера(УИДЗамера, КлючеваяОперация) Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["КлючеваяОперация"] = КлючеваяОперация;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает вес операции замера.
//
// Параметры:
//  УИДЗамера - УникальныйИдентификатор - уникальный идентификатор замера.
//  ВесЗамера - Число					- количественный показатель сложности
//										  замера, например количество строк в документе.
//
Процедура УстановитьВесЗамера(УИДЗамера, ВесЗамера) Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["ВесЗамера"] = ВесЗамера;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает комментарий операции замера.
//
// Параметры:
//  УИДЗамера   - УникальныйИдентификатор - уникальный идентификатор замера.
//  Комментарий - Строка
//              - Соответствие из КлючИЗначение - дополнительная произвольной информации замера.
//                               В случае указания соответствия:
//                                            * Ключ     - Строка - имя дополнительного параметра информации замера.
//                                            * Значение - Строка
//                                                       - Число
//                                                       - Булево - значение дополнительного параметра замера.
//
Процедура УстановитьКомментарийЗамера(УИДЗамера, Комментарий) Экспорт
		
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["Комментарий"] = Комментарий;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак ошибки операции замера.
//
// Параметры:
//  УИДЗамера	- УникальныйИдентификатор	- уникальный идентификатор замера.
//  Признак		- Булево					- признак замера. Истина - замер выполнился без ошибок.
//											  Ложь - при выполнении замера есть ошибка.
//
Процедура УстановитьПризнакОшибкиЗамера(УИДЗамера, Признак) Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["ВыполненаСОшибкой"] = Признак;
	КонецЕсли;
	
КонецПроцедуры

// Начинает замер времени выполнения длительной ключевой операции. Закончить замер нужно явно вызовом
// процедуры ЗакончитьЗамерДлительнойОперации.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
//
// Параметры:
//  КлючеваяОперация - Строка - имя ключевой операции. 
//  ФиксироватьСОшибкой - Булево -	признак автоматической фиксации ошибки. 
//									Истина - при автоматическом завершении замера, он будет записан
//									с признаком "Выполнен с ошибкой". В том месте кода, где ошибка явно
//									не может возникнуть, необходимо либо явно завершить замер методом
//									ЗавершитьЗамерВремени, либо снять признак ошибки с помощью метода
//									УстановитьПризнакОшибкиЗамера
//									Ложь - замер будет считаться корректны при автоматическом завершении.
//									ЗавершитьЗамерВремени.
//  АвтоЗавершение - Булево	 - 		признак автоматического завершения замера.
//									Истина - завершение замера будет выполнено автоматически
//									через глобальный обработчик ожидания.
//									Ложь - завершить замер необходимо явно вызовом процедуры
//									ЗавершитьЗамерВремени.
//  ИмяПоследнегоШага - Строка - 	имя последнего шага ключевой операции. Целесообразно использовать, если
//									замер запущен с автоматическим завершением. В противным случае последние 
//									действия, выполненные между ЗафиксироватьЗамерДлительнойОперации и 
//									срабатыванием обработчика ожидания будет записано под именем "Последний шаг".
//
// Возвращаемое значение:
//   Соответствие:
//   * КлючеваяОперация - Строка -  имя ключевой операции.
//   * ВремяНачала - Число - время начала ключевой операции в миллисекундах.
//   * ВремяПоследнегоЗамера - Число - время последнего замера ключевой операции в миллисекундах.
//   * ВесЗамера - Число - количество данных, обработанных в ходе выполнения действий.
//   * ВложенныеЗамеры - Соответствие - коллекция замеров вложенных шагов.
//
Функция НачатьЗамерДлительнойОперации(КлючеваяОперация, ФиксироватьСОшибкой = Ложь, АвтоЗавершение = Ложь, ИмяПоследнегоШага = "ПоследнийШаг") Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Замер = Новый Соответствие;
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("ВыполненаСОшибкой", ФиксироватьСОшибкой);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
		
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];
		Замер = Замеры[УИДЗамера]; 		
		Замер.Вставить("ВремяПоследнегоЗамера", Замер["ВремяНачала"]);
		Замер.Вставить("УдельноеВремя", 0.0);
		Замер.Вставить("ВесЗамера", 0);
		Замер.Вставить("ВложенныеЗамеры", Новый Соответствие);
		Замер.Вставить("УИДЗамера", УИДЗамера);
		Замер.Вставить("Клиентский", Истина);
		Замер.Вставить("ИмяПоследнегоШага", ИмяПоследнегоШага);
		
	КонецЕсли;
		
	Возврат Замер;
	
КонецФункции

// Фиксирует замер вложенного шага длительной операции.
// Параметры:
//  ОписаниеЗамера 		- Соответствие	 - должно быть получено вызовом метода НачатьЗамерДлительнойОперации.
//  КоличествоДанных 	- Число			 - количество данных, например, строк, обработанных в ходе выполнения вложенного шага.
//  ИмяШага 			- Строка		 - произвольное имя вложенного шага.
//  Комментарий 		- Строка		 - произвольное дополнительное описание замера.
//
Процедура ЗафиксироватьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных, ИмяШага, Комментарий = "") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ОписаниеЗамера) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееВремя = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КоличествоДанныхШага = ?(КоличествоДанных = 0, 1, КоличествоДанных);
	
	Длительность = ТекущееВремя - ОписаниеЗамера["ВремяПоследнегоЗамера"];
	// Если вложенный замер выполняется первый раз, то инициализируем его.
	ВложенныеЗамеры = ОписаниеЗамера["ВложенныеЗамеры"];
	Если ВложенныеЗамеры[ИмяШага] = Неопределено Тогда
		ВложенныеЗамеры.Вставить(ИмяШага, Новый Соответствие);
		ШагВложенногоЗамера = ВложенныеЗамеры[ИмяШага];
		ШагВложенногоЗамера.Вставить("Комментарий", Комментарий);
		ШагВложенногоЗамера.Вставить("ВремяНачала", ОписаниеЗамера["ВремяПоследнегоЗамера"]);
		ШагВложенногоЗамера.Вставить("Длительность", 0.0);	
		ШагВложенногоЗамера.Вставить("ВесЗамера", 0);
	КонецЕсли;                                                            
	// Пишем данные вложенного замера.
	ШагВложенногоЗамера = ВложенныеЗамеры[ИмяШага];
	ШагВложенногоЗамера.Вставить("ВремяОкончания", ТекущееВремя);
	ШагВложенногоЗамера.Вставить("Длительность", Длительность + ШагВложенногоЗамера["Длительность"]);
	ШагВложенногоЗамера.Вставить("ВесЗамера", КоличествоДанныхШага + ШагВложенногоЗамера["ВесЗамера"]);
	
	// Пишем данные длительного замера
	ОписаниеЗамера.Вставить("ВремяПоследнегоЗамера", ТекущееВремя);
	ОписаниеЗамера.Вставить("ВесЗамера", КоличествоДанныхШага + ОписаниеЗамера["ВесЗамера"]);
	
КонецПроцедуры

// Завершает замер длительной операции.
// Если указано имя шага, фиксирует его как отдельный вложенный шаг
// Параметры:
//  ОписаниеЗамера 		- Соответствие	 - должно быть получено вызовом метода НачатьЗамерДлительнойОперации.
//  КоличествоДанных 	- Число			 - количество данных, например, строк, обработанных в ходе выполнения вложенного шага.
//  ИмяШага 			- Строка		 - произвольное имя вложенного шага.
//  Комментарий 		- Строка		 - произвольное дополнительное описание замера.
//
Процедура ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных, ИмяШага = "", Комментарий = "") Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		
		Если ОписаниеЗамера["ВложенныеЗамеры"].Количество() Тогда
			КоличествоДанныхШага = ?(КоличествоДанных = 0, 1, КоличествоДанных);
			ЗафиксироватьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанныхШага, ?(ПустаяСтрока(ИмяШага), "ПоследнийШаг", ИмяШага), Комментарий);
		КонецЕсли;
		
		УИДЗамера = ОписаниеЗамера["УИДЗамера"];
		ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ЗавершитьЗамерВремениСлужебный(УИДЗамера, ВремяОкончания);
		
		Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
		Замер = Замеры[УИДЗамера];
		
		Если Замер <> Неопределено Тогда
			ЗамерыЗавершенные = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["ЗамерыЗавершенные"];
			ОписаниеЗамера.Вставить("ВремяОкончания", Замер["ВремяОкончания"]);
			ЗамерыЗавершенные.Вставить(УИДЗамера, ОписаниеЗамера);
			Замеры.Удалить(УИДЗамера);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Будет удалена в следующей редакции библиотеки.
// Необходимо использовать процедуру
//		ОценкаПроизводительностиКлиент.ЗамерВремени
// Начинает замер времени ключевой операции.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
// Поскольку клиентские замеры хранятся в клиентском буфере и записываются с периодичностью,
// указанной в константе ОценкаПроизводительностиПериодЗаписи (по умолчанию, каждую минуту),
// в случае завершения сеанса часть замеров может быть потеряна.
//
// Параметры:
//  АвтоЗавершение - Булево	 - 	признак автоматического завершения замера.
//								Истина - завершение замера будет выполнено автоматически
//								через глобальный обработчик ожидания.
//								Ложь - завершить замер необходимо явно вызовом процедуры
//								ЗавершитьЗамерВремени.
//  КлючеваяОперация - Строка - имя ключевой операции. Если Неопределено> то ключевую операцию
//								необходимо указать явно вызовом процедуры
//								УстановитьКлючевуюОперациюЗамера.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция НачатьЗамерВремени(АвтоЗавершение = Истина, КлючеваяОперация = Неопределено) Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

#КонецОбласти
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительности.ВремяНачалаЗапуска";
	ВремяНачала = ПараметрыПриложения[ИмяПараметра];
	ПараметрыПриложения.Удалить(ИмяПараметра);
	
	НачатьЗамерВремениСоСмещением(ВремяНачала, Истина, "ОбщееВремяЗапускаПриложения");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Начинает замер времени ключевой операции.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
//
// Параметры:
//  Смещение - Число	 	 - 	дата и время начала замера в миллисекундах (см. ТекущаяУниверсальнаяДатаВМиллисекундах).
//  АвтоЗавершение - Булево	 - 	признак автоматического завершения замера.
//								Истина - завершение замера будет выполнено автоматически
//								через глобальный обработчик ожидания.
//								Ложь - завершить замер необходимо явно вызовом процедуры
//								ЗавершитьЗамерВремени.
//  КлючеваяОперация - Строка - имя ключевой операции. Если Неопределено> то ключевую операцию
//								необходимо указать явно вызовом процедуры
//								УстановитьКлючевуюОперациюЗамера.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция НачатьЗамерВремениСоСмещением(Смещение, АвтоЗавершение = Истина, КлючеваяОперация = Неопределено)
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
		Параметры.Вставить("Смещение", Смещение);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

Функция ВыполнятьЗамерыПроизводительности()
	
	ВыполнятьЗамерыПроизводительности = Ложь;
	
	ИмяПараметраСтандартныеПодсистемы = "СтандартныеПодсистемы.ПараметрыКлиента";
	
	Если ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы] = Неопределено Тогда
		ВыполнятьЗамерыПроизводительности = ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности();
	Иначе
		Если ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы].Свойство("ОценкаПроизводительности") Тогда
			ВыполнятьЗамерыПроизводительности = ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы]["ОценкаПроизводительности"]["ВыполнятьЗамерыПроизводительности"];
		Иначе
			ВыполнятьЗамерыПроизводительности = ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВыполнятьЗамерыПроизводительности; 
	
КонецФункции

Процедура НачатьЗамерВремениНаКлиентеСлужебный(Параметры)
    
    ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
    
	Если ПараметрыПриложения = Неопределено Тогда
		ПараметрыПриложения = Новый Соответствие;
	КонецЕсли;
		
	ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
		ПараметрыПриложения[ИмяПараметра].Вставить("Замеры", Новый Соответствие);
		ПараметрыПриложения[ИмяПараметра].Вставить("ЗамерыЗавершенные", Новый Соответствие);
		ПараметрыПриложения[ИмяПараметра].Вставить("ЕстьОбработчик", Ложь);
		ПараметрыПриложения[ИмяПараметра].Вставить("ВремяПодключенияОбработчика", ВремяНачала);
		
		ИмяПараметраСтандартныеПодсистемы = "СтандартныеПодсистемы.ПараметрыКлиента";
		Если ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы] = Неопределено Тогда
			ПараметрыОценкиПроизводительности = ОценкаПроизводительностиВызовСервера.ПолучитьПараметрыНаСервере();
			ТекущийПериодЗаписи = ПараметрыОценкиПроизводительности.ПериодЗаписи;
			ДатаИВремяНаСервере = ПараметрыОценкиПроизводительности.ДатаИВремяНаСервере;
		
			// Получаем дату в UTC
			ДатаИВремяНаКлиенте = ТекущаяУниверсальнаяДатаВМиллисекундах();
			ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
		Иначе
			ПараметрыПриложенияСтандартныеПодсистемы = ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы];
			Если ПараметрыПриложенияСтандартныеПодсистемы.Свойство("ОценкаПроизводительности") Тогда
				ТекущийПериодЗаписи = ПараметрыПриложенияСтандартныеПодсистемы["ОценкаПроизводительности"]["ПериодЗаписи"];
				ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ПараметрыПриложенияСтандартныеПодсистемы["СмещениеДатыКлиента"]);
			Иначе
				ПараметрыОценкиПроизводительности = ОценкаПроизводительностиВызовСервера.ПолучитьПараметрыНаСервере();
				ТекущийПериодЗаписи = ПараметрыОценкиПроизводительности.ПериодЗаписи;
				ДатаИВремяНаСервере = ПараметрыОценкиПроизводительности.ДатаИВремяНаСервере;
				
				// Получаем дату в UTC
				ДатаИВремяНаКлиенте = ТекущаяУниверсальнаяДатаВМиллисекундах();
				ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
			КонецЕсли;
		КонецЕсли;
				
		ИнформацияПрограммыПросмотра = "";
		#Если ТолстыйКлиентУправляемоеПриложение Тогда
			ИнформацияПрограммыПросмотра = "ТолстыйКлиентУправляемоеПриложение";
		#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
			ИнформацияПрограммыПросмотра = "ТолстыйКлиент";
		#ИначеЕсли ТонкийКлиент Тогда
			ИнформацияПрограммыПросмотра = "ТонкийКлиент";
		#ИначеЕсли ВебКлиент Тогда
			ИнфоКлиента = Новый СистемнаяИнформация();
			ИнформацияПрограммыПросмотра = ИнфоКлиента.ИнформацияПрограммыПросмотра;
		#КонецЕсли
		ПараметрыПриложения[ИмяПараметра].Вставить("ИнформацияПрограммыПросмотра", ИнформацияПрограммыПросмотра);
						
		ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", ТекущийПериодЗаписи, Истина);
	КонецЕсли;
	
	// Фактическое начало замера времени на клиенте.
	// Выше поднять нельзя, т.к. при замере времени открытия приложения ПараметрыПриложения
	// еще не инициализированы.
	//
	
	Если Параметры.Свойство("Смещение") Тогда
		ВремяНачала = Параметры.Смещение + ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];;
	Иначе
		ВремяНачала = ВремяНачала + ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];
	КонецЕсли;
		
	КлючеваяОперация = Параметры.КлючеваяОперация;
	УИДЗамера = Параметры.УИДЗамера;
	АвтоЗавершение = Параметры.АвтоЗавершение;
	
	Если Параметры.Свойство("Комментарий") Тогда
		Комментарий = Параметры.Комментарий;
	Иначе
		Комментарий = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("Технологический") Тогда
		Технологический = Параметры.Технологический;
	Иначе
		Технологический = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ВыполненаСОшибкой") Тогда
		ВыполненаСОшибкой = Параметры.ВыполненаСОшибкой;
	Иначе
		ВыполненаСОшибкой = Ложь;
	КонецЕсли;
	
	Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"]; 
	Замеры.Вставить(УИДЗамера, Новый Соответствие);
	Замер = Замеры[УИДЗамера];
	Замер.Вставить("КлючеваяОперация", КлючеваяОперация);
	Замер.Вставить("АвтоЗавершение", АвтоЗавершение);
	Замер.Вставить("ВремяНачала", ВремяНачала);
	Замер.Вставить("Комментарий", Комментарий);
	Замер.Вставить("ВыполненаСОшибкой", ВыполненаСОшибкой);
	Замер.Вставить("Технологический", Технологический);
	Замер.Вставить("ВесЗамера", 1);
	
	Если АвтоЗавершение Тогда
		Если НЕ ПараметрыПриложения[ИмяПараметра]["ЕстьОбработчик"] Тогда
			ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
			ПараметрыПриложения[ИмяПараметра]["ЕстьОбработчик"] = Истина;
			ПараметрыПриложения[ИмяПараметра]["ВремяПодключенияОбработчика"] = ТекущаяУниверсальнаяДатаВМиллисекундах() + ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

// Автоматически завершает замер времени на клиенте.
//
Процедура ЗавершитьЗамерВремениНаКлиентеАвто() Экспорт
	
	ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
	ВремяПодключенияОбработчика = ОценкаПроизводительностиЗамерВремени["ВремяПодключенияОбработчика"];
		
    Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
        
        Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
		ЗамерыЗавершенные = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["ЗамерыЗавершенные"];
		
		ДляУдаления = Новый Массив;
        
        КоличествоНеЗавершенныхАвтоЗамеров = 0;
		Для Каждого Замер Из Замеры Цикл
			ЗамерЗначение = Замер.Значение;
            Если ЗамерЗначение["АвтоЗавершение"] Тогда 
				Если ЗамерЗначение["ВремяНачала"] <= ВремяПодключенияОбработчика И ЗамерЗначение["ВремяОкончания"] = Неопределено Тогда
					// Если есть вложенные замеры, зафиксируем последний шаг.
					Если ЗамерЗначение["ВложенныеЗамеры"] <> Неопределено
						И ЗамерЗначение["ВложенныеЗамеры"].Количество() Тогда
						ЗафиксироватьЗамерДлительнойОперации(ЗамерЗначение, 1, ЗамерЗначение["ИмяПоследнегоШага"]);
					КонецЕсли;
					
                    // Смещение даты клиента рассчитывается внутри процедуры
                    ЗавершитьЗамерВремениСлужебный(Замер.Ключ, ВремяОкончания);
                    Если ЗначениеЗаполнено(Замер.Значение["КлючеваяОперация"]) Тогда
                        ЗамерыЗавершенные.Вставить(Замер.Ключ, Замер.Значение);
                    КонецЕсли;
                    ДляУдаления.Добавить(Замер.Ключ);
                Иначе
                    КоличествоНеЗавершенныхАвтоЗамеров = КоличествоНеЗавершенныхАвтоЗамеров + 1;
                КонецЕсли;
            КонецЕсли;
		КонецЦикла;
		
		Для Каждого ТекЗамер Из ДляУдаления Цикл
			Замеры.Удалить(ТекЗамер);
		КонецЦикла;
	КонецЕсли;
	
	Если КоличествоНеЗавершенныхАвтоЗамеров = 0 Тогда
		ОценкаПроизводительностиЗамерВремени["ЕстьОбработчик"] = Ложь;
	Иначе
		ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
		ОценкаПроизводительностиЗамерВремени["ЕстьОбработчик"] = Истина;
		ОценкаПроизводительностиЗамерВремени["ВремяПодключенияОбработчика"] = ТекущаяУниверсальнаяДатаВМиллисекундах() + ОценкаПроизводительностиЗамерВремени["СмещениеДатыКлиента"];
	КонецЕсли;
КонецПроцедуры

Процедура ЗавершитьЗамерВремениСлужебный(УИДЗамера, Знач ВремяОкончания)
		
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
		Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
			СмещениеДатыКлиента = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["СмещениеДатыКлиента"];
			ВремяОкончания = ВремяОкончания + СмещениеДатыКлиента;
			
			Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
			Замер = Замеры[УИДЗамера];
			Если Замер <> Неопределено Тогда
				Замер.Вставить("ВремяОкончания", ВремяОкончания);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Произвести запись накопленных замеров времени выполнения ключевых операций на сервере.
//
// Параметры:
//  ПередЗавершением - Булево - Истина, если метод вызывается перед закрытием приложения.
//
Процедура ЗаписатьРезультатыАвтоНеГлобальный(ПередЗавершением = Ложь) Экспорт
	
	ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
	
	Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
		ЗамерыЗавершенные = ОценкаПроизводительностиЗамерВремени["ЗамерыЗавершенные"];
		ОценкаПроизводительностиЗамерВремени["ЗамерыЗавершенные"] = Новый Соответствие;
		
		ЗамерыДляЗаписи = Новый Структура;
		ЗамерыДляЗаписи.Вставить("ЗамерыЗавершенные", ЗамерыЗавершенные);
		ЗамерыДляЗаписи.Вставить("ИнформацияПрограммыПросмотра", ОценкаПроизводительностиЗамерВремени["ИнформацияПрограммыПросмотра"]);
		НовыйПериодЗаписи = ОценкаПроизводительностиВызовСервера.ЗафиксироватьДлительностьКлючевыхОпераций(ЗамерыДляЗаписи);
				
		ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", НовыйПериодЗаписи, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти