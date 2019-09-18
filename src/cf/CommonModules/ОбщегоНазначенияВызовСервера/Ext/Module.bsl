﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДанныеВБазе

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции для работы с данными в базе.

// Проверяет наличие ссылок на объект в базе данных.
// При вызове в неразделенном сеансе не выявляет ссылок в разделенных областях.
//
// См. ОбщегоНазначения.ЕстьСсылкиНаОбъект
//
// Параметры:
//  СсылкаИлиМассивСсылок - ЛюбаяСсылка, Массив - объект или список объектов.
//  ИскатьСредиСлужебныхОбъектов - Булево - если Истина, то не будут учитываться
//      исключения поиска ссылок, заданные при разработке конфигурации.
//      Про исключение поиска ссылок подробнее
//      см. ОбщегоНазначенияПереопределяемый.ПриДобавленииИсключенийПоискаСсылок
//
// Возвращаемое значение:
//  Булево - Истина, если есть ссылки на объект.
//
Функция ЕстьСсылкиНаОбъект(Знач СсылкаИлиМассивСсылок, Знач ИскатьСредиСлужебныхОбъектов = Ложь) Экспорт
	
	Возврат ОбщегоНазначения.ЕстьСсылкиНаОбъект(СсылкаИлиМассивСсылок, ИскатьСредиСлужебныхОбъектов);
	
КонецФункции

// Проверяет статус проведения переданных документов и возвращает
// те из них, которые не проведены.
//
// См. ОбщегоНазначения.ПроверитьПроведенностьДокументов
//
// Параметры:
//  Документы - Массив - документы, статус проведения которых необходимо проверить.
//
// Возвращаемое значение:
//  Массив - непроведенные документы.
//
Функция ПроверитьПроведенностьДокументов(Знач Документы) Экспорт
	
	Возврат ОбщегоНазначения.ПроверитьПроведенностьДокументов(Документы);
	
КонецФункции

// Выполняет попытку проведения документов.
//
// См. ОбщегоНазначения.ПровестиДокументы
//
// Параметры:
//   Документы - Массив - документы, которые необходимо провести.
//
// Возвращаемое значение:
//   Массив - массив структур со свойствами:
//      * Ссылка         - ДокументСсылка - документ, который не удалось провести.
//      * ОписаниеОшибки - Строка         - текст описания ошибки при проведении.
//
Функция ПровестиДокументы(Документы) Экспорт
	
	Возврат ОбщегоНазначения.ПровестиДокументы(Документы);
	
КонецФункции 

#КонецОбласти

#Область ХранилищеНастроек

////////////////////////////////////////////////////////////////////////////////
// Сохранение, чтение и удаление настроек из хранилищ.

// Сохраняет настройку в хранилище общих настроек, как метод платформы Сохранить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеОбщихНастроекСохранить
//
// Параметры:
//   КлючОбъекта       - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек      - Строка           - см. синтакс-помощник платформы.
//   Настройки         - Произвольный     - см. синтакс-помощник платформы.
//   ОписаниеНастроек  - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя   - Строка           - см. синтакс-помощник платформы.
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		КлючОбъекта,
		КлючНастроек,
		Настройки,
		ОписаниеНастроек,
		ИмяПользователя,
		ОбновитьПовторноИспользуемыеЗначения);
		
КонецПроцедуры

