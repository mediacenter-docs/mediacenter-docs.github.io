# Импортируем модуль json для преобразования списка в строку и обратно
import json

# Импортируем модули для загрузки и разбора данных
import requests
import xml.etree.ElementTree as xml

# Импортируем используемые функции из вспомогательного модуля (см. раздел 4)
from imc import get_setting, set_setting, url_for, get_image

# Инициализация дополнения
_FEEDS = 'feeds'

# Получаем раннее сохраненные RSS ссылки в виде строки
value = get_setting(_FEEDS)
if value is None:
	# Если список не инициализирован заполним его значениями по умолчанию
	items = [
		'https://lenta.ru/rss',
		'http://static.feed.rbc.ru/rbc/logical/footer/news.rss',
		'http://www.vesti.ru/export/videos.rss?cid=1'
	]
else:
	# Иначе преобразуем строку в список ссылок
	items = json.loads(value)

# В качестве начальной страницы будем выводить список RSS ссылок
def main(args):
	# Инициализируем возвращаемые данные с просмотром в виде простого списка
	t = {'view' : 'simple', 'type' : 'folder'}

	# Инициализируем меню быстрого вызова
	t['menu'] = [
		# Разместим в меню кнопку 'Добавить' с вызовом функции add
		{
			'title' : '@string/add',
			'url' : url_for('add'),
			'icon' : get_image('add.png')
		}
	]

	# Инициализируем список элементов
	t['items'] = []

	# Заполним список элементов ссылками
	for url in items:
		t['items'].append({
			'title' : url,
			'url' : url_for('parse', {'url' : url}),
			'menu' : [
				# Разместим в меню элемента списка кнопку 'Удалить' с вызовом функции remove с параметром url
				{
					'title' : '@string/remove',
					'url' : url_for('remove', {'url' : url}),
					'icon' : get_image('remove.png')
				}
			]
		})

	# Вернем результат пользователю
	return t

# Добавление ссылки
def add(args):
	# Если пользователь ввел ссылку до добавим её
	if 'keyword' in args:
		items.append(args['keyword'])
		# Сохраним список ссылок в виде строки
		set_setting(_FEEDS, json.dumps(items))
		# Обновим текущий список элементов
		return {'view' : 'refresh'}

	# Если пользователь ещё не вводил ссылку то отправим запрос на ввод
	return {'view' : 'keyword', 'message' : '@string/input', 'keyword' : 'http://'}

# Удаление ссылки и обновление текущего списка элементов
def remove(args):
	items.remove(args['url'])
	# Сохраним список ссылок в виде строки
	set_setting(_FEEDS, json.dumps(items))
	# Обновим текущий список элементов
	return {'view' : 'refresh'}

# Загрузка и разбор RSS документа
#self/__func__=parse&url=http://static.feed.rbc.ru/rbc/logical/footer/news.rss
#self/__func__=parse&url=http://www.vesti.ru/export/videos.rss?cid=1
def parse(args):
	# Инициализируем возвращаемые данные с просмотром в виде видео кадров
	t = {'view' : 'tube', 'type' : 'folder'}
	
	# Инициализируем список элементов
	t['items'] = []

	# Загрузим RSS файл
	r = requests.get(args['url'])
	root = xml.fromstring(r.content)
	
	for item in root.iter('item'):
		title = item.find('title').text
		desc = (item.find('description') or item.find('title')).text
		icon = None
		url = None
		
		# Поиск медиа контента
		for enclosure in item.iter('enclosure'):
			rss_type = enclosure.get('type')
			rss_url = enclosure.get('url')
			if rss_type.startswith('image/'):
				icon = rss_url
			elif rss_type == 'video/mp4':
				url = rss_url
			elif rss_type.startswith('video/'):
				url = url or rss_url
		
		# Добавим элемент ленты
		t['items'].append({
			'title' : title,
			'url' : url or url_for('show', {'desc' : desc}),
			'icon' : icon,
			'annotation' : desc
		})
	
	# Вернем результат пользователю
	return t

# Отображение описания если нет видео
def show(args):
	return {'view' : 'message', 'message' : args['desc']}
