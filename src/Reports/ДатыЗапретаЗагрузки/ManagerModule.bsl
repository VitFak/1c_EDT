#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//
// Примеры:
//
//  1. Установка описания варианта.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Описание = НСтр("ru = '<Описание>'");
//
//  2. Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.Включен = Ложь;
	
	ПервыйВариант = ПервыйВариант();
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ПервыйВариант.Имя);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ПервыйВариант.Описание;
	
	ВторойВариант = ВторойВариант();
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ВторойВариант.Имя);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ВторойВариант.Описание;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "Форма" Тогда
		Возврат;
	КонецЕсли;
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
#Иначе
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
#КонецЕсли
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "ФормаОтчета";
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Вызывается из форма отчета.
Процедура УстановитьВариант(Форма, Вариант) Экспорт
	
	ПервыйВариант = ПервыйВариант();
	ВторойВариант = ВторойВариант();
	
	Отчеты.ДатыЗапретаИзменения.НастроитьФорму(Форма, ПервыйВариант, ВторойВариант, Вариант);
	
КонецПроцедуры

Функция ПервыйВариант()
	
	Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоПользователям";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоПользователямБезОбъектов";
	Иначе
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоПользователямБезРазделов";
	КонецЕсли;
	
	СвойстваВарианта = Новый Структура;
	СвойстваВарианта.Вставить("Имя", ИмяВарианта);
	
	СвойстваВарианта.Вставить("Заголовок",
		НСтр("ru = 'Даты запрета загрузки данных по информационным базам'"));
	
	СвойстваВарианта.Вставить("Описание",
		НСтр("ru = 'Выводит даты запрета загрузки для объектов, сгруппированные по информационным базам.'"));
	
	Возврат СвойстваВарианта;
	
КонецФункции

Функция ВторойВариант()
	
	Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоРазделамОбъектамДляПользователей";
		Заголовок = НСтр("ru = 'Даты запрета загрузки данных по разделам и объектам'");
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета загрузки, сгруппированные по разделам с объектами.'");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоРазделамДляПользователей";
		Заголовок = НСтр("ru = 'Даты запрета загрузки данных по разделам'");
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета загрузки, сгруппированные по разделам.'");
	Иначе
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоОбъектамДляПользователей";
		Заголовок = НСтр("ru = 'Даты запрета загрузки данных по объектам'");
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета загрузки, сгруппированные по объектам.'");
	КонецЕсли;
	
	СвойстваВарианта = Новый Структура;
	СвойстваВарианта.Вставить("Имя",       ИмяВарианта);
	СвойстваВарианта.Вставить("Заголовок", Заголовок);
	СвойстваВарианта.Вставить("Описание",  ОписаниеВарианта);
	
	Возврат СвойстваВарианта;
	
КонецФункции

#КонецОбласти

#КонецЕсли
