
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ДоступноИспользованиеРазделенныхДанных Тогда
		ИмяОткрываемойФормы = "Обработка.ПанельАдминистрированияБСП.Форма.НастройкиСинхронизацииДанных";
	Иначе
		ИмяОткрываемойФормы = "Обработка.ПанельАдминистрированияБСПВМоделиСервиса.Форма.СинхронизацияДанныхДляАдминистратораСервиса";
	КонецЕсли;
	
	ОткрытьФорму(
		ИмяОткрываемойФормы,
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		ИмяОткрываемойФормы + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
