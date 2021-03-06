# Разработка дополнений (плагинов) для приложения "Медиацентр" на языке Python

Совместимо с версией приложения 0.3.3 и выше.

## Содержание

1. [Общие сведения](#1-общие-сведения)
2. [Конфигурационный файл](#2-конфигурационный-файл)
3. [Основной модуль](#3-основной-модуль)
4. [Вспомогательный модуль](#4-вспомогательный-модуль)
5. [Формирование ответа на запрос пользователя](#5-формирование-ответа-на-запрос-пользователя)
6. [Формирование информации об элементе списка или телепрограммы EPG](#6-формирование-информации-об-элементе-списка-или-телепрограммы-epg)
7. [Список дополнительных модулей Python](#7-список-дополнительных-модулей-python)
8. <a href="https://github.com/mediacenter-docs/mediacenter-docs.github.io/tree/master/python/rssfeed" target="_blank">Пример дополнения "Лента новостей</a>

## 1. Общие сведения

Дополнение представляет собой **ZIP** архив (упакованный стандартным способом, режим сжатия – ***deflate***) с расширением `.IMC.zip`, который содержит следующие файлы:

- `addon.xml` (обязателен) – [конфигурационный файл](#2-конфигурационный-файл)
- `addon.py` (обязателен) – [основной модуль](#3-основной-модуль)
- `icon.png` (необязателен) – иконка дополнения

Также архив может содержать дополнительные модули и изображения. Дополнение загружается в память при открытии архива или внутренней ссылки и выгружается при выходе из приложения. Взаимодействие между пользователем и дополнением происходит на основе принципа запрос - ответ.

Конфигурационный файл, модули и возвращаемые дополнением данные должны быть в кодировке **UTF-8 (без BOM)**.

Модули содержат текст программы на языке Python (CPython 3.7), подробнее можно прочитать [здесь](https://docs.python.org/3.7/).

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#1-общие-сведения)

## 2. Конфигурационный файл

Конфигурационный файл представляет собой XML документ следующего вида:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<addon>
<id><!-- уникальный идентификатор дополнения (только латинские буквы, точки, тире и цифры) --></id>

<!-- заголовок дополнения -->
<label>@string/label</label>

<!-- Использование дополнительных модулей (см. раздел 7) -->
<dependencies>
  <!-- Пример подключения модуля requests последней доступной версии -->
  <module name="requests" />

  <!-- Пример подключения модуля beautifulsoup4 версии 4.9.0 -->
  <module name="beautifulsoup4" version="4.9.0" />
</dependencies>

<!--
  Добавление обработчика системных событий, в контейнере указывается вызываемая функция.
  В функцию передается аргумент args (`dict`) c параметром 'type', который принимает следующие значения:
    'setting' - изменилась настройка (параметр 'name' - имя настройки),
    'media' - подключение или отключение локального диска (параметр 'action': 'mounted' - подключение, 'unmounted' - отключение),
    'connect' - подключение к сети
    'disconnect' – отключение от сети
-->
<handler>event</handler>

<!-- Настройки дополнения -->
<settings>
  <!-- Текстовое поле -->
  <setting name="username" label="@string/username" type="text" summary="My description" />
  <!-- где:
      name - идентификатор настройки,
      label – заголовок,
      type – тип (значения: text – строка, password – скрытая строка, list – значение из списка, bool - флажок),
      summary - описание (необязателен)
  -->

  <!-- Скрытый текст -->
  <setting name="password" label="@string/password" type="password" />
  <setting name="password" label="@string/password" type="password" encrypted="true" />
  <!-- где:
      encrypted (только для типов text и password) – хранить значение в зашифрованном виде
  -->

  <!-- Выбор из списка -->
  <setting name="quality " label="@string/quality" type="list" entries="@array/quali_entries" values="@array/quali_values" />
  <!-- где:
      entries – ссылка на массив строк (заголовки),
      values – ссылка на массив строк (значения)
  -->

  <!-- Флажок -->
  <setting name="use" label="My title" type="bool" summary="My description" />

  <!-- Флажок с запрашиванием разрешения автозапуска при старте -->
  <setting name="use" label="My title" type="bool" summary="My description" uses="boot" />
</settings>

<strings>
<!-- содержит строки и списки строк на базовом языке -->

  <!-- пример строк -->
  <string name="label">My Label</string>
  <string name="username">Username</string>
  <string name="password">Password</string>
  <string name="quality">Quality video</string>

  <!-- пример списка строк -->
  <string-array name="quali_entries">
    <item>High quality</item>
    <item>Medium quality</item>
    <item>Low quality</item>
  </string-array>

  <string-array name="quali_values">
    <item>high</item>
    <item>medium</item>
    <item>low</item>
  </string-array>

<!-- где: name - идентификатор строки или списка строк.
  Элементы настроек и заголовок могут ссылаться на строки и списка строк по идентификатору:
  ссылка на строку – @string/идентификатор
  ссылка на список строк – @array/идентификатор
 -->
</strings>

<!-- Для добавления строк и списка строк на языке локализации
	необходимо добавить контейнер <strings-[lang]>...</strings-[lang]>,
	где [lang] - кодовое обозначение языка по стандарту ISO 639-1 (например: en – английский, ru – русский, de – немецкий).
	заполнение <strings-[lang]>...</strings-[lang]> осуществляется аналогично <strings>...</strings>
 -->

 <!-- пример строк и списка строк на русском языке -->
 <strings-ru>
  <string name="label">Мой заголовок</string>
  <string name="username">Пользователь</string>
  <string name="password">Пароль</string>
  <string name="quality">Качество видео</string>

  <string-array name="quali_entries">
    <item>Высокое качество</item>
    <item>Среднее качество</item>
    <item>Низкое качество</item>
  </string-array>

  <string-array name="quali_values">
    <item>high</item>
    <item>medium</item>
    <item>low</item>
  </string-array>
</strings-ru>

</addon>
```

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#2-конфигурационный-файл)

## 3. Основной модуль

```python
# Импортируем идентификатор дополнения и функцию генерации внутренней ссылки из вспомогательного модуля (см. раздел 4)
from imc import __imcident__, url_for

# Функция, вызываемая при выгрузке дополнения (может отсутствовать)
def unload():
  pass

# Функция формирования ответа пользователю при открытии начальной страницы
# args - аргументы переданные во внутренней ссылке (тип dict)
def main(args):
  # Инициализируем возвращаемые данные с просмотром в виде простого списка
  t = {'view' : 'simple'}

  # Инициализируем список элементов
  t['items'] = items = []

  # Добавим пункт "Показать сообщение" с вызовом функции message
  items.append({'title' : 'Показать сообщение', 'url' : url_for('message')})

  # Добавим пункт "Показать сообщение об ошибке" с вызовом функции error
  items.append({'title' : 'Показать сообщение об ошибке', 'url' : url_for('error')})

  # Вернем результат пользователю
  return t

# Показать сообщение пользователю
def message(args):
  return {'view' : 'message', 'message' : 'Текст сообщения от %s' % __imcident__}

# Показать сообщение об ошибке пользователю
def error(args):
  return {'view' : 'error', 'message' : 'Текст ошибки'}
```

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#3-основной-модуль)

## 4. Вспомогательный модуль

Для получения дополнительной информации и взаимодействия с приложением реализован вспомогательный модуль `imc`.

```python
# Импорт всех значений и функций из вспомогательного модуля
from imc import *

# Идентификатор дополнения, указанный в конфигурационном файле
__imcident__

# Местонахождение дополнения
__imcpackage__

# Версия приложения
__imcversion__

# Номер сборки приложения
__imcbuild__

# Модель устройства
__imcdevice__

# Операционная система
__imcos__

# Версия операционной системы
__imcosver__

# Язык системы по стандарту ISO 639-1
__imclanguage__

# Страна по стандарту ISO 3166-1 alpha-2
__imccountry__

# Флаг запуска в режиме отладки
__imcdebug__

# Получить строку по идентификатору на языке системы
# См. <string name="quality">...</string> в конфигурационном файле
get_str('quality')

# Получить список строк по идентификатору на языке системы
# См. <string-array name="qualities">...</string-array> в конфигурационном файле
get_array('qualities')

# Получить строку по тегу из конфигурационного файла
# См. <label>...</label> в конфигурационном файле
get_tag('label')

# Получить значение (`str` или `None`) настройки
get_setting('username')

# Установить значение (`str` или `None`) настройки
set_setting('password', 'my password here')

# Установить значение настройки в зашифрованном виде (не будет доступен другим дополнениям)
set_setting('password', 'my password here', True)

# Получить значение (`str` или `None`) системной настройки
# Доступные системные настройки:
#   'udpxy' - использовать udpxy при просмотре IPTV multicast
#   'udpxy_server' - адрес сервера udpxy
#   'udpxy_port' - порт сервера udpxy
#   'tv' - использовать автоматическую загрузку телепрограммы
#   'source' - ссылка на источник телепрограммы
#   'timezone' - часовой пояс телепрограммы
#   'store' - количество дней хранения программы передач, где 'unlimited' - неограничено
#   'videoplayer' - проигрыватель видео: 'internal' - встроенный, 'lite' - встроенный (облегченная версия) (>=0.3.4), 'mxplayer' - MX Player, 'system' - по выбору системы
#   'streamplayer' - проигрыватель видео трансляций и IPTV: 'internal' - встроенный, 'lite' - встроенный (облегченная версия) (>=0.3.4), 'mxplayer' - MX Player, 'system' - по выбору системы
#   'surface' - использовать расширенное масштабирование
#   'scaling' - масштабирование видео: 'stretch' - растягивать, 'fit' - оригинальное соотношение сторон, 'crop' - растягивание и обрезание по высоте
#   'resumeplay' - использовать возобновление просмотра
#   'resume_limit' - не сохранять время остановки для видео меньше (мин.)
#   'highlighted' - подсвечивать текст просмотренного видео
#   'quality' - качество видео (по умолчанию)
#   'advanced' - использовать расширенную поддержку источников
#   'demo' - использовать автовоспроизведение контента из папки ICONBIT_PLAY
#   'photo_interval' - время просмотра фото (секунд)
#   'random' - воспроизводить контент из папки ICONBIT_PLAY в случайном порядке
#   'webserver' - использовать Web интерфейс
#   'webserver_port' - порт Web интерфейса
#   'services' - загружать список интернет сервисов с сервера
#   'update' - проверять наличие обновления при запуске приложения
#   'auto_app' - запускать приложение при загрузки системы: 'disable' - не использовать, 'iptv' - IPTV, 'application' - Медиацентр, 'filemanager' - Проводник

# Cистемные настройки начиная с (>=0.3.4):
#	'dvdplayer' - проигрыватель DVD / Blu-ray образов: 'internal' - встроенный, 'system' - по выбору системы
#	'audioplayer' - аудиоплеер: 'internal' - встроенный, 'system' - по выбору системы
#	'pictureviewer' - просмотр фото: 'internal' - встроенный, 'system' - по выбору системы
#	'textviewer' - просмотр тестовых файлов: 'internal' - встроенный, 'system' - по выбору системы
#	'process_subdirectories' - Обрабатывать подкаталоги при последовательном воспроизведении
#	'subtitles_autoload' - автоматически загружать внешние субтитры
#	'subtitles_size' - размер текста субтитров
#	'subtitles_color' - цвет текста субтитров
#	'subtitles_background' - отображать фон субтитров
#	'subtitles_bold' - полужирные субтитры
#	'subtitle_text_encoding' - кодировка текста субтитров
#	'opengl' - использование OpenGL ES2: auto, on, off
#	'chroma_format' - принудительный формат цветности: RV32, RV16, YV12
#	'enable_frame_skip' - пропуск кадров
#	'file_caching' - кэш файлов (мс)
#	'network_caching' - кэш сетевых данных (мс)
#	'display_stats' - выводить отладочную информацию
get_sys_setting('source')

# Получить значение (`str` или `None`) настройки другого дополнения
# Для указания имени настройки используется следующий формат '[Идентификатор дополнения]_[Имя настройки]'
get_sys_setting('tvigle_quality')

# Отправить сообщение пользователю
notify('Загрузка телепрограммы, пожалуйста подождите...')

# Отправить сообщение об ошибке пользователю
notify_error('Невозможно загрузить телепрограмму, проверьте подключение к сети!')

# Получить список аккаунтов по типу, зарегистрированных в системе
get_accounts('com.google')

# Записать сообщение в лог журнал
log('...')

# Получить внутреннюю ссылку
# Первый аргумент - имя функция основного модуля, которая вызывается при открытии ссылки (по выбору разработчика).
# Второй аргумент (необязателен) - args (`dict`), передаваемый в функцию (см. main в основном модуле). Значения преобразуются в `str`
# args может содержать поле '__type__', который определяет тип контента (не влияет на открытие ссылки):
#   'folder' – каталог
#   'playlist' – плейлист
#   'stream' – ссылка на онлайн ТВ
#   'video' – ссылка на видео файл
#   'audio' – ссылка на аудио файл / интернет-радио
url_for('genres')
url_for('genre', {'id' : 5037})
url_for('video', {'__type__' : 'video', 'id' : 'breaking_bad'})

# Получить внутреннюю ссылку на функцию main
url_for({'id' : 5037})

# Получить ссылку на файл изображения в архиве дополнения
get_image('icon.png')
get_image('images/genres.png')

# Получить мета ссылку для получения дополнительной информации об элементе или телепрограммы
# Аргументы аналогично url_for
meta_for('get_epg', {'channel_id' : 41})

# Получить мета ссылку для использования встроенной поддержки телепрограммы в формате JTV
meta_for({'url' : 'http://www.teleguide.info/download/new3/jtv.zip', 'name' : 'Bridge', 'shift' : 4})
# где:
#   'url' - источник телепрограммы (ссылка на архив)
#   'name' - название телеканала (точное названия можно указать в параметре 'id')
#   'shift' - часовой пояс телеканала

# Получить мета ссылку для использования встроенной поддержки телепрограммы в формате XMLTV / MediaPortal
meta_for({'url' : 'https://iptvx.one/epg/epg.xml.gz', 'name' : 'Bridge'})

# Получить список сетевых интерфейсов
get_ifs()
# где элемент списка `dict` содержит:
#   'name' - Идентификатор (строка)
#   'addr' - IP адрес (строка)
#   'hwaddr' - MAC адрес (строка)
#   'bitmask' - Маска подсети (число)
#   'loopback' - Это обратная петля (булево)
#   'private' - Это частная сеть (булево)
#   'connected' - Соединение установлено (булево)
#   'wireless' - Это беспроводная сеть (булево)

# Получить список установленных приложений
get_apps()
# где элемент списка `dict` содержит:
#   'title' - Заголовок на языке системы (строка)
#   'url' - адрес для запуска (строка)

# Получить список локальных дисков
get_drives()
# где элемент списка `dict` содержит:
#   'type' - тип диска ('sdcard', 'hdd', 'usb')
#   'name' - имя (строка)
#   'device' - устройство (строка)
#   'path' - путь (строка)
#   'fs' - файловая система (строка)
#   'size' - размер диска в байтах (число)
#   'free' - свободно на диске в байтах (число)

```

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#4-вспомогательный-модуль)

## 5. Формирование ответа на запрос пользователя

### Показать сообщение

```python
return {
  'view' : 'message',
  'message' : 'Текст сообщения'
}
```

### Показать сообщение об ошибке

```python
return {
  'view' : 'error',
  'message' : 'Текст ошибки'
}
```

### Открыть диалог ввода строки

```python
return {
  'view' : 'keyword',
  'message' : 'Текст подсказки (необязателен)',
  'keyword' : 'Строка по умолчанию (необязателен)'
}
```

При вводе пользователем происходит переход по текущей ссылке, где аргумент **keyword** заменяется (добавляется) введенным значением.

### Открыть диалог ввода пользователя и пароля

```python
return {
  'view' : 'login',
  'message' : 'Текст подсказки (необязателен)',
  'error' : 'Текст ошибки (необязателен)',
  'username' : 'Пользователь по умолчанию (необязателен)',
  'password' : 'Пароль по умолчанию (необязателен)'
}
```

При вводе пользователем происходит переход по текущей ссылке, где аргументы **username** и **password** заменяются (добавляются) введенными значениями.

### Открыть диалог выбора учетной записи для получения токена, зарегистрированной в системе

```python
return {
  'view' : 'token',
  'scope' : 'права',
  'type' : 'Тип учетной записи (например com.google)',
  'username' : 'Пользователь по умолчанию (необязателен)'
}
```

При выборе пользователем происходит переход по текущей ссылке, которая содержит аргумент **token**.

### Открыть настройки дополнения

```python
return {'view' : 'setup'}
```

### Обновить текущий список

```python
return {'view' : 'refresh'}
```

### Вернуться на предыдущую страницу

```python
return {'view' : 'back'}
```

### Открыть список элементов

```python
return {
  # Вид просмотра списка
  'view' : 'grid',
  # где 'view':
  #   'simple' – простой список (маленькая иконка и заголовок)
  #   'list' – список (иконка, заголовок, описание и индикатор передачи)
  #   'grid' – значки с заголовком
  #   'tube' – стоп-кадр с заголовками
  #   'posters' – иконки в виде обложек фильмов
  #   'annotation' – страница с описанием контента
  #   'select' – выбор из всплывающего списка

  # Тип контента (необязателен)
  'type' : 'folder',
  # где 'type':
  #   'folder' – каталог (рекомендуется указывать когда в списке элементов может быть только один элемент)
  #   'playlist' – плейлист (если в плейлисте только один элемент то происходит автоматический переход по ссылке элемента)
    
  # Отображать панель подробной информации (необязателен) (>= 0.3.4)
  'detailed' : True,

  # Текст подсказки, отображаемый над списком элементов (необязателен)
  'message' : '...',
  
  # Идентификатор для сохранения вида просмотра список / иконки с сохранением состояния (необязателен)
  # Рекомендуется указывать для плейлистов IPTV
  'typeable' : 'edem',

  # Доступен ли выбор фильтра по типу элементов списка (необязателен)
  # Рекомендуется указывать для списка файлов разных типов
  'filterable' : True,

  # Определяет обновление страницы при наступлении системных событий (необязателен)
  'actions' : 'media',
  # где 'actions':
  #   'media' – подключение / отключение носителя информации
  #   'package' – установка / удаление приложения
  #   'connect' – подключение к сети
  #   'disconnect' – отключение от сети

  # Название, отображается на странице с описанием контента (необязателен)
  'title' : 'Mission impossible',

  # Ссылка на изображение постера на странице с описанием контента (необязателен)
  'poster' : 'http://...',

  # Сюжет, отображается на странице с описанием контента (необязателен)
  'description' : '...',

  # Список характеристик, отображается на странице с описанием контента (необязателен)
  'annotation' : ['Жанр: Боевик', 'Год выпуска: 2012', '...'],

  # Меню быстрого вызова, отображаемый в правой стороне над списком элементов (необязателен)
  'menu' : [
    {
      # Заголовок
      'title' : 'Жанры',

      # Ссылка
      'url' : url_for('genres'),

      # Ссылка на иконку (необязателен)
      'icon' : get_image('genres.png'),

      # Тип контента для ускорения запуска просмотра (необязателен)
      'type' : 'video'
      # где 'type': 'video' - видео файл, 'stream' - онлайн трансляция, 'audio' - аудио файл (интернет-радио), 'photo' - файл картинки (>=0.3.4), 'text' - текстовый файл (>=0.3.4)
    }
  ],

  # Список элементов
  'items' : [
    {
      # Заголовок
      'title' : 'Планета обезьян',

      # Ссылка
      'url' : 'http://server.com/video/appes.mp4',

      # Ссылка на иконку (необязателен)
      'icon' : 'http://server.com/images/appes.jpg',

      # Тип контента для ускорения запуска просмотра (необязателен)
      'type' : 'video',
      # где 'type': 'video' - видео файл, 'stream' - онлайн трансляция, 'audio' - аудио файл (интернет-радио), 'photo' - файл картинки (>=0.3.4), 'text' - текстовый файл (>=0.3.4)

      # Описание (необязателен)
      'annotation' : '...',
      # или
      'annotation' : ['...', '...', '...'],

      # Группа или категория (необязателен)
      'group' : 'Кино',

      # Меню элемента списка (необязателен)
      # Отображается в всплывающем диалоге при долгом нажатии кнопки выбора
      # Структура аналогична меню быстрого вызова
      'menu' : [],

      # Внутренняя ссылка для получения дополнительной информации об элементе списка или телепрограммы (необязателен)
      'meta' : meta_for('get_epg', {'id' : 'appes'}),
      # или для использования встроенного механизма
      'meta' : meta_for({'url' : 'https://iptvx.one/epg/epg.xml.gz', 'name' : 'Bridge'})

      # Размер файла или устройства хранения в байтах, отображается при просмотре в виде списка (необязателен)
      'size' : 1024523535,

      # Размер свободного пространства в байтах, отображается при просмотре в виде списка (необязателен)
      'free' : 0,

      # Время отступа в секундах (необязателен)
      # Предназначен для формирования аудио плейлистов для разбивки файла по трекам
      'start' : 0,
        
      # Продолжительность в секундах (необязателен) (>=0.3.4)
  	  'duration' : 0,

      # Качество видео, используется для всплывающего списка (необязателен)
      'quality' : '720P',

      # HTTP заголовки, передаваемые при открытии ссылки (необязателен)
      'headers' : {'User-Agent' : 'Monkey'},

      # Шаблон ссылки для просмотра архива телеканала (необязателен)
      # Доступные параметры:
      #   {utc} или {start} – время начала в unix timestamp
      #   {lutc} – время завершения в unix timestamp
      #   {offset} – отклонение от текущей даты в секундах
      #   {timestamp} – текущее время в unix timestamp
      # например:
      'catchup-source' : '?utc={utc}&lutc={lutc}',
      'catchup-source' : '?begin=${start}&now=${timestamp}',
      # или
      'catchup-source' : '?offset=-{offset}',

      # Количество дней за который доступен просмотр архива (необязателен)
      'catchup-days' : 4,
        
      # Подключение внешних субтитров или звуковых дорожек (необязателен) (>=0.3.4)
      # Примечание: работает только при просмотре в встроенном плеере.
      slaves = [
         {'type' : 'subtitle', 'url' : '...'},
         {'type' : 'audio', 'url' : '...'},
      ],
        
      # Отображать подробное описание элемента (необязателен) (>=0.3.4)
  	  'detailed' : True,
    }
  ]
}
```

### Открыть просмотр в режиме управляемого воспроизведения

```python
return {
  'view' : 'playback',

  # Заголовок видео (необязателен)
  'title' : 'Планета обезьян',

  # Ссылка на видео
  'url' : 'http://server.com/video/appes.mp4',

  # Внутренняя cсылка для запроса предыдущего видео (необязателен)
  'previous' : url_for('video', {'id' : 4571}),

  # Внутренняя cсылка для запроса следующего видео (необязателен)
  'next' : url_for('video', {'id' : 8517}),

  # Внутренняя cсылка оповещения о состоянии воспроизведения (необязателен)
  # В указанный метод обработки оповещения передается dict со следующими параметрами:
  #   'action' - событие: 'got' - видео готово к воспроизведению, 'watched' - видео просмотрено, 'update' - обновление информации (каждые 1000мс)
  #   'time' - время воспроизведения в секундах
  #   'percent' - процент просмотренного видео
  #   'duration' - продолжительность видео в секундах
  'event' : url_for('event', {'video_id' : 7544}),

  # Доступно позиционирование и переход к следующему видео (необязателен)
  'seekable' : True,  # По умолчанию - False

  # Ссылка 'url' является прямой ссылкой на видео (необязателен)
  'direct' : True,  # По умолчанию - False

  # HTTP заголовки, передаваемые при открытии 'url' ссылки (необязателен)
  'headers' : {'User-Agent' : 'Monkey'}
}
```

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#5-формирование-ответа-на-запрос-пользователя)

## 6. Формирование информации об элементе списка или телепрограммы EPG

При вызове функции в аргументе **args** передается ключевой параметр `'type'`, который может принимать следующие значения:

- `'annotation'` - запрос информации об элементе списка
- `'EPG'` - запрос на получение cписка телепередач EPG

Рассмотрим формирование результата на примере с комментариями:

```python
# См. 'meta' : meta_for('get_epg', {'id' : 'appes'}) в описании элемента списка
def get_epg(args):
  if args['type'] == 'EPG':
    # Список телепередач
    return [
      {
        'title' : 'Новости',    # Название
        'begin' : 1234324,      # Время начала в формате unix timestamp
        'end' : 1234524,        # Время завершения в формате unix timestamp (необязателен)
        'annotation' : '...',   # Описание (необязателен)
        'group' : 'Новости',    # Категория (необязателен)
        'url' : '...'           # Прямая ссылка на видео файл для просмотра архива телеканала (необязателен)
      }
    ]
  else:
    # Возврат информации об элементе (телеканале).
    # Обязательно для заполнения только одно поле
    return {
      'title' : 'Новости',    # Название
      'annotation' : '...',   # Описание
      'icon' : 'http://...',  # Ссылка на икону
      'group' : 'Новости',    # Группа
      'size' : 123,           # Размер в байтах
      'free' : 0,             # Размер свободного пространства в байтах
      'start' : 0,		  	  # Время отступа в секундах (необязателен) (>=0.3.4)  
  	  'duration' : 0,		  # Продолжительность в секундах (необязателен) (>=0.3.4)
      'begin' : 1234324,      # Время начала текущей передачи в unix timestamp (необязателен)
      'end' : 1234524,        # Время завершения текущей передачи в unix timestamp (необязателен)
    }
```

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#6-формирование-информации-об-элементе-списка-или-телепрограммы-epg)

## 7. Список дополнительных модулей Python

Кроме предустановленной библиотеки `Cryptodome` разработчик может использовать дополнительные модули подключив их к проекту (см. [конфигурационный файл](#2-конфигурационный-файл)). Список дополнительных модулей:

- `certifi` - 2020.4.5.1
- `chardet` - 3.0.4
- `idna` - 2.9
- `urllib3` - 1.25.9
- `requests` - 2.23.0
- `requests-cache` - 0.5.2
- `six` - 1.14.0
- `webencodings` - 0.5.1
- `Genshi` - 0.7.3
- `html5lib` - 1.0.1
- `soupsieve` - 2.0
- `beautifulsoup4` - 4.9.0
- `geographiclib` - 1.50
- `geopy` - 1.21.0
- `httplib2` - 0.17.3
- `oauth2` - 1.9.0.post1
- `tvdb_api` - 2.0
- `xmltodict` - 0.12.0
- `shoutcast-api` - 1.0.6
- `websocket_client` - 0.57.0
- `vk_api` - 11.8.0

[Вернуться к содержанию](#содержание) | [Вернуться в начало раздела](#7-список-дополнительных-модулей-python)