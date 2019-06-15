
local clk = os.clock()
local common = loadfile(_CM_DIR .. 'cm_common.lua')
hc.set_global('CM_COMMON', string.dump(common))
common()

-- Создаем необходимые для работы папки правил и лога, если их еще нет
hc.shell_execute('cmd', '/C (for %i in (AdBlockPlus AdMuncher ContentMaster HandyCache) do (md rules\\local\\%i rules\\remote\\%i))&&(md log)', _CM_DIR, 'SW_HIDE', true)

_CM_OPTIONS = {}

_CM_OPTIONS.SystemCoding = os.setlocale('', 'all'):match('.*%D(%d+)')	-- устанавливаем локаль СМ в текущую локаль системы, на которой запущен СМ, и узнаем,
_CM_OPTIONS.SystemCoding = _CM_OPTIONS.SystemCoding and tonumber(_CM_OPTIONS.SystemCoding)	--  что это за локаль (последние цифры - кодовая страница)
_CM_OPTIONS.LanguageID = _CM_OPTIONS.LanguageID or hc.language_id	-- если язык СМ явно не задан, то используем язык интерфейса НС
-- hc.put_to_log('_CM_OPTIONS.SystemCoding = ', _CM_OPTIONS.SystemCoding, '\r\n_CM_OPTIONS.LanguageID = ', _CM_OPTIONS.LanguageID)

-- подгружаем скрипт интерактивного режима
hc.set_global_table_item('CM_ADMUNCHER_FILES', 'december.js', (_CM_READ_FILE(_CM_DIR .. 'december.js')))
hc.set_global_table_item('CM_ADMUNCHER_FILES', 'december.css', (_CM_READ_FILE(_CM_DIR .. 'december.css')))

-- ------------------------- Чтение языка интерфейса --------------------------------
-- local lng = _CM_PREPARE_LANGUAGE(_CM_OPTIONS.LanguageID)

local Parsers = {}
for _,v in pairs(_CM_FILTER_CODES) do
	local parser, filter = v:match('^(%S+)%s*:%s*(.*)')
	Parsers[parser] = Parsers[parser] or {}
	Parsers[parser][filter]=true
end

local IniFileOK, Users = pcall( function() return dofile(hc.script_name:match('.*%.') .. 'ini') end )
if not IniFileOK then Users = { ALL={ Name='ALL', On=true, Parsers={}, Log={}, BypassNon200Answers=true, BypassNoHits=true } } end

local Local_Coded_HC_users = hc.get_users_stat('#all') or {}	-- получаем список пользователей НС с именами в системной коидировке
local HC_users = {}	-- список пользователей с именами в UTF-8
for userName,user in pairs(Local_Coded_HC_users) do	-- перекодируем имена пользователей в UTF-8
	HC_users[hc.recode(userName, _CM_OPTIONS.SystemCoding, 65001)] = user
end

for user in pairs(Users) do	-- исключаем пользователей, отсутствующих на вкладке 'Доступ' НС
	if user~='ALL' and not HC_users[user] then
		local i = 1
		while Users.ALL[i] do
			if Users.ALL[i].Name==user then
				table.remove(Users.ALL, i)
				Users[user] = nil
			else i = i + 1
			end
		end
	end
end

for user in pairs(HC_users) do	-- если в списке 'Доступ' НС есть пользователи, не описанные в ini, то добавляем их
	if not Users[user] then
		Users[user] = { Parent=Users.ALL, Name=user, Inherited=true, On=Users.ALL.On, Parsers={} }
		table.insert(Users.ALL, Users[user])
	end
end

local function fileNameToURL(fname, parser)
	local url
	if parser=='HandyCache' and (fname=='white.lst' or fname=='black.lst') then url = 'http://local.cm/hcrules/' .. fname
	else url = 'http://local.cm/rules/' .. parser .. '/' .. fname
	end
	return url
end