// Сохраняет несколько настроек в хранилище общих настроек, как метод платформы Сохранить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив
// 
// Параметры:
//   НесколькоНастроек - Массив - со значениями:
//     * Значение - Структура - со свойствами:
//         * Объект    - Строка       - см. параметр КлючОбъекта  в синтакс-помощнике платформы.
//         * Настройка - Строка       - см. параметр КлючНастроек в синтакс-помощнике платформы.
//         * Значение  - Произвольный - см. параметр Настройки    в синтакс-помощнике платформы.
//
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеОбщихНастроекСохранитьМассив(НесколькоНастроек, ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(НесколькоНастроек, ОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// Загружает настройку из хранилища общих настроек, как метод платформы Загрузить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Кроме того, возвращает указанное значение по умолчанию, если настройки не найдены.
// Если нет права СохранениеДанныхПользователя, возвращается значение по умолчанию без ошибки.
//
// В возвращаемом значении очищаются ссылки на несуществующий объект в базе данных, а именно
// - возвращаемая ссылка заменяется на указанное значение по умолчанию;
// - из данных типа Массив ссылки удаляются;
// - у данных типа Структура и Соответствие ключ не меняется, а значение устанавливается Неопределено;
// - анализ значений в данных типа Массив, Структура, Соответствие выполняется рекурсивно.
//
// См. ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить
//
// Параметры:
//   КлючОбъекта          - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек         - Строка           - см. синтакс-помощник платформы.
//   ЗначениеПоУмолчанию  - Произвольный     - значение, которое возвращается, если настройки не найдены.
//                                             Если не указано, возвращается значение Неопределено.
//   ОписаниеНастроек     - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя      - Строка           - см. синтакс-помощник платформы.
//
// Возвращаемое значение: 
//   Произвольный - см. синтакс-помощник платформы.
//
Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		КлючОбъекта,
		КлючНастроек,
		ЗначениеПоУмолчанию,
		ОписаниеНастроек,
		ИмяПользователя);
		
КонецФункции

// Удаляет настройку из хранилища общих настроек, как метод платформы Удалить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, удаление пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеОбщихНастроекУдалить
//
// Параметры:
//   КлючОбъекта     - Строка, Неопределено - см. синтакс-помощник платформы.
//   КлючНастроек    - Строка, Неопределено - см. синтакс-помощник платформы.
//   ИмяПользователя - Строка, Неопределено - см. синтакс-помощник платформы.
//
Процедура ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

// Сохраняет настройку в хранилище системных настроек, как метод платформы Сохранить
// объекта СтандартноеХранилищеНастроекМенеджер, но с поддержкой длины ключа настроек
// более 128 символов путем хеширования части, которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить
//
// Параметры:
//   КлючОбъекта       - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек      - Строка           - см. синтакс-помощник платформы.
//   Настройки         - Произвольный     - см. синтакс-помощник платформы.
//   ОписаниеНастроек  - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя   - Строка           - см. синтакс-помощник платформы.
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеСистемныхНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(
		КлючОбъекта,
		КлючНастроек,
		Настройки,
		ОписаниеНастроек,
		ИмяПользователя,
		ОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// Загружает настройку из хранилища системных настроек, как метод платформы Загрузить,
// объекта СтандартноеХранилищеНастроекМенеджер, но с поддержкой длины ключа настроек
// более 128 символов путем хеширования части, которая превышает 96 символов.
// Кроме того, возвращает указанное значение по умолчанию, если настройки не найдены.
// Если нет права СохранениеДанныхПользователя, возвращается значение по умолчанию без ошибки.
//
// В возвращаемом значении очищаются ссылки на несуществующий объект в базе данных, а именно:
// - возвращаемая ссылка заменяется на указанное значение по умолчанию;
// - из данных типа Массив ссылки удаляются;
// - у данных типа Структура и Соответствие ключ не меняется, а значение устанавливается Неопределено;
// - анализ значений в данных типа Массив, Структура, Соответствие выполняется рекурсивно
//
// См. ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить
//
// Параметры:
//   КлючОбъекта          - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек         - Строка           - см. синтакс-помощник платформы.
//   ЗначениеПоУмолчанию  - Произвольный     - значение, которое возвращается, если настройки не найдены.
//                                             Если не указано, возвращается значение Неопределено.
//   ОписаниеНастроек     - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя      - Строка           - см. синтакс-помощник платформы.
//
// Возвращаемое значение: 
//   Произвольный - см. синтакс-помощник платформы.
//
Функция ХранилищеСистемныхНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(
		КлючОбъекта,
		КлючНастроек,
		ЗначениеПоУмолчанию,
		ОписаниеНастроек,
		ИмяПользователя);
	
КонецФункции

// Удаляет настройку из хранилища системных настроек, как метод платформы Удалить,
// объекта СтандартноеХранилищеНастроекМенеджер, но с поддержкой длины ключа настроек
// более 128 символов путем хеширования части, которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, удаление пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеСистемныхНастроекУдалить
//
// Параметры:
//   КлючОбъекта     - Строка, Неопределено - см. синтакс-помощник платформы.
//   КлючНастроек    - Строка, Неопределено - см. синтакс-помощник платформы.
//   ИмяПользователя - Строка, Неопределено - см. синтакс-помощник платформы.
//
Процедура ХранилищеСистемныхНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

// Сохраняет настройку в хранилище настроек данных форм, как метод платформы Сохранить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, сохранение пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить
//
// Параметры:
//   КлючОбъекта       - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек      - Строка           - см. синтакс-помощник платформы.
//   Настройки         - Произвольный     - см. синтакс-помощник платформы.
//   ОписаниеНастроек  - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя   - Строка           - см. синтакс-помощник платформы.
//   ОбновитьПовторноИспользуемыеЗначения - Булево - выполнить одноименный метод платформы.
//
Процедура ХранилищеНастроекДанныхФормСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		КлючОбъекта,
		КлючНастроек,
		Настройки,
		ОписаниеНастроек,
		ИмяПользователя,
		ОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// Загружает настройку из хранилища настроек данных форм, как метод платформы Загрузить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Кроме того, возвращает указанное значение по умолчанию, если настройки не найдены.
// Если нет права СохранениеДанныхПользователя, возвращается значение по умолчанию без ошибки.
//
// В возвращаемом значении очищаются ссылки на несуществующий объект в базе данных, а именно
// - возвращаемая ссылка заменяется на указанное значение по умолчанию;
// - из данных типа Массив ссылки удаляются;
// - у данных типа Структура и Соответствие ключ не меняется, а значение устанавливается Неопределено;
// - анализ значений в данных типа Массив, Структура, Соответствие выполняется рекурсивно.
//
// См. ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить
//
// Параметры:
//   КлючОбъекта          - Строка           - см. синтакс-помощник платформы.
//   КлючНастроек         - Строка           - см. синтакс-помощник платформы.
//   ЗначениеПоУмолчанию  - Произвольный     - значение, которое возвращается, если настройки не найдены.
//                                             Если не указано, возвращается значение Неопределено.
//   ОписаниеНастроек     - ОписаниеНастроек - см. синтакс-помощник платформы.
//   ИмяПользователя      - Строка           - см. синтакс-помощник платформы.
//
// Возвращаемое значение: 
//   Произвольный - см. синтакс-помощник платформы.
//
Функция ХранилищеНастроекДанныхФормЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
		КлючОбъекта,
		КлючНастроек,
		ЗначениеПоУмолчанию,
		ОписаниеНастроек,
		ИмяПользователя);
	
КонецФункции

// Удаляет настройку из хранилища настроек данных форм, как метод платформы Удалить,
// объектов СтандартноеХранилищеНастроекМенеджер или ХранилищеНастроекМенеджер.<Имя хранилища>,
// но с поддержкой длины ключа настроек более 128 символов путем хеширования части,
// которая превышает 96 символов.
// Если нет права СохранениеДанныхПользователя, удаление пропускается без ошибки.
//
// См. ОбщегоНазначения.ХранилищеНастроекДанныхФормУдалить
//
// Параметры:
//   КлючОбъекта     - Строка, Неопределено - см. синтакс-помощник платформы.
//   КлючНастроек    - Строка, Неопределено - см. синтакс-помощник платформы.
//   ИмяПользователя - Строка, Неопределено - см. синтакс-помощник платформы.
//
Процедура ХранилищеНастроекДанныхФормУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Стили

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с цветами стиля в клиентском коде.

// (См. ОбщегоНазначенияКлиент.ЦветСтиля)
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ЦветаСтиля[ИмяЦветаСтиля];
	
КонецФункции

// (См. ОбщегоНазначенияКлиент.ШрифтСтиля)
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ШрифтыСтиля[ИмяШрифтаСтиля];
	
КонецФункции

#КонецОбласти

#КонецОбласти
