&НаКлиенте
Перем Настройки;
&НаСервере
Перем Библиотека;

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриОткрытии" формы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого ТекОтчет Из Метаданные.Отчеты Цикл
		ТестируемыеОтчеты.Добавить(ТекОтчет.Имя, ТекОтчет.Представление());
	КонецЦикла;
	ТестируемыеОтчеты.СортироватьПоПредставлению();
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события "ПриОткрытии" формы
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазмерПорции = 20;

	Настройки = ПолучитьНастройки();
	
	ПроверитьСвойства(Настройки, "ПреобразованиеДанных", "Отсутствуют обязательные настройки: %1");
	
	ПодключитьВнешнююОбработку("ПреобразованиеДанных", Настройки.ПреобразованиеДанных);
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиЭлементовФормы

// Процедура - обработка начала выбора каталога
//
&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Каталог результатов теста СКД";

	ЗавершениеВыбораКаталога = Новый ОписаниеОповещения("КаталогВыгрузкиНачалоВыбораЗавершение", ЭтаФорма);

	Диалог.Показать(ЗавершениеВыбораКаталога);

КонецПроцедуры // КаталогВыгрузкиНачалоВыбора()

// Процедура - продолжение обработки выбора каталога
//
&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	Если НЕ ТипЗнч(ВыбранныеФайлы) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;

	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	КаталогВыгрузки = ВыбранныеФайлы[0];

КонецПроцедуры // КаталогВыгрузкиНачалоВыбораЗавершение()

#КонецОбласти

#Область ОбработкаКоманд

// Функция - возращает массив ссылок на тестируемые объекты
//
// Возвращаемое значение:
//  Массив(Структура)            - описание объекта для тестирования преобразования
//		*Ссылка                  - Ссылка, НаборЗаписей - ссылка на объект для тестирования или набор записей
//		*ПравилаВыгрузки         - Массив(Структура)    - описание правил дополнения результата выгрузки объекта
//			*ТипИсточника        - Строка               - имя типа источника, обрабатываемого правилом
//          *ФункцияДополнения   - Строка               - имя функции обработки результата выгрузки объекта
&НаСервере
Функция ПолучитьОбъектыДляТестированияНаСервере()
	
	МассивСсылок = Новый Массив();

	Первые = ?(КоличествоВВыборке > 0, " ПЕРВЫЕ " + Формат(КоличествоВВыборке, "ЧГ=;"), "");
	
	Для Каждого ТекМетаОбъект Из Метаданные.Справочники Цикл
		
		Если ТекМетаОбъект.Иерархический
		   И ТекМетаОбъект.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
			                      " ТекТаб.Ссылка ИЗ Справочник." + ТекМетаОбъект.Имя +
			                      " КАК ТекТаб ГДЕ ТекТаб.ЭтоГруппа");
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
				СтруктураСсылки.ПравилаВыгрузки.Добавить(Новый Структура("ТипИсточника, ФункцияДополнения",
				                                                         ТекМетаОбъект.ПолноеИмя(),
				                                                         "ДобавитьНаименованиеОбъекта"));
				МассивСсылок.Добавить(СтруктураСсылки);
		
			КонецЦикла;
			Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
			                      " ТекТаб.Ссылка ИЗ Справочник." + ТекМетаОбъект.Имя +
			                      " КАК ТекТаб ГДЕ НЕ ТекТаб.ЭтоГруппа");
		Иначе
			Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
			                      " ТекТаб.Ссылка ИЗ Справочник." + ТекМетаОбъект.Имя +
			                      " КАК ТекТаб");
		КонецЕсли;
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
			СтруктураСсылки.ПравилаВыгрузки.Добавить(Новый Структура("ТипИсточника, ФункцияДополнения",
			                                                         ТекМетаОбъект.ПолноеИмя(),
			                                                         "ДобавитьНаименованиеОбъекта"));
			МассивСсылок.Добавить(СтруктураСсылки);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТекМетаОбъект Из Метаданные.ПланыВидовХарактеристик Цикл
		
		Если ТекМетаОбъект.Иерархический Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
			                      " ТекТаб.Ссылка ИЗ ПланВидовХарактеристик." + ТекМетаОбъект.Имя +
			                      " КАК ТекТаб ГДЕ ТекТаб.ЭтоГруппа");
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
				МассивСсылок.Добавить(СтруктураСсылки);
			КонецЦикла;
			Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
			                      " ТекТаб.Ссылка ИЗ ПланВидовХарактеристик." + ТекМетаОбъект.Имя +
			                      " КАК ТекТаб ГДЕ НЕ ТекТаб.ЭтоГруппа");
		Иначе
			Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
			                      " ТекТаб.Ссылка ИЗ ПланВидовХарактеристик." + ТекМетаОбъект.Имя +
			                      " КАК ТекТаб");
		КонецЕсли;
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
			МассивСсылок.Добавить(СтруктураСсылки);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТекМетаОбъект Из Метаданные.ПланыВидовРасчета Цикл
		
		Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
		                      " ТекТаб.Ссылка ИЗ ПланВидовРасчета." + ТекМетаОбъект.Имя +
		                      " КАК ТекТаб");
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
			МассивСсылок.Добавить(СтруктураСсылки);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТекМетаОбъект Из Метаданные.ПланыСчетов Цикл
		
		Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
		                      " ТекТаб.Ссылка ИЗ ПланСчетов." + ТекМетаОбъект.Имя +
		                      " КАК ТекТаб");
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
			МассивСсылок.Добавить(СтруктураСсылки);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТекМетаОбъект Из Метаданные.ПланыОбмена Цикл
		
		Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
		                      " ТекТаб.Ссылка ИЗ ПланОбмена." + ТекМетаОбъект.Имя +
		                      " КАК ТекТаб");
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
			МассивСсылок.Добавить(СтруктураСсылки);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТекМетаОбъект Из Метаданные.Документы Цикл
		
		Запрос = Новый Запрос("ВЫБРАТЬ" + Первые +
		                      " ТекТаб.Ссылка ИЗ Документ." + ТекМетаОбъект.Имя +
		                      " КАК ТекТаб");
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураСсылки = Новый Структура("Ссылка, ПравилаВыгрузки", Выборка.Ссылка, Новый Массив());
			МассивСсылок.Добавить(СтруктураСсылки);
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивСсылок
	
