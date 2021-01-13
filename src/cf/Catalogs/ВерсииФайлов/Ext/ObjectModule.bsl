﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка
		Или ДополнительныеСвойства.Свойство("УдалениеДанных")
		Или ДополнительныеСвойства.Свойство("КонвертацияФайлов")
		Или ДополнительныеСвойства.Свойство("РазмещениеФайловВТомах") Тогда
		
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		РодительскаяВерсия = Владелец.ТекущаяВерсия;
	КонецЕсли;
	
	// Выполним установку индекса пиктограммы при записи объекта.
	ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
	
	Если СтатусИзвлеченияТекста.Пустая() Тогда
		СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
	КонецЕсли;
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Файлы") Тогда
		Наименование = СокрЛП(ПолноеНаименование);
	КонецЕсли;
	
	Если Владелец.ТекущаяВерсия = Ссылка Тогда
		Если ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
			ВызватьИсключение НСтр("ru = 'Активную версию нельзя удалить.'");
		КонецЕсли;
	ИначеЕсли РодительскаяВерсия.Пустая() Тогда
		Если ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
			ВызватьИсключение НСтр("ru = 'Первую версию нельзя удалить.'");
		КонецЕсли;
	ИначеЕсли ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
		// Очищаем у версий, дочерних к помеченной, ссылку на родительскую - 
		// переставляем на родительскую версию удаляемой версии.
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВерсииФайлов.Ссылка КАК Ссылка
			|ИЗ
			|	&ИмяСправочникаВерсииФайлов КАК ВерсииФайлов
			|ГДЕ
			|	ВерсииФайлов.РодительскаяВерсия = &РодительскаяВерсия";
		
		ИмяСправочникаВерсииФайлов = "Справочник." + Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Имя;
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИмяСправочникаВерсииФайлов", ИмяСправочникаВерсииФайлов);
		Запрос.УстановитьПараметр("РодительскаяВерсия", Ссылка);
		
		Результат = Запрос.Выполнить();
		НачатьТранзакцию();
		Попытка
			Если Не Результат.Пустой() Тогда
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				
				БлокировкаДанных = Новый БлокировкаДанных;
				ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(Выборка.Ссылка)).ПолноеИмя());
				ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Выборка.Ссылка);
				БлокировкаДанных.Заблокировать();
				
				Объект = Выборка.Ссылка.ПолучитьОбъект();
				
				ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
				Объект.РодительскаяВерсия = РодительскаяВерсия;
				Объект.Записать();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
		
		СвойстваФайла = РаботаСФайламиВТомахСлужебный.СвойстваФайлаВТоме();
		ЗаполнитьЗначенияСвойств(СвойстваФайла, ЭтотОбъект);
		
		РаботаСФайламиВТомахСлужебный.УдалитьФайл(
			РаботаСФайламиВТомахСлужебный.ПолноеИмяФайлаВТоме(СвойстваФайла));
		
	КонецЕсли;
	
	// Проверку ОбменДанными.Загрузка следует выполнять начиная с этой строки.
	// Сначала требуется физически удалить файл, а потом уже сведения о нем в информационной базе.
	// Иначе данные о расположении файла будут недоступны.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли