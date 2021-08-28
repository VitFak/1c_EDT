////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру, содержащую персональные настройки работы с файлами.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * ПоказыватьЗанятыеФайлыПриЗавершенииРаботы        - Булево - Существует, только если внедрена подсистема Работа с файлами.
//    * СпрашиватьРежимРедактированияПриОткрытииФайла    - Булево - Существует, только если внедрена подсистема Работа с файлами.
//    * ПоказыватьКолонкуРазмер                          - Булево - Существует, только если внедрена подсистема Работа с файлами.
//    * ДействиеПоДвойномуЩелчкуМыши                     - Строка - Существует, только если внедрена подсистема Работа с файлами.
//    * СпособСравненияВерсийФайлов                      - Строка - Существует, только если внедрена подсистема Работа с файлами.
//    * ГрафическиеСхемыРасширение                       - Строка - 
//    * ГрафическиеСхемыСпособОткрытия                   - ПеречислениеСсылка.СпособыОткрытияФайлаНаПросмотр -
//    * ТекстовыеФайлыРасширение                         - Строка - 
//    * ТекстовыеФайлыСпособОткрытия                     - ПеречислениеСсылка.СпособыОткрытияФайлаНаПросмотр -
//    * МаксимальныйРазмерЛокальногоКэшаФайлов           - Число - 
//    * ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов    - Булево - 
//    * ПоказыватьИнформациюЧтоФайлНеБылИзменен          - Булево - 
//    * ПоказыватьПодсказкиПриРедактированииФайлов       - Булево - 
//    * ПутьКЛокальномуКэшуФайлов                        - Строка - 
//    * ЭтоПолноправныйПользователь                      - Булево - 
//    * УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования - Булево - .
//
Функция НастройкиРаботыСФайлами() Экспорт
	
	Возврат ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
	
КонецФункции

// Сохраняет настройки работы с файлами.
//
// Параметры:
//  НастройкиРаботыСФайлами - Структура настроек работы с файлами с их значениями.
//                            В качестве ключа настройки возможно указывать строки с именем настроек:
//                                 ПоказыватьИнформациюЧтоФайлНеБылИзменен,
//                                 ПоказыватьЗанятыеФайлыПриЗавершенииРаботы,
//                                 ПоказыватьКолонкуРазмер,
//                                 ТекстовыеФайлыРасширение,
//                                 ТекстовыеФайлыСпособОткрытия,
//                                 ГрафическиеСхемыРасширение,
//                                 ПоказыватьПодсказкиПриРедактированииФайлов,
//                                 СпрашиватьРежимРедактированияПриОткрытииФайла,
//                                 СпособСравненияВерсийФайлов,
//                                 ДействиеПоДвойномуЩелчкуМыши,
//                                 ГрафическиеСхемыСпособОткрытия.
//
Процедура СохранитьНастройкиРаботыСФайлами(НастройкиРаботыСФайлами) Экспорт
	
	КлючиОбъектовНастроекРаботыСФайлами = КлючиОбъектовНастроекРаботыСФайлами();
	
	Для Каждого Настройка Из НастройкиРаботыСФайлами Цикл
		
		КлючОбъектаНастройки = КлючиОбъектовНастроекРаботыСФайлами[Настройка.Ключ];
		Если КлючОбъектаНастройки <> Неопределено Тогда
			Если СтрНачинаетсяС(КлючОбъектаНастройки, "НастройкиОткрытияФайлов\") Тогда
				ТипФайловНастройки = СтрЗаменить(КлючОбъектаНастройки, "НастройкиОткрытияФайлов\", "");
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъектаНастройки,
					СтрЗаменить(Настройка.Ключ, ТипФайловНастройки, ""), Настройка.Значение);
			Иначе
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъектаНастройки, Настройка.Ключ, Настройка.Значение);
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

