#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Получает статистику сопоставления объектов для строк таблицы ИнформацияСтатистики.
//
// Параметры:
//      Отказ        - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
//      ИндексыСтрок - Массив - индексы строк таблицы ИнформацияСтатистики
//                              для которых необходимо получить информацию статистики сопоставления.
//                              Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ПолучитьСтатистикуСопоставленияОбъектовПоСтроке(Отказ, ИндексыСтрок = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИндексыСтрок = Неопределено Тогда
		
		ИндексыСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
			
			ИндексыСтрок.Добавить(ИнформацияСтатистики.Индекс(СтрокаТаблицы));
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Выполняем загрузку данных из сообщения обмена в кэш сразу для нескольких таблиц.
	ВыполнитьЗагрузкуДанныхИзСообщенияОбменаВКэш(Отказ, ИндексыСтрок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СопоставлениеОбъектовИнформационныхБаз = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	
	// Получаем информацию дайджеста сопоставления отдельно для каждой таблицы.
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		Если Не СтрокаТаблицы.СинхронизироватьПоИдентификатору Тогда
			Продолжить;
		КонецЕсли;
		
		// Инициализация свойств обработки.
		СопоставлениеОбъектовИнформационныхБаз.ИмяТаблицыПриемника            = СтрокаТаблицы.ИмяТаблицыПриемника;
		СопоставлениеОбъектовИнформационныхБаз.ИмяТипаОбъектаТаблицыИсточника = СтрокаТаблицы.ТипОбъектаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.УзелИнформационнойБазы         = УзелИнформационнойБазы;
		СопоставлениеОбъектовИнформационныхБаз.ИмяФайлаСообщенияОбмена        = ИмяФайлаСообщенияОбмена;
		
		СопоставлениеОбъектовИнформационныхБаз.ТипИсточникаСтрокой = СтрокаТаблицы.ТипИсточникаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.ТипПриемникаСтрокой = СтрокаТаблицы.ТипПриемникаСтрокой;
		
		// конструктор
		СопоставлениеОбъектовИнформационныхБаз.Конструктор();
		
		// Получаем информацию дайджеста сопоставления.
		СопоставлениеОбъектовИнформационныхБаз.ПолучитьИнформациюДайджестаСопоставленияОбъектов(Отказ);
		
		// Информация дайджеста сопоставления.
		СтрокаТаблицы.КоличествоОбъектовВИсточнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВИсточнике();
		СтрокаТаблицы.КоличествоОбъектовВПриемнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВПриемнике();
		СтрокаТаблицы.КоличествоОбъектовСопоставленных   = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовСопоставленных();
		СтрокаТаблицы.КоличествоОбъектовНесопоставленных = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовНесопоставленных();
		СтрокаТаблицы.ПроцентСопоставленияОбъектов       = СопоставлениеОбъектовИнформационныхБаз.ПроцентСопоставленияОбъектов();
		СтрокаТаблицы.ИндексКартинки                     = ОбменДаннымиСервер.ИндексКартинкиТаблицыИнформацииСтатистики(СтрокаТаблицы.КоличествоОбъектовНесопоставленных, СтрокаТаблицы.ДанныеУспешноЗагружены);
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет автоматическое сопоставление объектов информационных баз
//  с заданными значениями по умолчанию и получает статистику сопоставления объектов
//  после автоматического сопоставления.
//
// Параметры:
//      Отказ        - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
//      ИндексыСтрок - Массив - индексы строк таблицы ИнформацияСтатистики
//                              для которых необходимо выполнить автоматическое сопоставление и получить информацию
//                              статистики.
//                              Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ВыполнитьАвтоматическоеСопоставлениеПоУмолчаниюИПолучитьСтатистикуСопоставления(Отказ, ИндексыСтрок = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИндексыСтрок = Неопределено Тогда
		
		ИндексыСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
			
			ИндексыСтрок.Добавить(ИнформацияСтатистики.Индекс(СтрокаТаблицы));
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Выполняем загрузку данных из сообщения обмена в кэш сразу для нескольких таблиц.
	ВыполнитьЗагрузкуДанныхИзСообщенияОбменаВКэш(Отказ, ИндексыСтрок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СопоставлениеОбъектовИнформационныхБаз = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	
	// Выполняем автоматическое сопоставление
	// получаем информацию дайджеста сопоставления.
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		Если Не СтрокаТаблицы.СинхронизироватьПоИдентификатору Тогда
			Продолжить;
		КонецЕсли;
		
		// Инициализация свойств обработки.
		СопоставлениеОбъектовИнформационныхБаз.ИмяТаблицыПриемника            = СтрокаТаблицы.ИмяТаблицыПриемника;
		СопоставлениеОбъектовИнформационныхБаз.ИмяТипаОбъектаТаблицыИсточника = СтрокаТаблицы.ТипОбъектаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.ПоляТаблицыПриемника           = СтрокаТаблицы.ПоляТаблицы;
		СопоставлениеОбъектовИнформационныхБаз.ПоляПоискаТаблицыПриемника     = СтрокаТаблицы.ПоляПоиска;
		СопоставлениеОбъектовИнформационныхБаз.УзелИнформационнойБазы         = УзелИнформационнойБазы;
		СопоставлениеОбъектовИнформационныхБаз.ИмяФайлаСообщенияОбмена        = ИмяФайлаСообщенияОбмена;
		
		СопоставлениеОбъектовИнформационныхБаз.ТипИсточникаСтрокой = СтрокаТаблицы.ТипИсточникаСтрокой;
		СопоставлениеОбъектовИнформационныхБаз.ТипПриемникаСтрокой = СтрокаТаблицы.ТипПриемникаСтрокой;
		
		// конструктор
		СопоставлениеОбъектовИнформационныхБаз.Конструктор();
		
		// Выполняем автоматическое сопоставление объектов по умолчанию.
		СопоставлениеОбъектовИнформационныхБаз.ВыполнитьАвтоматическоеСопоставлениеПоУмолчанию(Отказ);
		
		// Получаем информацию дайджеста сопоставления.
		СопоставлениеОбъектовИнформационныхБаз.ПолучитьИнформациюДайджестаСопоставленияОбъектов(Отказ);
		
		// Информация дайджеста сопоставления.
		СтрокаТаблицы.КоличествоОбъектовВИсточнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВИсточнике();
		СтрокаТаблицы.КоличествоОбъектовВПриемнике       = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовВПриемнике();
		СтрокаТаблицы.КоличествоОбъектовСопоставленных   = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовСопоставленных();
		СтрокаТаблицы.КоличествоОбъектовНесопоставленных = СопоставлениеОбъектовИнформационныхБаз.КоличествоОбъектовНесопоставленных();
		СтрокаТаблицы.ПроцентСопоставленияОбъектов       = СопоставлениеОбъектовИнформационныхБаз.ПроцентСопоставленияОбъектов();
		СтрокаТаблицы.ИндексКартинки                     = ОбменДаннымиСервер.ИндексКартинкиТаблицыИнформацииСтатистики(СтрокаТаблицы.КоличествоОбъектовНесопоставленных, СтрокаТаблицы.ДанныеУспешноЗагружены);
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет загрузку данных в информационную базу для строк таблицы ИнформацияСтатистики.
//  В случае если будут загружены все данные сообщения обмена,
//  то в узел обмена будет записан номер входящего сообщения.
//  Это означает, что данные сообщения полностью загружены в информационную базу.
//  Повторная загрузка этого сообщения будет отменена.
//
// Параметры:
//       Отказ        - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
//       ИндексыСтрок - Массив - индексы строк таблицы ИнформацияСтатистики
//                               для которых необходимо выполнить загрузку данных.
//                               Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ВыполнитьЗагрузкуДанных(Отказ, ИндексыСтрок = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ИндексыСтрок = Неопределено Тогда
		
		ИндексыСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
			
			ИндексыСтрок.Добавить(ИнформацияСтатистики.Индекс(СтрокаТаблицы));
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблицыДляЗагрузки = Новый Массив;
	
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		КлючТаблицыДанных = ОбменДаннымиСервер.КлючТаблицыДанных(СтрокаТаблицы.ТипИсточникаСтрокой, СтрокаТаблицы.ТипПриемникаСтрокой, СтрокаТаблицы.ЭтоУдалениеОбъекта);
		
		ТаблицыДляЗагрузки.Добавить(КлючТаблицыДанных);
		
	КонецЦикла;
	
	// Инициализация свойств обработки.
	СопоставлениеОбъектовИнформационныхБаз = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	СопоставлениеОбъектовИнформационныхБаз.ИмяФайлаСообщенияОбмена = ИмяФайлаСообщенияОбмена;
	СопоставлениеОбъектовИнформационныхБаз.УзелИнформационнойБазы  = УзелИнформационнойБазы;
	
	// выполняем загрузку файла
	СопоставлениеОбъектовИнформационныхБаз.ВыполнитьЗагрузкуДанныхВИнформационнуюБазу(Отказ, ТаблицыДляЗагрузки);
	
	ДанныеУспешноЗагружены = Не Отказ;
	
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		СтрокаТаблицы.ДанныеУспешноЗагружены = ДанныеУспешноЗагружены;
		СтрокаТаблицы.ИндексКартинки = ОбменДаннымиСервер.ИндексКартинкиТаблицыИнформацииСтатистики(СтрокаТаблицы.КоличествоОбъектовНесопоставленных, СтрокаТаблицы.ДанныеУспешноЗагружены);
	
	КонецЦикла;
	
КонецПроцедуры

// Выполняет анализ входящего сообщения обмена. Заполняет данными таблицу ИнформацияСтатистики.
//
// Параметры:
//      Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
//      РезультатВыполненияОбмена - ПеречислениеСсылка.РезультатыВыполненияОбмена - результат выполнения обмена данными.
//
Процедура ВыполнитьАнализСообщенияОбмена(Отказ, РезультатВыполненияОбмена = Неопределено) Экспорт
	
	Если ПустаяСтрока(ИмяВременногоКаталогаСообщенийОбмена) Тогда
		// Не удалось получить данные из другой программы.
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроекОбмена = ОбменДаннымиСервер.СтруктураНастроекОбменаДляСеансаИнтерактивнойЗагрузки(УзелИнформационнойБазы, ИмяФайлаСообщенияОбмена);
	
	Если СтруктураНастроекОбмена.Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаОбменаДанными = СтруктураНастроекОбмена.ОбработкаОбменаДанными;
	
	ПараметрыАнализа = Новый Структура("СобиратьСтатистикуКлассификаторов", Истина);	
	ОбработкаОбменаДанными.ВыполнитьАнализСообщенияОбмена(ПараметрыАнализа);
	РезультатВыполненияОбмена = ОбработкаОбменаДанными.РезультатВыполненияОбмена();
	
	Если ОбработкаОбменаДанными.ФлагОшибки() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИнформацияСтатистики.Загрузить(ОбработкаОбменаДанными.ТаблицаДанныхЗаголовкаПакета());
	
	// Дополняем таблицу статистики служебными данными.
	ДополнитьТаблицуСтатистики(Отказ);
	
	// Определяем строки таблицы с признаком "ОдинКоМногим".
	ИнформацияСтатистикиВременная = ИнформацияСтатистики.Выгрузить(, "ИмяТаблицыПриемника, ЭтоУдалениеОбъекта");
	
	ДобавитьКолонкуСоЗначениемВТаблицу(ИнформацияСтатистикиВременная, 1, "Итератор");
	
	ИнформацияСтатистикиВременная.Свернуть("ИмяТаблицыПриемника, ЭтоУдалениеОбъекта", "Итератор");
	
	Для Каждого СтрокаТаблицы Из ИнформацияСтатистикиВременная Цикл
		
		Если СтрокаТаблицы.Итератор > 1 И Не СтрокаТаблицы.ЭтоУдалениеОбъекта Тогда
			
			Строки = ИнформацияСтатистики.НайтиСтроки(Новый Структура("ИмяТаблицыПриемника, ЭтоУдалениеОбъекта",
				СтрокаТаблицы.ИмяТаблицыПриемника, СтрокаТаблицы.ЭтоУдалениеОбъекта));
			
			Для Каждого Строка Из Строки Цикл
				
				Строка["ОдинКоМногим"] = Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

// Выполняет загрузку данных (таблиц) из сообщения обмена в кэш.
// Загружаются только те таблицы, которые ранее не были загружены.
// Переменная ОбработкаОбменаДанными содержит (кэширует) ранее загруженные таблицы.
//
// Параметры:
//       Отказ        - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
//       ИндексыСтрок - Массив - индексы строк таблицы ИнформацияСтатистики
//                               для которых необходимо выполнить загрузку данных.
//                               Если не указан, то операция будет выполнена для всех строк таблицы.
// 
Процедура ВыполнитьЗагрузкуДанныхИзСообщенияОбменаВКэш(Отказ, ИндексыСтрок)
	
	СтруктураНастроекОбмена = ОбменДаннымиСервер.СтруктураНастроекОбменаДляСеансаИнтерактивнойЗагрузки(УзелИнформационнойБазы, ИмяФайлаСообщенияОбмена);
	
	Если СтруктураНастроекОбмена.Отказ Тогда
		Возврат;
	КонецЕсли;
	СтруктураНастроекОбмена.ДатаНачала = ТекущаяДатаСеанса();
	ОбработкаОбменаДанными = СтруктураНастроекОбмена.ОбработкаОбменаДанными;
	
	// Получаем массив таблиц, которые необходимо пакетно загрузить в кэш платформы.
	ТаблицыДляЗагрузки = Новый Массив;
	
	Для Каждого ИндексСтроки Из ИндексыСтрок Цикл
		
		СтрокаТаблицы = ИнформацияСтатистики[ИндексСтроки];
		
		Если Не СтрокаТаблицы.СинхронизироватьПоИдентификатору Тогда
			Продолжить;
		КонецЕсли;
		
		КлючТаблицыДанных = ОбменДаннымиСервер.КлючТаблицыДанных(СтрокаТаблицы.ТипИсточникаСтрокой, СтрокаТаблицы.ТипПриемникаСтрокой, СтрокаТаблицы.ЭтоУдалениеОбъекта);
		
		// Таблица данных может быть уже загружена и находиться в кэше обработки ОбработкаОбменаДанными.
		ТаблицаДанных = ОбработкаОбменаДанными.ТаблицыДанныхСообщенияОбмена().Получить(КлючТаблицыДанных);
		
		Если ТаблицаДанных = Неопределено Тогда
			
			ТаблицыДляЗагрузки.Добавить(КлючТаблицыДанных);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Выполняем пакетную загрузку таблиц в кэш.
	Если ТаблицыДляЗагрузки.Количество() > 0 Тогда
		
		ОбработкаОбменаДанными.ВыполнитьЗагрузкуДанныхВТаблицуЗначений(ТаблицыДляЗагрузки);
		
		Если ОбработкаОбменаДанными.ФлагОшибки() Тогда
			
			НСтрока = НСтр("ru = 'При загрузке сообщения обмена возникли ошибки: %1'");
			НСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, ОбработкаОбменаДанными.СтрокаСообщенияОбОшибке());
			ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаСОшибкой(СтруктураНастроекОбмена.УзелИнформационнойБазы,
												СтруктураНастроекОбмена.ДействиеПриОбмене, 
												СтруктураНастроекОбмена.ДатаНачала,
												НСтрока);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьТаблицуСтатистики(Отказ)
	
	Для Каждого СтрокаТаблицы Из ИнформацияСтатистики Цикл
		
		Попытка
			Тип = Тип(СтрокаТаблицы.ТипОбъектаСтрокой);
		Исключение
			
			СтрокаСообщения = НСтр("ru = 'Ошибка: тип ""%1"" не определен.'");
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, СтрокаТаблицы.ТипОбъектаСтрокой);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,,, Отказ);
			Продолжить;
			
		КонецПопытки;
		
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		
		СтрокаТаблицы.ИмяТаблицыПриемника = МетаданныеОбъекта.ПолноеИмя();
		СтрокаТаблицы.Представление       = МетаданныеОбъекта.Представление();
		
		СтрокаТаблицы.Ключ = Строка(Новый УникальныйИдентификатор());
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьКолонкуСоЗначениемВТаблицу(Таблица, ЗначениеИтератора, ИмяПоляИтератора)
	
	Таблица.Колонки.Добавить(ИмяПоляИтератора);
	
	Таблица.ЗаполнитьЗначения(ЗначениеИтератора, ИмяПоляИтератора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Данные табличной части ИнформацияСтатистики.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Данные табличной части ИнформацияСтатистики.
//
Функция ТаблицаИнформацииСтатистики() Экспорт
	
	Возврат ИнформацияСтатистики.Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
