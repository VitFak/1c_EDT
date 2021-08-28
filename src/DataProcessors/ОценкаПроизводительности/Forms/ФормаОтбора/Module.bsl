
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаправлениеПриИзменении(Элемент)
	
	СформироватьУсловие();
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	СформироватьУсловие();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	РезультатВыбора = Новый Структура("Направление, Состояние");
	РезультатВыбора.Направление = Направление;
	РезультатВыбора.Состояние = Состояние;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьУсловие()
	
	Если Направление > 0 Тогда
		Если ВРег(Состояние) = "ХОРОШО" Тогда
			Предел = 0.93;
		ИначеЕсли ВРег(Состояние) = "УДОВЛЕТВОРИТЕЛЬНО" Тогда
			Предел = 0.84;
		ИначеЕсли ВРег(Состояние) = "ПЛОХО" Тогда
			Предел = 0.69;
		КонецЕсли;
		Условие = "apdex > " + Предел;
	ИначеЕсли Направление < 0 Тогда
		Если ВРег(Состояние) = "ХОРОШО" Тогда
			Предел = 0.85;
		ИначеЕсли ВРег(Состояние) = "УДОВЛЕТВОРИТЕЛЬНО" Тогда
			Предел = 0.7;
		ИначеЕсли ВРег(Состояние) = "ПЛОХО" Тогда
			Предел = 0.5;
		КонецЕсли;
		Условие = "apdex < " + Предел;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