// Возвращает максимальный размер файла.
//
// Возвращаемое значение:
//  Число - целое число байт.
//
Функция МаксимальныйРазмерФайла() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МаксимальныйРазмерФайла = Константы.МаксимальныйРазмерФайла.Получить();
	
	Если МаксимальныйРазмерФайла = Неопределено
	 ИЛИ МаксимальныйРазмерФайла = 0 Тогда
		
		МаксимальныйРазмерФайла = 50*1024*1024; // 50 мб
		Константы.МаксимальныйРазмерФайла.Установить(МаксимальныйРазмерФайла);
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	   И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		МаксимальныйРазмерФайлаОбластиДанных =
			Константы.МаксимальныйРазмерФайлаОбластиДанных.Получить();
		
		Если МаксимальныйРазмерФайлаОбластиДанных = Неопределено
		 ИЛИ МаксимальныйРазмерФайлаОбластиДанных = 0 Тогда
			
			МаксимальныйРазмерФайлаОбластиДанных = 50*1024*1024; // 50 мб
			
			Константы.МаксимальныйРазмерФайлаОбластиДанных.Установить(
				МаксимальныйРазмерФайлаОбластиДанных);
		КонецЕсли;
		
		МаксимальныйРазмерФайла = Мин(МаксимальныйРазмерФайла, МаксимальныйРазмерФайлаОбластиДанных);
	КонецЕсли;
	
	Возврат МаксимальныйРазмерФайла;
	
КонецФункции

// Возвращает максимальный размер файла провайдера.
//
// Возвращаемое значение:
//  Число - целое число байт.
//
Функция МаксимальныйРазмерФайлаОбщий() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МаксимальныйРазмерФайла = Константы.МаксимальныйРазмерФайла.Получить();
	
	Если МаксимальныйРазмерФайла = Неопределено
	 ИЛИ МаксимальныйРазмерФайла = 0 Тогда
		
		МаксимальныйРазмерФайла = 50*1024*1024; // 50 мб
		Константы.МаксимальныйРазмерФайла.Установить(МаксимальныйРазмерФайла);
	КонецЕсли;
	
	Возврат МаксимальныйРазмерФайла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с томами файлов

// Есть ли хоть один том хранения файлов.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда существует хотя бы один работающий том.
//
Функция ЕстьТомаХраненияФайлов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
	|ГДЕ
	|	ТомаХраненияФайлов.ПометкаУдаления = ЛОЖЬ";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура СобратьСтатистикуКонфигурации() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		Возврат;
	КонецЕсли;
	
	МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(1) КАК Количество
		|ИЗ
		|	Справочник.УчетныеЗаписиСинхронизацииФайлов КАК УчетныеЗаписиСинхронизацииФайлов";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	МодульЦентрМониторинга.ЗаписатьСтатистикуОбъектаКонфигурации("Справочник.УчетныеЗаписиСинхронизацииФайлов", Выборка.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает ключи объектов настроек работы с файлами.
// 
Функция КлючиОбъектовНастроекРаботыСФайлами()
	
	КлючиОбъектовНастроекРаботыСФайлами = Новый Соответствие;
	
	ФайловыеФункцииСлужебный.ПриСохраненииНастроекРаботыСФайлами(
		КлючиОбъектовНастроекРаботыСФайлами);
	
	КлючиОбъектовНастроекРаботыСФайлами.Вставить("ТекстовыеФайлыРасширение" ,      "НастройкиОткрытияФайлов\ТекстовыеФайлы");
	КлючиОбъектовНастроекРаботыСФайлами.Вставить("ТекстовыеФайлыСпособОткрытия" ,  "НастройкиОткрытияФайлов\ТекстовыеФайлы");
	КлючиОбъектовНастроекРаботыСФайлами.Вставить("ГрафическиеСхемыРасширение" ,    "НастройкиОткрытияФайлов\ГрафическиеСхемы");
	КлючиОбъектовНастроекРаботыСФайлами.Вставить("ГрафическиеСхемыСпособОткрытия" ,"НастройкиОткрытияФайлов\ГрафическиеСхемы");	
	КлючиОбъектовНастроекРаботыСФайлами.Вставить("ПоказыватьПодсказкиПриРедактированииФайлов" ,"НастройкиПрограммы");
	КлючиОбъектовНастроекРаботыСФайлами.Вставить("ПоказыватьИнформациюЧтоФайлНеБылИзменен" ,   "НастройкиПрограммы");
	
	Возврат КлючиОбъектовНастроекРаботыСФайлами;
	
КонецФункции

#КонецОбласти