Users.ALL.Sources = Users.ALL.Sources or {}
local sources = {}
for parser,v in pairs(Parsers) do	-- заполняем структуру парсеров и фильтров у пользователя 'ALL'
	
-- Регистрируем локальные файлы фильтров (находятся в папке rules/local/<parser>/)
	local directory = _CM_DIR .. 'rules\\local\\' .. parser
	hc.shell_execute('cmd', '/C dir "' .. directory .. '" /b /a-d > "' .. directory .. '\\tmp.dat"', nil, 'SW_HIDE', true)
    for filename in io.lines(directory .. '\\tmp.dat') do
        if filename~='tmp.dat' then
			local already
			local url = fileNameToURL(filename, parser)
			for _,source in ipairs(Users.ALL.Sources) do
				if source.URL==url then
					table.insert(sources, source)
					already = true
					break
				end
			end
			if not already then
				table.insert(sources, {
					URL = url,
					Name = url:match('^.*/(.*)'),
					Parser = parser,
				})
			end
		end
    end
	os.remove(directory .. '\\tmp.dat')

	if not IniFileOK then	-- если нет ini-файла (первый запуск СМ после установки)
		Users.ALL.Parsers[parser] = { Hits=0, Files={}, Filters={} }
		Users.ALL.Parsers[parser].Files = {}
		if parser=='ContentMaster' then
			Users.ALL.Parsers[parser].On = true
			table.insert(sources, {
				Name = 'AntiAd',
				URL = _CM_FOLDER_URL .. 'rules/antiad.json',
				Parser = parser,
				Comment = 'Common Ad removing rules',
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'AntiAd Private',
				URL = _CM_FOLDER_URL .. 'rules/antiad_private.json',
				Parser = parser,
				Comment = 'Site-specific Ad removing rules',
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'AntiCount',
				URL = _CM_FOLDER_URL .. 'rules/anticount.json',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'AntiFroud',
				URL = _CM_FOLDER_URL .. 'rules/antifroud.json',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'AntiAntiBlock',
				URL = _CM_FOLDER_URL .. 'rules/antiantiblock.json',
				Parser = parser,
				Comment = 'Block site attempts to detect CM and restrict content'
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'AntiSocial',
				URL = _CM_FOLDER_URL .. 'rules/antisocial.json',
				Parser = parser,
				Comment = 'Content Master Antisocial filter',
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=false })
			table.insert(sources, {
				Name = 'AntiWidget',
				URL = _CM_FOLDER_URL .. 'rules/antiwidget.json',
				Parser = parser,
				Comment = 'Removes some types of widgets: weather, finance, chat, polls, ...',
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=false })
			table.insert(sources, {
				Name = 'NoBlock',
				URL = _CM_FOLDER_URL .. 'rules/noblock.json',
				Parser = parser,
				Comment = 'Speeds up ContentMaster by bypassing filters for some trusted resources',
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'AntiPorno',
				URL = _CM_FOLDER_URL .. 'rules/antiporno.json',
				Parser = parser,
				Comment = 'Content Master AntiPorno filter',
			})
			table.insert(Users.ALL.Parsers[parser].Files, { URL=sources[#sources].URL, On=false })
		elseif parser=='HandyCache' then
			-- Users.ALL.Parsers[parser].On = true
			table.insert(sources, {
				Name = 'HandyCache Black list',
				URL = 'http://local.cm/hcrules/black.lst',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'HandyCache White list',
				URL = 'http://local.cm/hcrules/white.lst',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'HandyCache Antisocial filter',
				URL = _CM_FOLDER_URL .. 'rules/hc_antisocial.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=false })
		elseif parser=='AdBlockPlus' then
			-- Users.ALL.Parsers[parser].On = true
			table.insert(sources, {
				Name = 'RU AdList',
				URL = 'https://easylist-downloads.adblockplus.org/advblock.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'EasyList',
				URL = 'https://easylist-downloads.adblockplus.org/easylist.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=false })
			table.insert(sources, {
				Name = 'Counters list',
				URL = 'https://easylist-downloads.adblockplus.org/cntblock.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=true })
			table.insert(sources, {
				Name = 'EasyPrivacy',
				URL = 'https://easylist-downloads.adblockplus.org/easyprivacy.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=false })
			table.insert(sources, {
				Name = 'BitBlock list',
				URL = 'https://easylist-downloads.adblockplus.org/bitblock.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=false })
		elseif parser=='AdMuncher' then
			-- Users.ALL.Parsers[parser].On = true
			table.insert(sources, {
				Name = 'AdMuncher Default filter',
				URL = _CM_FOLDER_URL .. 'rules/AdMuncher_Default.txt',
				Parser = parser,
			})
			table.insert(Users.ALL.Parsers[parser].Files, {  URL=sources[#sources].URL, On=true })
		end
	else Users.ALL.Parsers[parser] = Users.ALL.Parsers[parser] or { Hits=0, Files={}, Filters={} }
	end
	for filter in pairs(v) do
		if not Users.ALL.Parsers[parser].Filters[filter] then
			if not IniFileOK then Users.ALL.Parsers[parser].Filters[filter] = { On=true, Hits=0 }
			else Users.ALL.Parsers[parser].Filters[filter] = { Hits=0 }
			end
		end
	end
end

for _,source in ipairs(Users.ALL.Sources) do	-- переносим информацию о всех "нелокальных" источниках фильтров
	if not source.URL:match('^https?://local%.cm/rules/') then
		table.insert(sources, source)
	end
end

local function DeleteRecordsAboutNonRegisteredFiles(ParentUser)	-- удаляем в структуре пользователей отсылки на источники, которые отсутствуют в хранилище Sources
	for _,ParentParser in pairs(ParentUser.Parsers) do
		local i = #ParentParser.Files
		while i>0 do
			if not _CM_FIND_SOURCE_BY_URL(ParentParser.Files[i].URL, sources) then table.remove(ParentParser.Files, i) end
			i = i - 1
		end
	end
	for _,ChildUser in ipairs(ParentUser) do	-- цикл по всем дочерним пользователям
		DeleteRecordsAboutNonRegisteredFiles(ChildUser)
	end
end
DeleteRecordsAboutNonRegisteredFiles(Users.ALL)

for _,source in ipairs(sources) do	-- добавляем в структуру пользователей отсылки на источники, которые отсутствуют там, но есть в хранилище Sources
	local already
	for _,file in ipairs(Users.ALL.Parsers[source.Parser].Files) do
		if source.URL==file.URL then
			already = true
			break
		end
	end
	if not already then
		table.insert(Users.ALL.Parsers[source.Parser].Files, {
			URL = source.URL,
			On = true,
		})
	end
end

Users.ALL.Sources = sources

-- установим опции пользователей с учетом пропущенных и унаследованных
local function Inherit(ParentUser)
	for _,ChildUser in ipairs(ParentUser) do	-- цикл по всем дочерним пользователям
		for m,ParentParser in pairs(ParentUser.Parsers) do
			local ChildParser = ChildUser.Parsers[m]
			if ChildParser then
				for _,ParentFile in ipairs(ParentParser.Files) do
					local finded
					for _,ChildFile in ipairs(ChildParser.Files) do
						if ChildFile.URL==ParentFile.URL then
							finded = true
							break
						end
					end
					if not finded then table.insert(ChildParser.Files, { URL=ParentFile.URL, On=ParentFile.On, Inherited=true }) end
				end
				for filter,v in pairs(ParentParser.Filters) do
					ChildParser.Filters[filter] = ChildParser.Filters[filter] or { On=v.On, Hits=0, Inherited=true }
				end
			else
				ChildUser.Parsers[m] = { On=ParentParser.On, Hits=0, Files=loadstring(_CM_SAVE_TABLE(ParentUser.Parsers[m].Files))(), Filters={}, Inherited=true }
				for filter,v in pairs(ParentParser.Filters) do
					ChildUser.Parsers[m].Filters[filter] = { On=v.On, Hits=0, Inherited=true }
				end
				for file in pairs(ParentUser.Parsers[m].Files) do
					ChildUser.Parsers[m].Files[file].Inherited = true
				end
			end
		end
		Inherit(ChildUser)
	end
end
Inherit(Users.ALL)

-- ЗАПЛАТКА снимаем везде унаследованность, пока она не реализована в интерфейсе настроек
-- local function DeInherit(User)
	-- User.Inherited = false
	-- for _,Parser in pairs(User.Parsers) do
		-- Parser.Inherited = false
		-- for _,v in pairs(Parser.Filters) do
			-- v.Inherited = false
		-- end
		-- for _,v in pairs(Parser.Files) do
			-- v.Inherited = false
		-- end
	-- end
	-- for _,ChildUser in ipairs(User) do	-- цикл по всем дочерним пользователям
		-- DeInherit(ChildUser)
	-- end
-- end
-- DeInherit(Users.ALL)

-- заплатка при переходе с версии 2.07.9 на 2.08.0 после переименования фильтра СМ с 'Удаление элементов с URL' на 'Удаление элементов и блокирование по URL'
local function chore_rename_filter(ParentUser)
	if ParentUser.Parsers.ContentMaster.Filters['Remove elements by URL'] then
		ParentUser.Parsers.ContentMaster.Filters['Remove elements and blocking by URL'] = ParentUser.Parsers.ContentMaster.Filters['Remove elements by URL']
		ParentUser.Parsers.ContentMaster.Filters['Remove elements by URL'] = nil
	end
	for _,ChildUser in ipairs(ParentUser) do	-- цикл по всем дочерним пользователям
		chore_rename_filter(ChildUser)
	end
end
chore_rename_filter(Users.ALL)

Users.ALL.BypassModeHotkey = Users.ALL.BypassModeHotkey or ''
Users.ALL.InteractiveModeHotkey = Users.ALL.InteractiveModeHotkey or ''


-- Users.ALL.AutoUpdate = Users.ALL.AutoUpdate or (IniFileOK and {} or { period=24 })
Users.ALL.AutoUpdate = Users.ALL.AutoUpdate or {}


Users.ALL.Editor = Users.ALL.Editor or 'notepad.exe'
hc.set_global('CM_USERS', _CM_SAVE_TABLE(Users))
_CM_UPDATE_REMOTE_SOURCES()	-- запускает обновление подписок. Нельзя переносить выше hc.set_global('CM_USERS', _CM_SAVE_TABLE(Users)), т.к. эта глобальная переменная может измениться при обновлении (могут добавиться сведения о неудачных обновлениях)

_CM_PREPARE_ORIGINAL_RULES(Users, sources)	-- создает массив описания правил

hc.set_global('CM_AUTO_UPDATE', Users.ALL.AutoUpdate)


hc.set_global_table_item('CM_ADMUNCHER_FILES', '-#jsmain#-', (_CM_READ_FILE(_CM_DIR .. 'admuncher.js'):gsub([[http://interceptedby%.admuncher%.com/.-/([^'"]*)]], '//local.cm/%1')))
hc.set_global_table_item('CM_ADMUNCHER_FILES', 'toolbar_iframe', (_CM_READ_FILE(_CM_DIR .. 'admuncher_toolbar_iframe.htm')))
hc.set_global_table_item('CM_ADMUNCHER_FILES', 'toolbar_transparent', (_CM_READ_FILE(_CM_DIR .. 'admuncher_toolbar_transparent.gif')))
hc.set_global_table_item('CM_ADMUNCHER_FILES', 'toolbar_sprite', (_CM_READ_FILE(_CM_DIR .. 'admuncher_toolbar_sprite.png')))

local f = io.open(_CM_DIR .. 'source\\compile.lua', 'rb')
if f then
	f:close()
	dofile(_CM_DIR .. 'source\\compile.lua')
end
hc.set_global('CM_WORKERS', {
	URL		= _CM_READ_FILE(_CM_DIR .. 'workers\\url.cm'),
	RAW		= _CM_READ_FILE(_CM_DIR .. 'workers\\raw.cm'),
	HTML	= _CM_READ_FILE(_CM_DIR .. 'workers\\html.cm'),
	JS		= _CM_READ_FILE(_CM_DIR .. 'workers\\js.cm'),
	CSS		= _CM_READ_FILE(_CM_DIR .. 'workers\\css.cm')
})
hc.set_global('CM_PARSERS', {
	HTML	= loadstring(_CM_READ_FILE(_CM_DIR .. 'workers\\parser_html.cm'))(),
	JS		= loadstring(_CM_READ_FILE(_CM_DIR .. 'workers\\parser_js.cm'))()
})

_CM_OPTIONS.LAST_OPTIONS_CHANGE_TIME = os.time()
hc.set_global('CM_LAST_HITS_SAVE_TIME', os.clock())
local hc_header = _CM_READ_FILE(_CM_DIR .. 'Content_Master.lua'):match('^%s*%-%-%[%[%s*<HCExtension>.-</HCExtension>%s*%]%]')
_CM_OPTIONS.Version = hc_header:match('@version%s*([^\r\n]*)')
_CM_OPTIONS.ExtensionName = hc_header:match('@name%s*([^\r\n]*)')
_CM_OPTIONS.HitsAutoSavePeriod = 3600	-- период автосохранения числа срабатываний правил, сек. (1 час)

_CM_OPTIONS.ctypes = { ['text/html']='html', ['application/xhtml+xml']='html', ['text/css']='css', ['text/javascript']='js', ['text/x-js']='js', ['application/javascript']='js', ['application/x-javascript']='js', ['text/x-javascript'] = 'js' }

hc.remove_global('CM_RULES')

local old_path = package.path
package.path = hc.script_name:match('.*\\') .. '?.lua'
local json = require('dkjson')
package.path = old_path
hc.set_global('CM_HITS', json.decode(_CM_READ_FILE(_CM_DIR .. 'log\\stat.json', false) or '{}') or {})

hc.set_global('CM_REMOVE_INTERACTIVE_MODE_BY_USERS', {})

local function HaveDifferentUsers()
	local function GetUserHash(user)
		local hash = ''
		for parserName,parser in pairs(user.Parsers) do	-- заполняем структуру парсеров и фильтров у пользователя 'ALL'
			hash = hash .. tostring(parser.On)
			for _,filter in pairs(parser.Filters) do hash = hash .. tostring(filter.On) end
			for _,file in pairs(parser.Files) do hash = hash .. tostring(file.On) end
		end
		return hash
	end
	local user1_hash
	for _,user in ipairs(Users.ALL) do
		if user.On then
			if user1_hash then
				if GetUserHash(user)~=user1_hash then return true end
			else user1_hash = GetUserHash(user)
			end
		end
	end
end
_CM_OPTIONS.HaveDifferentUsers = HaveDifferentUsers()
if not _CM_OPTIONS.HaveDifferentUsers then	-- если нет пользователей с разными настройками, то инициализируем компоненты СМ сразу
	hc.send_request('GET http://www.bing.com/ HTTP/1.1\r\nUser-Agent: ContentMaster\r\nConnection: close\r\n\r\n')
end
hc.set_global('CM_OPTIONS', _CM_OPTIONS)

hc.put_to_log('Content Master v.' .. _CM_OPTIONS.Version .. ' initialized from ', hc.script_name:match('.*%.'), 'ini')