КонецФункции // ПолучитьОбъектыДляТестированияНаСервере()

// Процедура - обработчик команды "Тест" формы на сервере
//
&НаСервере
Процедура ВыполнитьТестОбъектов(ОбъектыДляТестирования, АдресаФайлов = неопределено)
	
	Библиотека = ПреобразованиеДанных();
	
	АдресаФайлов = Новый Соответствие();
	
	Для Каждого ТекОписание Из ОбъектыДляТестирования Цикл
		
		Для Каждого ТекПравило Из ТекОписание.ПравилаВыгрузки Цикл
			Библиотека.ДобавитьПравилоВыгрузкиТипа(ТекПравило.ТипИсточника, ТекПравило.ФункцияДополнения, ЭтотОбъект);
		КонецЦикла;
			
		Сообщить(СтрШаблон("Тестирование объекта ""%1"" (%2)...",
		                   ТекОписание.Ссылка,
		                   ТекОписание.Ссылка.Метаданные().ПолноеИмя()));
	
		Представление = Библиотека.ОбъектВСтруктуру(ТекОписание.Ссылка.ПолучитьОбъект());
		ТекстОбъекта1 = Библиотека.ЗаписатьОписаниеОбъектаВJSON(Представление);
		Представление = Библиотека.ПрочитатьОписаниеОбъектаИзJSON(ТекстОбъекта1);
		Попытка
			СозданныйОбъект = Библиотека.СоздатьОбъектИзСтруктуры(Представление, Истина);
		Исключение
			Сообщить(СтрШаблон("Ошибка создания объекта ""%1 (%2: %3)"": %4%5",
			                   ТекОписание.Ссылка,
			                   ТекОписание.Ссылка.Метаданные().ПолноеИмя(),
			                   СокрЛП(ТекОписание.Ссылка.УникальныйИдентификатор()),
			                   Символы.ПС,
			                   ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
			Продолжить;
		КонецПопытки;
		
		Если ВыгрузитьРезультатыТеста Тогда
			Представление = Библиотека.ОбъектВСтруктуру(СозданныйОбъект);
			ТекстОбъекта2 = Библиотека.ЗаписатьОписаниеОбъектаВJSON(Представление);
			
			Хранилище = Новый Структура("Первый, Второй",
										ПоместитьВоВременноеХранилище(ТекстОбъекта1, ЭтотОбъект.УникальныйИдентификатор),
										ПоместитьВоВременноеХранилище(ТекстОбъекта2, ЭтотОбъект.УникальныйИдентификатор));
			АдресаФайлов.Вставить(ТекОписание.Ссылка.Метаданные().ПолноеИмя() + "." +
			                      СокрЛП(ТекОписание.Ссылка.УникальныйИдентификатор()), Хранилище);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ВыполнитьТестОбъектов()

// Процедура - обработчик команды "Тест" формы
//
&НаКлиенте
Процедура Тест(Команда)
	
	Если ВыгрузитьРезультатыТеста Тогда
		ОбеспечитьКаталог(КаталогВыгрузки + "\orig");
		ОбеспечитьКаталог(КаталогВыгрузки + "\test");
	КонецЕсли;

	ТестируемыеОбъекты = ПолучитьОбъектыДляТестированияНаСервере();
	
	ОбъектыДляТестирования = Новый Массив();
	
	й = 1;
	НачВремя = ТекущаяДата();
	
	Для Каждого ТекЭлемент Из ТестируемыеОбъекты Цикл
		
		ОбъектыДляТестирования.Добавить(ТекЭлемент);
		
		й = й + 1;
		
		Если ОбъектыДляТестирования.Количество() < РазмерПорции
		   И й < ТестируемыеОбъекты.Количество() - 1 Тогда
			Продолжить;
		КонецЕсли;
			
		Если ОбъектыДляТестирования.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		АдресаФайлов = Неопределено;
		ВыполнитьТестОбъектов(ОбъектыДляТестирования, АдресаФайлов);

		ОбъектыДляТестирования.Очистить();

		Если НЕ ВыгрузитьРезультатыТеста Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекРезультат Из АдресаФайлов Цикл
			ВремФайл = Новый ТекстовыйДокумент();
			ВремФайл.УстановитьТекст(ПолучитьИзВременногоХранилища(ТекРезультат.Значение.Первый));
			ВремФайл.Записать(КаталогВыгрузки + "\orig\" + ТекРезультат.Ключ + ".json");
			
			ВремФайл = Новый ТекстовыйДокумент();
			ВремФайл.УстановитьТекст(ПолучитьИзВременногоХранилища(ТекРезультат.Значение.Второй));
			ВремФайл.Записать(КаталогВыгрузки + "\test\" + ТекРезультат.Ключ + ".json");
		КонецЦикла;
		
	КонецЦикла;

	КонВремя = ТекущаяДата();

	Сообщить("Всего объектов:" + Формат(й, "ЧН=; ЧГ="));
	Сообщить("Начало выполнения:" + Формат(НачВремя, "ЧН=; ЧГ="));
	Сообщить("Окончание выполнения: " + Формат(КонВремя, "ЧН=; ЧГ="));
	Сообщить("Время выполнения: " + Формат(КонВремя - НачВремя, "ЧН=; ЧГ=") + "с.");
	Сообщить("Скорость всего: " +  Формат(й / (КонВремя - НачВремя), "ЧН=; ЧГ=") + "об./с.");
	
КонецПроцедуры // Тест()

// Процедура - обработчик команды "ТестСКД" формы на сервере
//
&НаСервере
Процедура ТестСКДНаСервере(ОтчетыДляТестирования, АдресаФайлов = Неопределено)

	Библиотека = ПреобразованиеДанных();
	
	АдресаФайлов = Новый Соответствие();
	
	Для Каждого ТекИмяОтчета Из ОтчетыДляТестирования Цикл
		
		ТекОтчет = Метаданные.Отчеты[ТекИмяОтчета];
		
		Для Каждого ТекМакет Из ТекОтчет.Макеты Цикл
		
			ТестируемыйОбъект = Отчеты[ТекОтчет.Имя].ПолучитьМакет(ТекМакет.Имя);
			Если НЕ ТипЗнч(ТестируемыйОбъект) = Тип("СхемаКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			
			Сообщить(СтрШаблон("Преобразование объекта ""%1"" (%2)...", "Отчет." + ТекОтчет.Имя + "." + ТекМакет.Имя, ТипЗнч(ТестируемыйОбъект)));
				
			Представление = Библиотека.СКДВСтруктуру(ТестируемыйОбъект);
			Попытка
				ТекстОбъекта = Библиотека.ЗаписатьОписаниеОбъектаВJSON(Представление);
				Хранилище = Новый Структура("Первый", ПоместитьВоВременноеХранилище(ТекстОбъекта, ЭтотОбъект.УникальныйИдентификатор));
				АдресаФайлов.Вставить(ТекОтчет.Имя + "." + ТекМакет.Имя, Хранилище);
			Исключение
				ПроверитьСовместимостьСJSON(Представление, "Отчет." + ТекОтчет.Имя + "." + ТекМакет.Имя);
			КонецПопытки;
			
			Представление = Библиотека.ПрочитатьОписаниеОбъектаИзJSON(ТекстОбъекта);
			
			Попытка
				КопияСКД = Неопределено;
				Библиотека.СКДИзСтруктуры(КопияСКД, Представление);
			Исключение
				ТекстОшибки = СтрШаблон("Ошибка восстановления СКД: %1%2", Символы.ПС, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				Сообщить(ТекстОшибки);
			КонецПопытки;
			Представление = Библиотека.СКДВСтруктуру(КопияСКД);
			ТекстОбъекта = Библиотека.ЗаписатьОписаниеОбъектаВJSON(Представление);
			АдресаФайлов[ТекОтчет.Имя + "." + ТекМакет.Имя].Вставить("Второй", ПоместитьВоВременноеХранилище(ТекстОбъекта, ЭтотОбъект.УникальныйИдентификатор));
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // ТестСКДНаСервере()

// Процедура - обработчик команды "ТестСКД" формы
//
&НаКлиенте
Процедура ТестСКД(Команда)
	
	Если ВыгрузитьРезультатыТеста Тогда
		ОбеспечитьКаталог(КаталогВыгрузки + "\orig");
		ОбеспечитьКаталог(КаталогВыгрузки + "\test");
	КонецЕсли;

	ОтчетыДляТестирования = Новый Массив();
	
	Для Каждого ТекЭлемент Из ТестируемыеОтчеты Цикл
		
		Если ТекЭлемент.Пометка Тогда
			ОтчетыДляТестирования.Добавить(ТекЭлемент.Значение);
		КонецЕсли;
		
		Если ОтчетыДляТестирования.Количество() < РазмерПорции
		   И ТестируемыеОтчеты.Индекс(ТекЭлемент) < ТестируемыеОтчеты.Количество() - 1 Тогда
			Продолжить;
		КонецЕсли;
			
		Если ОтчетыДляТестирования.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		АдресаФайлов = Неопределено;
		ТестСКДНаСервере(ОтчетыДляТестирования, АдресаФайлов);

		ОтчетыДляТестирования.Очистить();

		Если НЕ ВыгрузитьРезультатыТеста Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекСКД Из АдресаФайлов Цикл
			ВремФайл = Новый ТекстовыйДокумент();
			ВремФайл.УстановитьТекст(ПолучитьИзВременногоХранилища(ТекСКД.Значение.Первый));
			ВремФайл.Записать(КаталогВыгрузки + "\orig\" + ТекСкд.Ключ + ".json");
			
			ВремФайл = Новый ТекстовыйДокумент();
			ВремФайл.УстановитьТекст(ПолучитьИзВременногоХранилища(ТекСКД.Значение.Второй));
			ВремФайл.Записать(КаталогВыгрузки + "\test\" + ТекСкд.Ключ + ".json");
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры // ТестСКД()

&НаСервере
Процедура ПроверитьСовместимостьСJSON(СтруктураОбъекта, Знач ИмяВИерархии = "")
	
	Библиотека = ПреобразованиеДанных();

	Попытка
		//@skip-warning
		ТекстОбъекта = Библиотека.ЗаписатьОписаниеОбъектаВJSON(СтруктураОбъекта);
	Исключение
		ТекстОшибки = СтрШаблон("Ошибка преобразования в JSON ""%1"" (%2): %3%4",
		                        ИмяВИерархии,
		                        СокрЛП(ТипЗнч(СтруктураОбъекта)),
		                        Символы.ПС,
		                        ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Сообщить(ТекстОшибки);
	КонецПопытки;

	Если ТипЗнч(СтруктураОбъекта) = Тип("Структура") ИЛИ  ТипЗнч(СтруктураОбъекта) = Тип("Соответствие") Тогда
		Для Каждого ТекЭлемент Из СтруктураОбъекта Цикл
			ПроверитьСовместимостьСJSON(ТекЭлемент.Значение, ИмяВИерархии + "." + ТекЭлемент.Ключ);
		КонецЦикла;	
	ИначеЕсли ТипЗнч(СтруктураОбъекта) = Тип("Массив") Тогда
		Для й = 0 По СтруктураОбъекта.ВГраница() Цикл
			ПроверитьСовместимостьСJSON(СтруктураОбъекта[й], ИмяВИерархии + "." + СокрЛП(й));
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиВыгрузкиДанных

// Процедура - добавляет в описание ссылки наименование
//
// Параметры:
//  ОписаниеЗначения       - Структура      - Структура значения для дополнения
//  Значение               - Произвольный   - Преобразуемое значение
//
&НаСервере
Процедура ДобавитьНаименованиеОбъекта(ОписаниеЗначения, Значение) Экспорт
	
	ОписаниеЗначения.Вставить("Наименование", СокрЛП(Значение));
	
КонецПроцедуры // ДобавитьНаименованиеОбъекта()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - возвращает настройки из JSON-файла настроек
//
// Параметры:
//  АдресНастроек     - Строка     - адрес временного хранилища настроек
// 
// Возвращаемое значение:
//	Структура      - полученные настройки
//
&НаСервере
Функция ПолучитьНастройкиНаСервере(Знач АдресНастроек)
	
	ДанныеНастроек = ПолучитьИзВременногоХранилища(АдресНастроек);
	
	ЧтениеНастроек = Новый ЧтениеJSON();

	ЧтениеНастроек.ОткрытьПоток(ДанныеНастроек.ОткрытьПотокДляЧтения());
	
	Возврат ПрочитатьJSON(ЧтениеНастроек, Ложь, , ФорматДатыJSON.ISO);
	
КонецФункции // ПолучитьНастройкиНаСервере()

// Функция - возвращает настройки из JSON-файла настроек
//
// Параметры:
//  ПутьКФайлуНастроек     - Строка     - путь к JSON-файлу настроек
// 
// Возвращаемое значение:
//	Структура      - полученные настройки
//
&НаКлиенте
Функция ПолучитьНастройки(Знач ПутьКФайлуНастроек = "")
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлуНастроек) Тогда
		ПутьКФайлуНастроек = КаталогТекущейОбработки() + "settings.json";
	КонецЕсли;
	
	ПроверитьДопустимостьТипа(ПутьКФайлуНастроек,
	                          "Строка, Файл",
	                          СтрШаблон("Некорректно указан файл настроек ""%1""", СокрЛП(ПутьКФайлуНастроек)) +
							  ", тип ""%1"", ожидается тип %2!");
	
	Если ТипЗнч(ПутьКФайлуНастроек) = Тип("Файл") Тогда
		ПутьКФайлуНастроек = ПутьКФайлуНастроек.ПолноеИмя;
	КонецЕсли;
	
	АдресНастроек = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлуНастроек), ЭтотОбъект.УникальныйИдентификатор);
	
	Попытка
		Возврат ПолучитьНастройкиНаСервере(АдресНастроек);
	Исключение
		ВызватьИсключение СтрШаблон("Ошибка чтения файла настроек ""%1"": %2%3",
		                            ПутьКФайлуНастроек,
									Символы.ПС,
									ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецФункции // ПолучитьНастройки()

// Функция - возвращает путь к каталогу текущей обработки
// 
// Возвращаемое значение:
//	Строка       - путь к каталогу текущей обработки
//
&НаСервере
Функция КаталогТекущейОбработки()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	ФайлЭтойОбработки = Новый Файл(ОбработкаОбъект.ИспользуемоеИмяФайла);
	
	Возврат ФайлЭтойОбработки.Путь;
	
КонецФункции // КаталогТекущейОбработки()

// Функция - Получает обработку сериализации значений
// 
// Возвращаемое значение:
//		ВнешняяОбработкаОбъект - обработка преобразования данных
//
&НаСервере
Функция ПреобразованиеДанных()
	
	Если Библиотека = Неопределено Тогда
		//Библиотека = ВнешниеОбработки.Создать("D:\repo\SerLib1C\dp\bin\ктв_ПреобразованиеДанных.epf");
		Библиотека = ВнешниеОбработки.Создать("ПреобразованиеДанных");
	КонецЕсли;
	 
	Возврат Библиотека; 

КонецФункции // ПреобразованиеДанных()

// Функция - ищет внешнюю обработку по указанному имени и пути, подключает ее
// и возвращает имя подключенной обработки
//
// Параметры:
//  ИмяОбработки         - Строка        - имя внешней обработки
// 
// Возвращаемое значение:
//  ВнешняяОбработкаОбъект        - внешняя обработка
// 
&НаКлиенте
Функция ПодключитьВнешнююОбработку(Знач ИмяОбработки, Знач ПутьКОбработке = "")
	
	Если ЗначениеЗаполнено(ПутьКОбработке) Тогда
		ПутьКОбработке = СтрЗаменить(ПутьКОбработке, "$thisRoot\", КаталогТекущейОбработки());
	Иначе
		ПутьКОбработке = КаталогТекущейОбработки() + ИмяОбработки + ".epf";
	КонецЕсли;
	
	АдресОбработки = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКОбработке), ЭтотОбъект.УникальныйИдентификатор);
	
	Возврат ПодключитьВнешнююОбработкуНаСервере(АдресОбработки, ИмяОбработки);
	
КонецФункции // ПодключитьВнешнююОбработкуПоИмени()

// Функция - подключает внешнюю обработку из указанного хранилища с указанным именем
// возвращает имя подключенной обработки
//
// Параметры:
//  ИмяОбработки         - Строка        - имя внешней обработки
// 
// Возвращаемое значение:
//  ВнешняяОбработкаОбъект        - внешняя обработка
// 
&НаСервере
Функция ПодключитьВнешнююОбработкуНаСервере(Знач АдресОбработки, Знач ИмяОбработки = "")
	
	ОписаниеЗащиты = Новый ОписаниеЗащитыОтОпасныхДействий();
	ОписаниеЗащиты.ПредупреждатьОбОпасныхДействиях = Ложь;
	
	Возврат ВнешниеОбработки.Подключить(АдресОбработки, ИмяОбработки, Ложь, ОписаниеЗащиты);
	
КонецФункции // ПодключитьВнешнююОбработкуНаСервере()

// Функция - проверяет тип значения на соответствие допустимым типам
//
// Параметры:
//  Значение             - Произвольный                 - проверяемое значение
//  ДопустимыеТипы       - Строка, Массив(Строка, Тип)  - список допустимых типов
//  ШаблонТекстаОшибки   - Строка                       - шаблон строки сообщения об ошибке
//                                                        ("Некорректный тип значения ""%1"" ожидается тип %2")
// 
// Возвращаемое значение:
//	Булево       - Истина - проверка прошла успешно
//
Функция ПроверитьДопустимостьТипа(Знач Значение, Знач ДопустимыеТипы, Знач ШаблонТекстаОшибки = "")
	
	ТипЗначения = ТипЗнч(Значение);
	
	Если ТипЗнч(ДопустимыеТипы) = Тип("Строка") Тогда
		МассивДопустимыхТипов = СтрРазделить(ДопустимыеТипы, ",");
	ИначеЕсли ТипЗнч(ДопустимыеТипы) = Тип("Массив") Тогда
		МассивДопустимыхТипов = ДопустимыеТипы;
	Иначе
		ВызватьИсключение СтрШаблон("Некорректно указан список допустимых типов, тип ""%1"" ожидается тип %2!",
		                            Тип(ДопустимыеТипы),
									"""Строка"" или ""Массив""");
	КонецЕсли;
	
	Типы = Новый Соответствие();
	
	СтрокаДопустимыхТипов = "";
	
	Для Каждого ТекТип Из МассивДопустимыхТипов Цикл
		ВремТип = ?(ТипЗнч(ТекТип) = Тип("Строка"), Тип(СокрЛП(ТекТип)), ТекТип);
		Типы.Вставить(ВремТип, СокрЛП(ТекТип));
		СтрокаДопустимыхТипов = СтрокаДопустимыхТипов
		                      + ?(СтрокаДопустимыхТипов = "",
							      "",
							      ?(МассивДопустимыхТипов.Найти(ТекТип) = МассивДопустимыхТипов.ВГраница(),
								    " или ",
								    ", "))
		                      + """" + СокрЛП(ТекТип) + """";
	КонецЦикла;
	
	Если ШаблонТекстаОшибки = "" Тогда
		ШаблонТекстаОшибки = "Некорректный тип значения ""%1"" ожидается тип %2!";
	КонецЕсли;
	
	Если Типы[ТипЗначения] = Неопределено Тогда
		ВызватьИсключение СтрШаблон(ШаблонТекстаОшибки, СокрЛП(ТипЗначения), СтрокаДопустимыхТипов);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПроверитьДопустимостьТипа()

// Функция - Проверить свойства
//
// Параметры:
//  ПроверяемаяСтруктура     - Структура               - проверяемая структура
//  ОбязательныеСвойства     - Строка, Массив(Строка)  - список обязательных свойств
//  ШаблонТекстаОшибки       - Строка                  - шаблон строки сообщения об ошибке
//                                                       ("Отсутствуют обязательные свойства: %1")
// 
// Возвращаемое значение:
//	Булево       - Истина - проверка прошла успешно
//
Функция ПроверитьСвойства(Знач ПроверяемаяСтруктура, Знач ОбязательныеСвойства, Знач ШаблонТекстаОшибки = "")
	
	ПроверитьДопустимостьТипа(ОбязательныеСвойства,
	                          "Строка, Массив",
	                          "Некорректно указан список обязательных свойств, тип ""%1"", ожидается тип %2!");
							  
	Если ТипЗнч(ОбязательныеСвойства) = Тип("Строка") Тогда
		МассивСвойств = СтрРазделить(ОбязательныеСвойства, ",");
	ИначеЕсли ТипЗнч(ОбязательныеСвойства) = Тип("Массив") Тогда
		МассивСвойств = ОбязательныеСвойства;
	КонецЕсли;
	
	СтрокаСвойств = "";
	
	Для Каждого ТекСвойство Из МассивСвойств Цикл
		
		Если ПроверяемаяСтруктура.Свойство(СокрЛП(ТекСвойство)) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаСвойств = СтрокаСвойств
		                      + ?(СтрокаСвойств = "", Символы.ПС, ", " + Символы.ПС)
		                      + """" + СокрЛП(ТекСвойство) + """";
	КонецЦикла;
						  
	Если ШаблонТекстаОшибки = "" Тогда
		ШаблонТекстаОшибки = "Отсутствуют обязательные свойства: %1";
	КонецЕсли;
	
	Если НЕ СтрокаСвойств = "" Тогда
		ВызватьИсключение СтрШаблон(ШаблонТекстаОшибки, СтрокаСвойств);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПроверитьСвойства()

&НаКлиенте
Функция ОбеспечитьКаталог(Знач Путь)
	
	ВремФайл = Новый Файл(Путь);
	
	Если НЕ ВремФайл.Существует() Тогда
		Если ОбеспечитьКаталог(Сред(ВремФайл.Путь, 1, СтрДлина(ВремФайл.Путь) - 1)) Тогда
			СоздатьКаталог(Путь);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ВремФайл.ЭтоКаталог() Тогда
		ВызватьИсключение СтрШаблон("По указанному пути ""%1"" не удалось создать каталог", Путь);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ОбеспечитьКаталог()

#КонецОбласти
