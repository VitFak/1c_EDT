

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Предопределенный Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	//Комментарий от второго разработчика
	
КонецПроцедуры
