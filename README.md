﻿# 1C Serialization Library

<a href="https://checkbsl.org"><img alt="Checked by Silver Bulleters SonarQube BSL plugin" src="https://web-files.do.bit-erp.ru/sonar/b_t.png" align="right" style="width:400px"/></a>

[![GitHub release](https://img.shields.io/github/release/ArKuznetsov/SerLib1C.svg?style=flat-square)](https://github.com/ArKuznetsov/SerLib1C/releases)
[![GitHub license](https://img.shields.io/github/license/ArKuznetsov/SerLib1C.svg?style=flat-square)](https://github.com/ArKuznetsov/SerLib1C/blob/develop/LICENSE)
[![GitHub Releases](https://img.shields.io/github/downloads/ArKuznetsov/SerLib1C/latest/total?style=flat-square)](https://github.comArKuznetsov/SerLib1C/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/ArKuznetsov/SerLib1C/total?style=flat-square)](https://github.com/ArKuznetsov/SerLib1C/releases)

[![Build Status](https://img.shields.io/github/workflow/status/ArKuznetsov/SerLib1C/%D0%9A%D0%BE%D0%BD%D1%82%D1%80%D0%BE%D0%BB%D1%8C%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B0)](https://github.com/arkuznetsov/yard/actions/)
[![Quality Gate](https://open.checkbsl.org/api/project_badges/measure?project=SerLib1C&metric=alert_status)](https://open.checkbsl.org/dashboard/index/SerLib1C)
[![Coverage](https://open.checkbsl.org/api/project_badges/measure?project=SerLib1C&metric=coverage)](https://open.checkbsl.org/dashboard/index/SerLib1C)
[![Tech debt](https://open.checkbsl.org/api/project_badges/measure?project=SerLib1C&metric=sqale_index)](https://open.checkbsl.org/dashboard/index/SerLib1C)

## Библиотека сериализации 1С (обработка)

Набор процедур и функций для сериализации/десериализации данных 1С и объектов СКД в простые структуры данных (Структура, соответствие, массив).

### Варианты использования

- замена платформенных функций сериализации, например, при сохранении версий объектов
- передача данных по протоколу HTTP
- основа для простых обработок обмена данными
- основа для получения отчетов из внешних ИБ 1С

### Особенности

- разработка ведется в формате EDT
- процедуры/функции поддерживают ограничение состава полей
- табличные части преобразуются в служебный элемент структуры с ключом "__ТЧ"
- при десериализации приоритетными являются метаданные, т.е. не возникает ошибок при изменении структуры данных конфигурации
- поддерживается возможность назначения процедур дополнения ссылочных данных при выгрузке
- поддерживается возможность переопределения функций поиска ссылочных данных

### Особенности преобразования объектов СКД

1. ПутьКДанным пользовательских полей СКД формируется системой автоматически, поэтому:

   - после загрузки СКД значение может отличаться на номер поля
   - если в исходной СКД значение было на языке, отличном от языка целевой, то новое значение будет на языке целевой СКД

2. Поле "Обязательное" роли поля набора данных сейчас устанавливается принудительно, хотя в документации отмечено как "Только чтение" (EDT тоже ругается)
3. Поле "Схема" вложенной схемы компоновки данных при добавлении имеет тип неопределено и принудительно устанавливается значение "Новый СхемаКомпоновкиДанных()", хотя в документации отмечено как "Только чтение" (EDT тоже ругается)
4. В исходных настройках СКД в полях ТипЗначения составного типа могут встречаться дубли типов <БизнесПроцесс....> при загрузке дубли схлопываются
5. В исходных настройках СКД иногда встречается некорректный тип элементов свойства "ПараметрыДанных" объекта "НастройкиКомпоновкиДанных", вместо "ЗначениеПараметраНастроекКомпоновкиДанных" используется "ЗначениеПараметраКомпоновкиДанных". После выгрузки загрузки СКД, все элементы поля "ПараметрыДанных" будут приведены к типу "ЗначениеПараметраНастроекКомпоновкиДанных".
6. Если в исходных настройках поле типа "Дата" имеет значение Неопределено, то при загрузке будет установлена пустая дата
7. Если в исходных настройках поле типа "Строка" имеет значение Неопределено, то при загрузке будет установлена пустая строка
8. Не заполняется поле "Идентификатор" в элементах структуры настроек (Группировки, Таблицы, Диаграммы), т.к. имеет признак "Только чтение", а автоматического присвоения значения не происходит. Влияние на работоспособность СКД пока не проверялось.

### Методы преобразования прикладных объектов 1С

#### Общие методы

- ОбъектВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- ЗаполнитьОбъектИзСтруктуры(Объект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства)
- СоздатьОбъектИзСтруктуры(СтруктураОбъекта, УстановитьСсылку, СписокСвойств, ИсключаяСвойства)

___

- СсылкаВСтруктуру(Значение)
- СсылкаИзСтруктуры(СтруктураЗначения)

___

- НаборЗаписейРегистраВСтруктуру(НаборЗаписей, СписокСвойств, ИсключаяСвойства)
- ЗаполнитьНаборЗаписейРегистраИзСтруктуры(НаборЗаписей, СтруктураНабораЗаписей, СписокСвойств, ИсключаяСвойства)

- СоздатьНаборЗаписейРегистраИзСтруктуры(СтруктураНабораЗаписей, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- ДвиженияДокументаВСтруктуру(Объект, СписокРегистров, ИсключаяРегистры)
- ДвиженияДокументаИзСтруктуры(Объект, СтруктураДвижений, СписокРегистров, ИсключаяРегистры)

___

- ЗначениеВСтруктуру(Значение)
- ЗначениеИзСтруктуры(СтруктураЗначения, ПолучатьБитыеСсылки)

___

#### Прикладные объекты (ссылочные)

При преобразовании ссылочных объектов могут быть использованы фильтры свойств. Используется единый набор параметров:

- **Объект** - преобразуемый/восстанавливаемый объект
- **СтруктураОбъекта** - результат преобразования / источник для восстановления
- **СписокСвойств** - список свойств, которые попадут в результат преобразования
- **ИсключаяСвойства** - список свойств, которые не будут преобразованы (приоритет выше чем у СписокСвойств)

___

- СправочникВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- СправочникИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- ПланСчетовВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- ПланСчетовИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- ПланВидовХарактеристикВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- ПланВидовХарактеристикИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- ПланВидовРасчетаВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- ПланВидовРасчетаИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- ДокументВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- ДокументИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- БизнесПроцессВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- БизнесПроцессИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- ЗадачаВСтруктуру(Объект, СписокСвойств, ИсключаяСвойства)
- ЗадачаПроцессИзСтруктуры(Объект, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

##### Дополнение ссылочных данных при выгрузке

При выгрузке ссылочных данных возможно переопределение процедуры, дополняющей содержимое описания ссылки, для этого необходимо в модуле, выполняющем выгрузку, создать процедуру вида:

```bsl

&НаСервере
Процедура МояПроцедураДополнения(ОписаниеЗначения, Значение) Экспорт
    // Код дополнения
    // ОписаниеЗначения.Вставить("КодЭлемента", Значение.Код);
КонецПроцедуры

```

где:

- ОписаниеЗначения - Структура   - Структура содержащая поля описания ссылки
- Значение         - ЛюбаяСсылка - ссылка, для которой получено описание

И перед выполнением выгрузки данных добавить обработчик дополнения ссылок

```bsl

Библиотека.ДобавитьПравилоВыгрузкиТипа("Справочник.МойСправочник", "МояПроцедураДополнения", ЭтотОбъект)

```

где:

- Библиотека - Обработка-объект библиотеки преобразования данных (этой библиотеки)

##### Переопределение поиска ссылочных данных при загрузке

При загрузке ссылочных данных возможно переопределение функции поиска ссылок, для этого необходимо в модуле, выполняющем загрузку, создать функцию вида:

```bsl

&НаСервере
Функция МояФункцияПоискаСсылок(ОписаниеВида, МетаОбъект, ОписаниеЗначения) Экспорт
    // Код поиска ссылки
    // НайденнаяСсылка = Справочники.МойЗагружаемыйСправочник.НайтиПоКоду(ОписаниеЗначения.КодЭлемента);
    // Возврат НайденнаяСсылка;
КонецФункции

```

где доступны параметры:

- ОписаниеВида     - Структура           - Структура содержащая описание вида загружаемой ссылки
- МетаОбъект       - ОписаниеМетаданных  - Описание метаданных загружаемой ссылки
- ОписаниеЗначения - Структура           - Структура содержащая поля описания искомой ссылки

И перед выполнением выгрузки данных добавить обработчик дополнения ссылок

```bsl

Библиотека.ДобавитьПравилоЗагрузкиТипа("Справочник.МойСправочник", "Справочник.МойЗагружаемыйСправочник", "МояФункцияПоискаСсылок", ЭтотОбъект)

```

где:

- Библиотека - Обработка-объект библиотеки преобразования данных (этой библиотеки)

#### Прикладные объекты (регистры)

При преобразовании регистров могут быть использованы фильтры свойств. Используется единый набор параметров:

- **НаборЗаписей** - преобразуемый/восстанавливаемый набор записей регистра
- **СтруктураОбъекта** - результат преобразования / источник для восстановления
- **СписокСвойств** - список свойств, которые попадут в результат преобразования
- **ИсключаяСвойства** - список свойств, которые не будут преобразованы (приоритет выше чем у СписокСвойств)

___

- НаборЗаписейРегистраСведенийВСтруктуру(НаборЗаписей, СписокСвойств, ИсключаяСвойства)
- НаборЗаписейРегистраСведенийИзСтруктуры(НаборЗаписей, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- НаборЗаписейРегистраНакопленияВСтруктуру(НаборЗаписей, СписокСвойств, ИсключаяСвойства)
- НаборЗаписейРегистраНакопленияИзСтруктуры(НаборЗаписей, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- НаборЗаписейРегистраБухгалтерииВСтруктуру(НаборЗаписей, СписокСвойств, ИсключаяСвойства)
- НаборЗаписейРегистраБухгалтерииИзСтруктуры(НаборЗаписей, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

- НаборЗаписейРегистраРасчетаВСтруктуру(НаборЗаписей, СписокСвойств, ИсключаяСвойства)
- НаборЗаписейРегистраРасчетаИзСтруктуры(НаборЗаписей, СтруктураОбъекта, ПолучатьБитыеСсылки, СписокСвойств, ИсключаяСвойства)

___

#### Коллекции

При преобразовании коллекций выполняется рекурсивное преобразование всех вложенных значений с использованием функций ЗначениеВСтруктуру()/ЗначениеИзСтруктуры().

- СтруктураВСтруктуру(Значение)
- СтруктураИзСтруктуры(СтруктураЗначения)

___

- МассивВСтруктуру(Значение)
- МассивИзСтруктуры(СтруктураЗначения)

___

- СоответствиеВСтруктуру(Значение)
- СоответствиеИзСтруктуры(СтруктураЗначения)

___

- СписокЗначенийВСтруктуру(Значение)
- СписокЗначенийИзСтруктуры(СтруктураЗначения)

___

- ТаблицаЗначенийВСтруктуру(Значение, СписокСвойств, ИсключаяСвойства)
- ТаблицаЗначенийИзСтруктуры(СтруктураЗначения, СписокСвойств, ИсключаяСвойства)

___

- ДеревоЗначенийВСтруктуру(Значение, СписокСвойств, ИсключаяСвойства)
- ДеревоЗначенийИзСтруктуры(СтруктураЗначения, СписокСвойств, ИсключаяСвойства)

___

### Методы преобразования данных формы

- ДанныеФормыВСтруктуру(Форма, ТолькоСохраняемые, СписокСвойств, ИсключаяСвойства)
- ДанныеФормыИзСтруктуры(Форма, СтруктураДанных, ПроверятьИмяФормы, СоздаватьРеквизиты, СписокСвойств, ИсключаяСвойства)

### Методы преобразования объектов СКД

- СКДВСтруктуру(Объект)
- СКДИзСтруктуры(Объект, СтруктураОбъекта)

___

- НастройкиСКДВСтруктуру(Объект)
- НастройкиСКДИзСтруктуры(Объект, СтруктураОбъекта)

___

### Методы чтения/записи JSON

При чтении записи JSON выполняется преобразование типов не совместимых с JSON в/из строки. Для преобразования "неизвестных" типов используется ЗначениеВСтрокуВнутр().
Значения типа "Дата" записываются/читаются в формате Microsoft.

- ЗаписатьОписаниеОбъектаВJSON(ОписаниеОбъекта)
- ПрочитатьОписаниеОбъектаИзJSON(ТекстОписанияОбъекта, СвойстваСоЗначениемДата)

___
