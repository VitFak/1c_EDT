////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет настройки подсистемы.
//
// Параметры:
//  Настройки - Структура - 
//   * Расписания - Соответствие:
//      ** Ключ     - Строка - представление расписания;
//      ** Значение - РасписаниеРегламентногоЗадания - вариант расписания.
//   * СтандартныеИнтервалы - Массив - содержит строковые представления интервалов времени.
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Переопределяет массив реквизитов объекта, относительно которых разрешается устанавливать время напоминания.
// Например, можно скрыть те реквизиты с датами, которые являются служебными или не имеют смысла для 
// установки напоминаний: дата документа или задачи и прочие.
// 
// Параметры:
//  Источник - ЛюбаяСсылка - ссылка на объект, для которого формируется массив реквизитов с датами;
//  МассивРеквизитов - Массив - имена реквизитов (из метаданных), содержащих даты.
//
Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, МассивРеквизитов) Экспорт
	
КонецПроцедуры

#КонецОбласти
