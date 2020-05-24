require('support')

-- Инициализация дополнения
local _FEEDS = 'feeds'

-- Получаем раннее сохраненные RSS ссылки в виде строки
local items
local value = getprop(_FEEDS)
if value then
	-- преобразуем строку в список ссылок
	items = json.decode(value)
else
	-- Если список не инициализирован заполним его значениями по умолчанию
	items = {
		'https://lenta.ru/rss',
		'http://static.feed.rbc.ru/rbc/logical/footer/news.rss',
		'http://www.vesti.ru/export/videos.rss?cid=1'
	}
end

-- Загрузка дополнения
function onLoad()
	return 1
end

function onCreate(args)
	-- В качестве начальной страницы будем выводить список RSS ссылок
	if not args['q'] then
		-- Инициализируем возвращаемые данные с просмотром в виде простого списка
		local t = {view = 'simple', type = 'folder'}
		
		-- Инициализируем меню быстрого вызова
		t['menu'] = {
			-- Разместим в меню кнопку 'Добавить'
			{
				title = '@string/add',
				mrl = '#self/q=add',
				image = '#self/add.png'
			}
		}

		-- Заполним список элементов ссылками
		for _, url in ipairs(items) do
			table.insert(t, {
				title = url,
				mrl = '#self/q=parse&url=' .. urlencode(url),
				menu = {
					-- Разместим в меню элемента списка кнопку 'Удалить'
					{
						title = '@string/remove',
						mrl = '#self/q=remove&url=' .. urlencode(url),
						image = '#self/remove.png'
					}
				}
			})
		end

		-- Вернем результат пользователю
		return t
		
	-- Добавление ссылки
	elseif args['q'] == 'add' then
		-- Если пользователь ввел ссылку до добавим её
		if args['keyword'] then
			table.insert(items, args['keyword'])
			-- Сохраним список ссылок в виде строки
			setprop(_FEEDS, json.encode(items))
			-- Обновим текущий список элементов
			return {view = 'refresh'}
		end
		-- Если пользователь ещё не вводил ссылку то отправим запрос на ввод
		return {view = 'keyword', message = '@string/input', keyword = 'http://'}
		
	-- Удаление ссылки и обновление текущего списка элементов
	elseif args['q'] == 'remove' then
		for i, url in ipairs(items) do
			if url == args['url'] then
				table.remove(items, i)
				break
			end
		end
		-- Сохраним список ссылок в виде строки
		setprop(_FEEDS, json.encode(items))
		-- Обновим текущий список элементов
		return {view = 'refresh'}
		
	-- Загрузка и разбор RSS документа
	-- #self/q=parse&url=http://static.feed.rbc.ru/rbc/logical/footer/news.rss
	-- #self/q=parse&url=http://www.vesti.ru/export/videos.rss?cid=1
	elseif args['q'] == 'parse' then
		-- Инициализируем возвращаемые данные с просмотром в виде видео кадров
		local t = {view = 'grid_large', type = 'folder'}

		-- Загрузим RSS файл
		local x = xml.load(args['url'])
		if x then
			-- Заполним элементы
			for i = 1, x:count('rss', 'channel', 'item') do
				local title = x:value('rss', 'channel', 'item', i, 'title')
				local desc = x:value('rss', 'channel', 'item', i, 'description') or title
				local image
				local url
				
				-- Поиск медиа контента
				for j = 1, x:count('rss', 'channel', 'item', i, 'enclosure') do
					local rss_type = x:attribute('rss', 'channel', 'item', i, 'enclosure', j, 'type')
					local rss_url = x:attribute('rss', 'channel', 'item', i, 'enclosure', j, 'url')
					if rss_type and rss_url then
						if string.find(rss_type, 'image/') then
							image = rss_url
						elseif rss_type == 'video/mp4' then
							url = rss_url
						elseif string.find(rss_type, 'video/') then
							url = url or rss_url
						end
					end
				end
				
				-- Добавим элемент ленты
				table.insert(t, {
					title = title,
					mrl = url or '#self/q=show&desc=' .. urlencode(desc),
					image = image,
					annotation = desc
				})
			end
		end

		-- Вернем результат пользователю
		return t
	
	-- Отображение описания если нет видео
	elseif args['q'] == 'show' then
		return {view = 'message', message = args['desc']}
	end

end
