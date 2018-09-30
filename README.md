﻿# 1C Serialization Library
## Библиотека сериализации 1С (обработка)

Набор процедур и функций для сериализации/десериализации данных 1С и объектов СКД в простые структуры данных (Структура, соответствие, массив).

Варианты использования:
- замена платформенных функций сериализации, например, при сохранении версий объектов
- передача данных по протоколу HTTP
- основа для простых обработок обмена данными
- основа для получения отчетов из внешних ИБ 1С

Особенности:
- разработка ведется в формате EDT
- процедуры/функции поддерживают ограничение состава полей
- табличные части преобразуются в служебный элемент структуры с ключом "__ТЧ"
- при десериализации приоритетными являются метаданные, т.е. не возникает ошибок при изменении структуры данных конфигурации
- поддерживается возможность назначения процедур дополнения ссылочных данных при выгрузке
- поддерживается возможность переопределения функций поиска ссылочных данных

Особенности преобразования объектов СКД:
1. ПутьКДанным пользовательских полей СКД формируется системой автоматически, поэтому:
	- после загрузки СКД значение может отличаться на номер поля
	- если в исходной СКД значение было на языке, отличном от языка целевой, то новое значение будет на языке целевой СКД
2. Поле "Обязательное" роли поля набора данных сейчас устанавливается принудительно, хотя в документации отмечено как "Только чтение" (EDT тоже ругается)
3. Поле "Схема" вложенной схемы компоновки данных при добавлении имеет тип неопределено и принудительно устанавливается значение "Новый СхемаКомпоновкиДанных()", хотя в документации отмечено как "Только чтение" (EDT тоже ругается)
4. В исходных настройках СКД в полях ТипЗначения составного типа могут встречаться дубли типов <БизнесПроцесс....> при загрузке дубли схлопываются
5. В исходных настройках СКД иногда встречается некорректный тип элементов свойства "ПараметрыДанных" объекта "НастройкиКомпоновкиДанных", вместо "ЗначениеПараметраНастроекКомпоновкиДанных" используется "ЗначениеПараметраКомпоновкиДанных". После выгрузки загрузки СКД, все эелементы поля "ПараметрыДанных" будут приведены к типу "ЗначениеПараметраНастроекКомпоновкиДанных".
6. Если в исходных настройках поле типа "Дата" имеет значение Неопределено, то при загрузке будет установлена пустая дата
7. Если в исходных настройках поле типа "Строка" имеет значение Неопределено, то при загрузке будет установлена пустая строка
8. Не заполняется поле "Идентификатор" в элементах структуры настроек (Группировки, Таблицы, Диаграммы), т.к. имеет признак "Только чтение", а автоматического присвоения значения не происходит. Влияние на работоспособность СКД пока не проверялось.

