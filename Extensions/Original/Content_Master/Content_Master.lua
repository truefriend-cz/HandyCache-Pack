--[[ <HCExtension>
@name				Content Master 2 head
@author				Michael (nadenj@mail.ru)
@version			2.31.3
@description		Content editing and blocking engine
@homepage			http://handycache.ru/cm/cm2/doc/ContentMaster.html
@min_HC_version		1.0.0.739
@event				Init
@event				Options
@event				Timer1m
@event				RequestHeaderReceived
@event				Destroy
@rule				\A(?>http|SOCKS5)
@exception			\Ahttp://handycache\.cmd/
</HCExtension> ]]


_CM_DIR = hc.script_name:match('.*\\')	-- путь к папке СМ
_CM_FOLDER_URL = 'http://handycache.ru/cm/cm2/'
_CM_MAIN_URL = _CM_FOLDER_URL .. 'Content_Master.lua'


function Init()
	local common = loadfile(_CM_DIR .. 'cm_common.lua')
	hc.set_global('CM_COMMON', string.dump(common))
	common()
	local f = io.open(_CM_DIR .. 'source\\compile.lua', 'rb')
	if f then
		f:close()
		dofile(_CM_DIR .. 'source\\compile.lua')
	end
	loadstring(_CM_READ_FILE(_CM_DIR .. 'cm_init.cm'))()
end
function Options() os.execute('start http://local.cm/options/') end
function Destroy() dofile(_CM_DIR .. 'cm_destroy.lua') end
function BeforeRequestHeaderSend()
	if _CM_CURRENT_REQUEST_DATA.URL:match('^https?://local%.cm/options/') then
		loadstring(_CM_READ_FILE(_CM_DIR .. 'cm_options.cm'))()
	end
end
BeforeRequestBodySend = BeforeRequestHeaderSend


function Timer1m()
	local MaxCacheSize = 50000	-- максимальное число записей в кэше срабатываний правил СМ
	local CacheSize = hc.get_global_table_item('CM_URL_CACHE', 'Size') or 0
	-- hc.put_msg('Cache size = ', CacheSize)
	if CacheSize>MaxCacheSize then	-- после заполнения MaxCacheSize записей очищаем кэш срабатываний
		-- hc.put_msg('Content Master:\r\nURL Cache is emptied by ', CacheSize, ' entries')
		hc.set_global('CM_URL_CACHE')
	end

	local unow = hc.get_global('CM_AUTO_UPDATE')
	if unow.period and (not unow.last or (os.time()>=unow.last+unow.period*3600)) then
		loadstring(hc.get_global('CM_COMMON'))()	-- подгружаем библиотеку общих функций
		_CM_UPDATE_CORE()
		if not unow.OnlyCM then _CM_UPDATE_FILTERS() end
		unow.last = os.time()
		hc.set_global('CM_AUTO_UPDATE', unow)
		hc.reload_extension(hc.get_global_table_item('CM_OPTIONS', 'ExtensionName'))
	end
	
	local unow = hc.get_global('CM_AUTO_STAT')
	if not unow.last or (os.time()>=unow.last+unow.period*3600) then

		local old_path = package.path
		package.path = hc.script_name:match('.*\\') .. '?.lua'
		local json = require('dkjson')
		package.path = old_path

		-- local bdy = hc.compress(json.encode({
		local bdy = json.encode({
			id = hc.crc32(hc.language_id .. hc.script_name .. hc.cache_path .. hc.ini_path),		-- user fingerprint
			version = hc.get_global_table_item('CM_OPTIONS', 'Version'),
			hits = hc.get_global('CM_HITS'),
		})
		hc.send_request('POST ' .. _CM_FOLDER_URL .. '1.php HTTP/1.1\r\nUser-Agent: ContentMaster\r\nContent-Length: ' .. #bdy .. '\r\nConnection: close\r\n\r\n', bdy)

		unow.last = os.time()
		hc.set_global('CM_AUTO_STAT', unow)
	end

	if os.clock() - hc.get_global('CM_LAST_HITS_SAVE_TIME') >= hc.get_global_table_item('CM_OPTIONS', 'HitsAutoSavePeriod') then	-- периодически сохраняем базу данных срабатываний правил фильтров
		loadstring(hc.get_global('CM_COMMON'))()	-- подгружаем библиотеку общих функций
		hc.set_global('CM_LAST_HITS_SAVE_TIME', os.clock())
		_CM_SAVE_HITS()
	end
end


local function InitiateWorkers()	-- инициализирует необходимые движки (raw, html, js, css и т.п.)
	local content_type = _CM_CURRENT_REQUEST_DATA.ContentType or _CM_CURRENT_REQUEST_DATA.ContentTypeByBody or _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader
	_CM_RAW_WORKER = _CM_RAW_WORKER or loadstring(hc.get_global_table_item('CM_WORKERS', 'RAW'))():New{}
	_CM_CURRENT_REQUEST_DATA.RawWorker = _CM_RAW_WORKER:Reinit(content_type, _CM_CURRENT_REQUEST_DATA.Charset or _CM_CURRENT_REQUEST_DATA.CharsetByHeader or 'iso-8859-1')
	if content_type=='html' then
		_CM_HTML_WORKER = _CM_HTML_WORKER or loadstring(hc.get_global_table_item('CM_WORKERS', 'HTML'))()
		_CM_CURRENT_REQUEST_DATA.Worker = _CM_HTML_WORKER:New{ Coding=_CM_CURRENT_REQUEST_DATA.Charset or _CM_CURRENT_REQUEST_DATA.CharsetByHeader or 'iso-8859-1' }
	elseif content_type=='js' or content_type=='application/json' then
		_CM_JS_WORKER = _CM_JS_WORKER or loadstring(hc.get_global_table_item('CM_WORKERS', 'JS'))()
		_CM_CURRENT_REQUEST_DATA.Worker = _CM_JS_WORKER:New{}
	elseif content_type=='css' then
		_CM_CSS_WORKER = _CM_CSS_WORKER or loadstring(hc.get_global_table_item('CM_WORKERS', 'CSS'))()
		_CM_CURRENT_REQUEST_DATA.Worker = _CM_CSS_WORKER:New{}
	end
end


function RequestHeaderReceived()

-- clck1, clck2, clck3, clck4, clck5, clck6, clck7, clck8, clck9, clck10, clck11 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
-- clck1 = clck1 - os.clock()

	local req_url = hc.url	-- запоминаем в локальной переменной для ускорения
	if _CM_USER and not _CM_USER.On and not req_url:match('^https?://local%.cm/') then return end	-- для этого пользователя СМ отключен (кроме входа в настройки)
	
	local header = hc.request_header	-- запоминаем в локальной переменной для ускорения

	if header:match('^HEAD%s') then return end	-- запросы HEAD не обрабатываем
	
	_CM_COMMON_LIB_LOADED = _CM_COMMON_LIB_LOADED or loadstring(hc.get_global('CM_COMMON'))()	-- подгружаем библиотеку общих функций

	
	_CM_UPDATE_2 = header:match('CM%-Info:[^\r\n%S]*Update')	-- признак того, что это запрос на обновление СМ или фильтров
	if _CM_UPDATE_2 then
		dofile(_CM_DIR .. 'cm_update.lua')
		return
	else
-- hc.put_to_log(hc.url, '\r\n', tostring(hc.get_global('CM_UPDATE_COUNTER')))
		while hc.get_global('CM_UPDATE_COUNTER')>0 do
			hc.sleep(1000)
		end
	end

	
	_CM_FUNC = header:match('CM%-Func:([^\r\n]+)')
	if _CM_FUNC then
		_CM_FUNC = _CM_DECODE_FUNCTION(_CM_FUNC)
		_CM_FUNC()
		return
	end
	
	-- если это первый запрос в соединении или были изменения в настройках, то (пере)загружаем данные
	local last_opt_time = hc.get_global_table_item('CM_OPTIONS', 'LAST_OPTIONS_CHANGE_TIME')
	if not _CM_CONNECTION_START_TIME or _CM_CONNECTION_START_TIME < last_opt_time then	-- далее задаются настройки, действующие все время жизни СОЕДИНЕНИЯ
		_CM_CONNECTION_START_TIME = last_opt_time
		_CM_USERS = loadstring(hc.get_global('CM_USERS'))()	-- все пользователи СМ (таблица)
		_CM_OPTIONS = hc.get_global('CM_OPTIONS')
		_CM_USER = _CM_USERS[hc.recode(hc.user_name, _CM_OPTIONS.SystemCoding, 65001)] or _CM_USERS.ALL	-- пользователь (предполагается, что он один на соединение!!!)
		_CM_JS_PARSERS = hc.get_global_table_item('CM_PARSERS', 'JS')	-- подгружаем базу регэкспов парсера JS
		if not _CM_USER.On and not req_url:match('^https?://local%.cm/') then return end	-- для этого пользователя СМ отключен (кроме входа в настройки)
		_CM_DATA = _CM_DATA or {}
		os.setlocale('', 'all')	-- устанавливаем локаль СМ в текущую локаль системы

		lng, _CM_MESSAGES_CODING = _CM_PREPARE_LANGUAGE(_CM_OPTIONS.LanguageID, true)	-- создаем переводчик с англ. языка на текущий язык НС
		_CM_URL_WORKER, _CM_HTML_WORKER, _CM_JS_WORKER, _CM_CSS_WORKER, _CM_RAW_WORKER = nil, nil, nil, nil, nil
	-- else lng = _CM_PREPARE_LANGUAGE()
	end

	local mindex = hc.monitor_index
	_CM_DATA[mindex] = {}
	_CM_CURRENT_REQUEST_DATA = _CM_DATA[mindex]	-- сюда будут сохраняться данные, специфичные для запроса, которые потом должны использоваться в обработчиках

	local is_redirect
	_CM_CURRENT_REQUEST_DATA.URL, _CM_CURRENT_REQUEST_DATA.Host, _CM_CURRENT_REQUEST_DATA.Domain, is_redirect = _CM_NORMALIZE_URL(req_url)
-- hc.put_to_log(tostring(req_url), '\r\n', tostring(_CM_CURRENT_REQUEST_DATA.URL), '\r\n', tostring(is_redirect))
	if is_redirect then
		hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 302 Moved Temporarily (CM)\r\nContent-Length: 0\r\nLocation: ' .. _CM_CURRENT_REQUEST_DATA.URL .. '\r\nConnection: keep-alive\r\n\r\n')
		hc.answer_body = ''
		hc.action = 'dont_update'
		return
	end

	-- --------------------------- ОБРАБОТКА ЗАПРОСОВ ОТ ВЕБ-ИНТЕФЕЙСА СМ -----------------------
	if _CM_CURRENT_REQUEST_DATA.URL:match('^https?://local%.cm/options/') then
		loadstring(_CM_READ_FILE(_CM_DIR .. 'cm_options.cm'))()
		return
	end

	-- --------------------------- ОБРАБОТКА СООБЩЕНИЙ МАСТЕРА ИНТЕРАКТИВНОЙ РАБОТЫ -----------------------
	local url = _CM_CURRENT_REQUEST_DATA.URL:match('^https?://(.*)/for_CM$')
	if url then
		hc.white_mask = hc.white_mask:gsub('[Ss]', '') .. 'S'	-- отключаем запись в кэш
		local action, parameter = header:match('[\r\n]cm%-info:%s*(.-)###(.-)[\r\n]')
		if action=='AcceptChanges' then
			local monitor_index, interactive_mode, info = parameter:match('^(.-)###(.-)###(.*)')
			if info then	-- если это служебный запрос клиента, инициированный самим СМ

				local old_path = package.path
				package.path = hc.script_name:match('.*\\') .. '?.lua'
				local json = require('dkjson')
				package.path = old_path

				url = _CM_TO_REGEXP(url:gsub('^www%.', '', 1))
				local fname = _CM_DIR .. 'rules\\local\\ContentMaster\\CMAutoRules_' .. hc.recode(_CM_USER.Name, 65001, _CM_OPTIONS.SystemCoding) .. '.txt'
				local rules_url = 'http://local.cm/rules/ContentMaster/CMAutoRules_' .. hc.recode(_CM_USER.Name, 65001, _CM_OPTIONS.SystemCoding) .. '.txt'
				local sfile, sfile_err = _CM_READ_FILE(fname, false)
				if sfile_err then
					_CM_WRITE_FILE(fname, 'wb', '[]')	-- создаем файл, если его не было
					table.insert(_CM_USERS.ALL.Sources, {
						Comment = 'Rules created by ' .. _CM_USER.Name .. ' in Interactive mode',
						URL = rules_url,
						Parser = 'ContentMaster',
						Name = 'CMAutoRules_' .. _CM_USER.Name
					})

					-- установим этот файл у всех пользователей
					local function AddFileDescription(user)
						table.insert(user.Parsers.ContentMaster.Files, {
							URL = rules_url,
							Inherited = false,
							On = true
						})
						for _,ChildUser in ipairs(user) do	-- цикл по всем дочерним пользователям
							AddFileDescription(ChildUser)
						end
					end
					AddFileDescription(_CM_USERS.ALL)
					hc.set_global('CM_USERS', _CM_SAVE_TABLE(_CM_USERS))
					hc.set_global_table_item('CM_OPTIONS', 'LAST_OPTIONS_CHANGE_TIME', os.time())

					sfile, sfile_err = _CM_READ_FILE(fname, false)
				end
				if sfile_err then
					hc.put_msg('Content Master:\r\n' .. lng['Changes can\'t be saved\r\n'], sfile_err)
					hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 403 Not Accepted (CM)\r\nContent-Length: 0\r\nCache-Control: no-cache, must-revalidate\r\nPragma: no-cache\r\nConnection: close\r\n\r\n')
					hc.answer_body = ''
				else
					if interactive_mode=='remove' then
						local document = loadstring(hc.get_global_table_item('CM_DOMS', tostring(monitor_index)))()
						local function findBody(elem)
							if elem.tag_name=='body' then return elem end
							for _,child in ipairs(elem) do
								local el = findBody(child)
								if el then return el end
							end
						end
						local body = findBody(document)
						local function findElement(elem, id)
							if elem.tag:match(id) then return elem end
							for _,child in ipairs(elem) do
								local el = findElement(child, id)
								if el then return el end
							end
						end
			-- hc.put_to_log('Неизмененный info = ', info)
						local NonViewedElements = { script=1, style=1, ['!']=1 }
						info = info:gsub('#(.-)#(.-)#~#',
							function(id, s2)
								local element = id=='' and body or findElement(body, '%s[Ii][Dd]%s*=%s*[\'"]?' .. id:gsub('[.%-+()[%]\\$^%%?]', '%%%0') .. '[\'"%s>]')
								return '#' .. id .. '#' .. s2:gsub('%d+',
									function(num)
										local i, j, n = 0, 0, tonumber(num)
										while n>0 do
											i = i + 1
-- if not element[i] then hc.put_to_log('num = ', num, '\r\n', 'element.tag = ', element.tag, '\r\n', 'i = ', i, '\r\n', tostring(id), '\r\n\r\n', s2) end
											if not (element[i].Removed2 or NonViewedElements[element[i].tag_name]) then n = n - 1 end	-- учитываем полностью вырезанные элементы
											if not NonViewedElements[element[i].tag_name] then j = j + 1 end
										end
-- local dd = hc.get_global_table_item('CM_RULES_SOURCE', element[i].Removed)
-- hc.put_to_log('TEST5: ', element.tag, ' --> ', element[i].tag, '\r\nRemoved = ', tostring(dd), '\r\ni = ', i, '\r\nj=', j, '\r\n', tostring(element[i]))
										element = element[i]
										return j
									end
								) .. '#~#'
							end
						)
						if sfile:match('^%s*[%[{]') then	-- этот файл отсутствует или это json
							local rules = sfile_err and {} or json.decode(sfile)
							for path in info:gmatch('(.-)#~#') do table.insert(rules, { URL=url, Find=path, Type='INTERACTIVE' }) end
							_CM_WRITE_FILE(fname, 'wb', json.encode(rules))
						end
						local current_parser = _CM_USER.Parsers.ContentMaster
						if current_parser.On and current_parser.Filters['Remove interactively'].On then
							local Files = current_parser.Files
							local InteractiveList = {}
							for FileNumber,ff in ipairs(Files) do	-- для каждой включенной подписки
								if ff.On then
									local f, err = _CM_READ_FILE(_CM_GET_FILTER_FILE_PATH_FROM_URL(ff.URL), false)
									if not err then
										if f:match('^%s*[%[{]') then	-- это json
											local filters_file_content = json.decode(f)
											for ruleNumber,rule in ipairs(filters_file_content.Rules or filters_file_content) do
												local function modify(argument, code, repl)
													local hash = _CM_HASH(code, ff.URL, argument)
													hc.set_global_table_item('CM_RULES_SOURCE', hash, FileNumber .. code .. ruleNumber)
													if repl then hc.set_global_table_item('CM_RULES_ADDITIONS', hash, repl) end
													return argument:gsub('(%(%*ACCEPT%))', function(s1) return '(*:' .. hash .. ')' .. s1 end) .. '(*:' .. hash .. ')'
												end
												if rule.Type=='INTERACTIVE' and not rule.Off then
													table.insert(InteractiveList, modify(rule.URL .. '#~#' .. rule.Find, 'X'))
												end
											end
										end
									else hc.put_to_log('Content Master - Content_Master.lua - Interactive block:\r\n', err)
									end
								end
							end
							if InteractiveList[1] then
								hc.set_global_table_item('CM_ADMUNCHER_FILES', _CM_GET_COMPLEX_USER_NAME(_CM_USER) .. '##interactive##', table.concat(InteractiveList))
								hc.set_global_table_item('CM_OPTIONS', 'LAST_OPTIONS_CHANGE_TIME', os.time())
							end
						end
					else
						local CM_Site_Specific_STYLE_List, STYLE_List = {}, {}
						if sfile=='' or sfile:match('^%s*[%[{]') then	-- этот файл отсутствует или это json
							local rules = sfile_err and {} or json.decode(sfile)
							for style in info:gmatch('(.-)#~#') do table.insert(rules, { URL=url, Find=style .. ' {display:none !important;}', Type='STYLES' }) end
							_CM_WRITE_FILE(fname, 'wb', json.encode(rules))
						end
						local current_parser = _CM_USER.Parsers.ContentMaster
						if current_parser.On and current_parser.Filters['Insert CSS'].On then
							local Files = current_parser.Files
							for FileNumber,ff in ipairs(Files) do	-- для каждой включенной подписки
								if ff.On then
									local f, err = _CM_READ_FILE(_CM_GET_FILTER_FILE_PATH_FROM_URL(ff.URL), false)
									if not err then
										if f:match('^%s*[%[{]') then	-- это json
											local filters_file_content = json.decode(f)
											for ruleNumber,rule in ipairs(filters_file_content.Rules or filters_file_content) do
												if rule.Type=='STYLES' and not rule.Off then
													if not rule.URL or rule.URL:match('^^?%.%*?%??$') or rule.URL:match('^^$') then table.insert(STYLE_List, rule.Find)
													else table.insert(CM_Site_Specific_STYLE_List, rule.URL .. '#~#' .. rule.Find)
													end
												end
											end
										end
									else hc.put_to_log('Content Master - Content_Master.lua - Interactive block:\r\n', err)
									end
								end
							end
							if CM_Site_Specific_STYLE_List[1] then
								hc.set_global_table_item('CM_SITE_SPECIFIC_CSS', _CM_GET_COMPLEX_USER_NAME(_CM_USER), table.concat(CM_Site_Specific_STYLE_List, '~~~~') .. '~~~~')
							end
							if STYLE_List[1] then
								hc.set_global_table_item('CM_ADMUNCHER_FILES', _CM_GET_COMPLEX_USER_NAME(_CM_USER) .. 'helper.css', table.concat(STYLE_List, ' '))
							end
							hc.set_global_table_item('CM_OPTIONS', 'LAST_OPTIONS_CHANGE_TIME', os.time())
						end
					end
					hc.put_msg('Content Master:\r\n' .. lng['Changes saved'])
					hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 200 Accepted (CM)\r\nContent-Length: 0\r\nCache-Control: no-cache, must-revalidate\r\nPragma: no-cache\r\nConnection: close\r\n\r\n')
					hc.answer_body = ''
				end
			end
		end
		return
	end

-- ------------------------- ВСПОМОГАТЕЛЬНЫЕ ФАЙЛЫ ВСТАВКИ JS И CSS --------------------------------
	if _CM_CURRENT_REQUEST_DATA.URL:match('^https?://local%.cm') then
		if hc.method=='CONNECT' then return end
		local amfile, extension = _CM_CURRENT_REQUEST_DATA.URL:match('^https?://local%.cm/([^/.]+%.(%a+))')
		hc.white_mask = 'WBSDORU'	-- disable all HC lists
		-- hc.hide_in_monitor = true
		if amfile=='helper_ss.css' then
			local ims = header:match('If%-Modified%-Since:%s*(.-)[\r\n]')
			if not ims or hc.str_to_systime(ims)<last_opt_time then -- if CM options was modified
				local outer_text = ''
				local real_url = header:match('^%S+%s+(%S+)')
				local url, user = real_url:match('%?target_url=(.-)&user=(.*)')
				url, user =  hc.decode_base64(url), hc.decode_base64(user)
				local CMCSS = hc.get_global_table_item('CM_SITE_SPECIFIC_CSS', user)
				if CMCSS then	-- правило "ContentMaster:Вставка CSS"
					local regexp = CMCSS:gsub('(.-)#~#(.-)~~~~', function (s1, s2) return re.find(url, s1) and (s2 .. '\r\n   ') or '' end):match('(.-)%s*$')
					if regexp~='' then
						outer_text = outer_text .. '\r\n   ' .. regexp
					end
				end
				local ABPCSS = hc.get_global_table_item('CM_ABP_SITE_SPECIFIC_CSS', user)
				if ABPCSS then	-- правило "AdBlockPlus:Скрытие элементов"
					local request_domain = url:match('^https?://([^:/?]*)') or ''
					local doms, n = _CM_TO_REGEXP(request_domain):gsub('.-%.', '%0)?')
					local ss = ''
					function _CM_ABP_CSS_CALLOUT(_, _, offset_vector, start_match, current_position, _, capture_last)
						local domains = ABPCSS:sub(offset_vector[2*capture_last]+1, offset_vector[2*capture_last+1])
						for domain in domains:gmatch('~([^,]+)') do
							if request_domain==domain or request_domain:sub(-#domain-1)=='.' .. domain then return 1 end
						end
						ss = ss .. '\r\n   ' .. ABPCSS:sub(start_match, current_position-1)
						return 1
					end
					re.set_callout('_CM_ABP_CSS_CALLOUT')
						-- hc.put_to_log('^(?:' .. string.rep('(?:', n) .. doms .. [[)?(?=[,#]),?+(?>(.*?)\#\#)\K.+?$(*SKIP)(?C1)]])
					re.find(ABPCSS, '^(?:' .. string.rep('(?:', n) .. doms .. [[)?(?=[,#]),?+(?>(.*?)\#\#)\K.+?$(*SKIP)(?C1)]])
					re.set_callout(nil)
					outer_text = outer_text .. ss
				end
				hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 200 OK (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\nContent-Type: text/css; charset=utf-8\r\nContent-Length: ' .. #outer_text .. '\r\nLast-Modified: ' .. hc.systime_to_str(last_opt_time) .. '\r\nETag: "' .. (url .. user .. last_opt_time) .. '"\r\nCache-Control: no-cache, must-revalidate\r\nPragma: no-cache\r\n\r\n')
				hc.answer_body = outer_text
			else
				hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 304 Not Modified (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\n\r\n')
				hc.answer_body = ''
			end
		elseif amfile=='helper_ss.js' then
			local ims = header:match('If%-Modified%-Since:%s*(.-)[\r\n]')
			if not ims or hc.str_to_systime(ims)<last_opt_time then -- if CM options was modified
				local outer_text = ''
				local real_url = header:match('^%S+%s+(%S+)')
				local url, user = real_url:match('%?target_url=(.-)&user=([^&]*)')
				url, user =  hc.decode_base64(url), hc.decode_base64(user)

				-- специфичные правила JS формируются при обработке первого HTML. Однако уже до этого браузер может запросить helper_ss.js. В этом случае держим паузу
				local init_flag = hc.get_global_table_item('CM_HTML_ENGINE_INITIALIZED', user)
				local time = 30	-- максимальное время ожидания, сек
				if not init_flag then
					if init_flag==nil then	-- инициализация HTML и не начиналась (HTML берется из кэша браузера с ответом 304)
						_CM_HTML_WORKER = _CM_HTML_WORKER or loadstring(hc.get_global_table_item('CM_WORKERS', 'HTML'))()
					end
					while time>0 and not hc.get_global_table_item('CM_HTML_ENGINE_INITIALIZED', user) do
						hc.sleep(200)
						time = time - 0.2
					end
				end
				if time>0 then	-- успешно дождались конца инициализации правил HTML
					local regexp = hc.get_global_table_item('CM_SITE_SPECIFIC_JS', user)
					if regexp then	-- если для текущего пользователя есть хоть одно правило вставки JS
						regexp = regexp:gsub('(.-)#~#(.-)~~~~',
							function (s1, s2)
								return re.find(url, s1) and (s2 .. '\r\n   ') or ''
							end):match('(.-)%s*$')
						if regexp~='' then
							outer_text = outer_text .. '\r\n   ' .. regexp
						end
						hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 200 OK (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\nContent-Type: application/javascript\r\nContent-Length: ' .. #outer_text .. '\r\nLast-Modified: ' .. hc.systime_to_str(last_opt_time) .. '\r\nETag: "' .. (url .. user .. last_opt_time) .. '"\r\nCache-Control: no-cache, must-revalidate\r\nPragma: no-cache\r\n\r\n')
						hc.answer_body = outer_text
					else
						hc.action = 'stop'
						hc.monitor_string = hc.monitor_string .. 'Block inserting old JS-rules from client cache'
					end
				else	-- не дождались конца инициализации правил HTML
					hc.action = 'stop'
					hc.monitor_string = hc.monitor_string .. 'Bypass inserting JS-rules (module not inited)'
				end
			else
				hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 304 Not Modified (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\n\r\n')
				hc.answer_body = ''
			end
		else
			local ims = header:match('If%-Modified%-Since:%s*(.-)[\r\n]')
			if not ims or hc.str_to_systime(ims)<last_opt_time then -- if CM options was modified
				local contentType = { js='application/javascript', css='text/css', png='image/png', gif='image/gif', htm='text/html' }
				local fileName, extension = amfile:match('^([^.]+)%.(%a+)$')
				local body
				if fileName=='helper' then
					body = hc.get_global_table_item('CM_ADMUNCHER_FILES', _CM_GET_COMPLEX_USER_NAME(_CM_USER) .. amfile) or ''
					hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 200 OK (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\nContent-Type: ' .. (contentType[extension] or '') .. '; charset=utf-8\r\nContent-Length: ' .. #body .. '\r\nCache-Control: no-cache, must-revalidate\r\nPragma: no-cache\r\nLast-Modified: ' .. hc.systime_to_str(last_opt_time) .. '\r\nETag: "' .. last_opt_time .. '"\r\n\r\n')
				else
					body = hc.get_global_table_item('CM_ADMUNCHER_FILES', fileName) or ''
					hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 200 OK (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\nContent-Type: ' .. (contentType[extension] or '') .. '\r\nContent-Length: ' .. #body .. '\r\nCache-Control: no-cache, must-revalidate\r\nPragma: no-cache\r\nLast-Modified: ' .. hc.systime_to_str(last_opt_time) .. '\r\n\r\n')
				end
				hc.answer_body = body
			else
				hc.answer_header = PREPARE_CM_RESPONSE_HEADER('HTTP/1.1 304 Not Modified (CM)\r\nConnection: Keep-alive\r\nServer: HandyCache\r\n\r\n')
				hc.answer_body = ''
			end
		end
		_CM_DATA[mindex], _CM_CURRENT_REQUEST_DATA = nil, nil
		return
	end

	local InteractiveModeOn = req_url:match('%?cm_interactive_?(.*)')	-- если это запрос на включение интерактивного режима (к URL прибавлено '?cm_interactive')

	-- --------------------------- ОБРАБОТКА НАЖАТЫХ ГОРЯЧИХ КЛАВИШ -----------------------
	if hc.user_ip:match('^127%.') then	-- обрабатываем нажатие только для запросов с компьютера, на котором установлен НС
		local function keysPressed(keys, kbd_state)	-- функция возвращает, нажата ли комбинация клавиш keys (названия клавиш должны быть разделены пробелом) в состоянии клавиатуры kbd_state. Если kbd_state не задано, то функция сама проводит опрос состояния клавиатуры
			if not keys or not keys:match('%S') then return end
			kbd_state = ' ' .. (kbd_state or hc.get_keyboard_state()) .. ' '
			for key in keys:gmatch('%S+') do
				if not kbd_state:find(' ' .. key .. ' ', 1, true) then return end
			end
			return true
		end
		local kbd_state = hc.get_keyboard_state()
		if keysPressed(_CM_USERS.ALL.BypassModeHotkey, kbd_state) then return end	-- если зажата горячая клавиша отключения СМ, то выход
		InteractiveModeOn = InteractiveModeOn or keysPressed(_CM_USERS.ALL.InteractiveModeHotkey, kbd_state)	-- запоминаем состояние режима интерактивной работы
	end

	_CM_URL_WORKER = _CM_URL_WORKER or loadstring(hc.get_global_table_item('CM_WORKERS', 'URL'))()
	local URLAction = _CM_URL_WORKER:New{}:Process()
-- hc.put_to_log(hc.url, '\r\n', tostring(URLAction))
	if _CM_CURRENT_REQUEST_DATA.LogFragment2 then	-- если включен лог и было его реальное наполнение, то сохраним его в файл

		local old_path = package.path
		package.path = hc.script_name:match('.*\\') .. '?.lua'
		local json = require('dkjson')
		package.path = old_path

		local t = {
			UserName = _CM_USER.Name,
			Hits = ReplaceCount,
			MonitorIndex = mindex,
			Date = os.date(),
			URL = hc.recode(req_url, _CM_OPTIONS.SystemCoding, _CM_CODINGS['utf-8']),
			LogData = _CM_CURRENT_REQUEST_DATA.LogFragment2
		}
		_CM_WRITE_FILE(_CM_DIR .. 'log\\ContentMasterLog.txt', 'ab', ',' .. json.encode(t))
		_CM_CURRENT_REQUEST_DATA.LogFragment2 = nil
	end
	if URLAction=='stop' then
		hc.action = 'stop'
		return
	elseif URLAction=='bypass' then
		return
	end

	if InteractiveModeOn then
		if InteractiveModeOn=='hide' or InteractiveModeOn=='remove' then
			hc.set_global_table_item('CM_REMOVE_INTERACTIVE_MODE_BY_USERS', _CM_USER.Name, InteractiveModeOn)
			_CM_CURRENT_REQUEST_DATA.InteractiveModeOn = InteractiveModeOn
		else	-- зажата горячая клавиша интерактивного режима
			header = header:gsub('%?cm_interactive%S*', '', 1)
			_CM_CURRENT_REQUEST_DATA.InteractiveModeOn = hc.get_global_table_item('CM_REMOVE_INTERACTIVE_MODE_BY_USERS', _CM_USER.Name) or 'remove'
		end
		hc.request_header = header:gsub('If%-Modified%-Since:.-\n', '', 1):	-- предотвращаем ответ Not modified и Old_file без перезагрузки содержимого
			gsub('^(%w+%s+%S+)%?cm_interactive%S*', '%1', 1)
	end

	-- _CM_CURRENT_REQUEST_DATA.ContentType = 'UNDEFINED'	-- здесь по мере выявления/уточнения будет содержаться тип контента (html, js, css, jpg и т.п.)
	hc.call_me_for('BeforeAnswerHeaderSend')	-- регистрируем обработчик заголовка ответа
-- clck1 = clck1 + os.clock()
-- clck8 = clck1
end


function AnswerHeaderReceived()
	if _CM_UPDATE_3 then
		dofile(_CM_DIR .. 'cm_update.lua')
		return
	end
end


function BeforeAnswerHeaderSend()
-- clck1 = clck1 - os.clock()
	local header = hc.answer_header
	local header_low = header:lower()
	local AnswerCode = header:match('^%S+%s+(%d+)%D')

	if _CM_UPDATE_2 then
		dofile(_CM_DIR .. 'cm_update.lua')
		return
	end

	if _CM_FUNC then
		_CM_FUNC()
		return
	end

	
	-- --------------------------- ПРИНИМАЕМ РЕШЕНИЕ О НЕОБХОДИМОСТИ РАБОТЫ С ОТВЕТОМ -----------------------
	if (AnswerCode~='200' and _CM_USERS.ALL.BypassNon200Answers) or	-- ответ сервера не 200 и включено 'Не обрабатывать ответы с кодом, отличным от 200'
		re.find(header, [[\A\S++\s++(?>1\d\d|[23]04)|^Content-Length:\s*+0\s]]) or	-- ответ 1хх, 204, 304, а также с Content-Length:0 не имеет тела
		(_CM_USERS.ALL.BypassHCOwnAnswers and header_low:find('server: handycache', 1, true))	-- собственный ответ НС и включено 'Не обрабатывать ответы, сформированные НС' (вот только это может быть и ответ "внешнего" НС)
	then return	-- выходим без обработки
	end

	local mindex = hc.monitor_index
	_CM_CURRENT_REQUEST_DATA = _CM_DATA[mindex]

	_CM_CURRENT_REQUEST_DATA.ContentTypeByHeader = header_low:match('content%-type:%s*(%S-)[;%s]')
	_CM_CURRENT_REQUEST_DATA.ContentTypeByHeader = _CM_OPTIONS.ctypes[_CM_CURRENT_REQUEST_DATA.ContentTypeByHeader] or _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader
	
	-- charset оставляем невыбранным, если в ответе 2 заголовка content-type с разными чарсетами (http://wow.l2top.ru/)
	local charset = re.find(header_low, [[^content-type:[^\r\n]*?charset="?+([^\s";]++)(*COMMIT)(?!.*?^content-type:[^\r\n]*?charset="?+(?!\1))]], 1)
	-- hc.put_to_log(header_low, tostring(charset))
	_CM_CURRENT_REQUEST_DATA.CharsetByHeader = charset and _CM_CODINGS_ALIASES[charset]

	if _CM_USERS.ALL.BypassNoHits and hc.method=='GET' and not _CM_CURRENT_REQUEST_DATA.InteractiveModeOn and hc.get_global_table_item('CM_URL_CACHE', '-' .. _CM_CURRENT_REQUEST_DATA.URL) and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader~='html' then
		hc.monitor_string = hc.monitor_string .. 'CM:0 hits(cached)'
		return
	end

	if _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader=='html' then
		_CM_CURRENT_REQUEST_DATA.Referrer = _CM_CURRENT_REQUEST_DATA.URL
		hc.answer_header = header:gsub('([Cc]ontent%-[Ss]ecurity%-[Pp]olicy:)([^\r\n]*)',
			function(field_name, CSP)
				if _CM_CURRENT_REQUEST_DATA.InteractiveModeOn then CSP = CSP:gsub("(script%-src[^;]-)%s+'nonce%-.-'", '%1') end	-- отменяем запрет на инлайн-скрипты для успешного включения интерактивного режима
				local n, n1
				CSP, n = CSP:gsub('(style%-src[^;]*)', '%1 local.cm')
				if n==0 then CSP, n1 = CSP:gsub('(default%-src[^;]*)', '%1 local.cm') end
				CSP, n = CSP:gsub('(script%-src[^;]*)', '%1 local.cm')
				if n==0 and not n1 then CSP = CSP:gsub('(default%-src[^;]*)', '%1 local.cm') end
				return field_name .. CSP:gsub([['strict%-dynamic']], '')	-- удаляем блокировку скриптов https://w3c.github.io/webappsec-csp/#strict-dynamic-usage
			end)
	else
		_CM_CURRENT_REQUEST_DATA.Referrer = header_low:match('[\r\n]referer:[^\r\n%S]*(%S+)') or _CM_CURRENT_REQUEST_DATA.URL
	end

	-- если тип контента уже определен, загружаем для него правила
	if _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader~='html' then
		InitiateWorkers()
		if not _CM_CURRENT_REQUEST_DATA.RawWorker and not _CM_CURRENT_REQUEST_DATA.Worker then return end
	end
	_CM_CURRENT_REQUEST_DATA.FirstChunk = true
	hc.call_me_for('BeforeAnswerBodySend')
	-- collectgarbage()
-- clck1 = clck1 + os.clock()
-- clck11 = clck1 - clck8
end

function BeforeAnswerBodySend()
-- hc.put_to_log('------------ BeforeAnswerBodySend BEGINS -----------\r\n', clck1)
-- clck1 = clck1 - os.clock()

	if _CM_UPDATE_2 then
		dofile(_CM_DIR .. 'cm_update.lua')
		return
	end

	if _CM_FUNC then
		_CM_FUNC()
		return
	end
	
	
	local mindex = hc.monitor_index
	_CM_CURRENT_REQUEST_DATA = _CM_DATA[mindex]
	
	if _CM_CURRENT_REQUEST_DATA.UnregisterBeforeAnswerBodySend then return end	-- обработчик "отключен"
	
	
	local new_body, partial = hc.answer_body, not hc.last_part and 'hard' or nil

	
-- hc.put_to_log('BeforeAnswerBodySend: ', hc.url, '\r\nпоступил фрагмент длиной ', #new_body, partial and '' or ' (последний)')
	
	if _CM_CURRENT_REQUEST_DATA.FirstChunk then	-- если это первый чанк ответа
		-- иногда Content-Type заголовка ответа не совпадает с реальным типом содержимого ответа
		-- СМ пытается угадать действительный тип контента. По мере получения примеров список может расширяться
		if re.find(new_body, [[\A(?:\xEF\xBB\xBF)?+(?>\s++|/\*.*?\*/|//.*?^)*+[;(\s!]*+(?>document\.|function|var\s|if\s*+\(|window\.\w++\s*+=|\{(?>"\w++"|\w++)\s*+:|\w++\s*+\(\s*+\{|\w++\s*+=\s*+function)]])
			and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader ~= 'application/json'	-- JSON имеет формат JS
			and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader ~= 'text/json'	-- JSON имеет формат JS
			then _CM_CURRENT_REQUEST_DATA.ContentTypeByBody = 'js'	-- это JavaScript (пример: http://www.nix.ru/include/general.js и почти все остальные скрипты, грузимые с http://www.nix.ru/price/price_list.html?section=computers_nix_all
		elseif re.find(nil, [=[\A(?:\xEF\xBB\xBF)?+\s*+<\?xml(?>.*?>)\s*+(?!<!DOCTYPE\s++html)]=])
			then _CM_CURRENT_REQUEST_DATA.ContentTypeByBody = 'text/xml'	-- это XML (пример: 			https://bl.rutube.ru/route/93583fb190ea5e6629b3a6cab9fe4761.f4m?guids=956cc801-7bfe-480d-ac28-2426112cf7b5_512x288_253053_avc1.42c015_mp4a.40.5&sign=IpJxOR0Ez02ETh8jADxo4g&expire=1477830224&scheme=http&PID=1A08E4EE-51B9-6672-5D70-CF2131D54C341
		elseif not _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader and re.find(nil, [=[\A(?:\xEF\xBB\xBF)?+\s*+<[!\w]]=])
			then _CM_CURRENT_REQUEST_DATA.ContentTypeByBody = 'html'	-- это HTML (пример: http://convusmp.admailtiser.com/st?cias=1&cipid=81000&ttype=0&pix=31118116&site=$la&cat=$news&cb=5668&cisrf=https%3A%2F%2Fwww.google.ru%2F
		-- elseif _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader=='html' and not partial and
		elseif _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader=='html' and
			-- Content-Type:text/html содержит на самом деле JSON
			-- (например, https://go4up.com/download/gethosts/2153685fafdbc7/VA-Theo_Kamann_Presents_Kamannmix_Vol.59_%28Yearmix_2016%29-BOOTLEG-WEB-2016-NOiCE_INT.rar)
			-- или пустой файл, или не содержит ни одного тега
			-- re.find(nil, [=[\A\s*+(?>\[\s*+\{\s*+['"]|\z|(?!.*?<[!\w]))]=]) then
			not re.find(nil, [=[\A(?:\xEF\xBB\xBF)?+\s*+<[!\w]]=]) then
			_CM_CURRENT_REQUEST_DATA.ContentTypeByBody = 'unknown'	-- это не HTML (http://gsioutdoors.com/request/pdp_sized_images/65101_h1_f)
		else	-- пытаемся определить тип содержимого по сигнатуре файла
-- справочник сигнатур: http://www.garykessler.net/library/file_sigs.html
-- справочники MIME-типов: http://svn.apache.org/viewvc/httpd/httpd/branches/2.2.x/docs/conf/mime.types?view=annotate
-- http://www.iana.org/assignments/media-types/media-types.xhtml
			local signatures = {
				['\x89\x50\x4E\x47\x0D\x0A\x1A\x0A'] = 'image/png',	-- http://morevariantov.ru/bitrix/components/edit_components/catalog/saleimg.php?src=/upload/iblock/53e/53ec3527f8131cf415d925139dc36f23.jpeg&template=/bitrix_personal/templates/morevar
				['\xFF\xD8\xFF'] = 'image/jpeg',	-- http://zyxel.ru/sites/default/files/catalogue/logo_sky.htm
				['\x00\x01\x00\x00\x00'] = 'application/x-font-ttf',	-- http://vongomedia.ru/assets/fonts/MtBoCyLI.ttf
				['\x77\x4F\x46\x46'] = 'application/x-font-woff',	-- http://vongomedia.ru/assets/fonts/MtBoCyLI.woff
				-- ['\x77\x4F\x46\x32'] = 'font/woff2',	-- https://static.independent.co.uk/s3fs-public/font/Fira-Sans-Extrabold.woff2
				['\x50\x4B\x03\x04'] = 'application/zip',	-- http://www.packtpub.com/code_download/11704
				['\x00\x00\x00\x18\x66\x74\x79\x70'] = 'video/mp4',	-- http://s5.kinostok.tv/flv/e1b55b8b193c88cb94d91fa5e5ae7a67/uploaded_video/video/30/3054/305409/305409.mp4
				['\x00asm'] = 'application/octet-stream',
			}
			for signature, mime in pairs(signatures) do
				if new_body:sub(1, #signature)==signature then
					_CM_CURRENT_REQUEST_DATA.ContentTypeByBody = mime
					break
				end
			end
		end
		_CM_CURRENT_REQUEST_DATA.ContentType = _CM_CURRENT_REQUEST_DATA.ContentTypeByBody or _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader
-- hc.put_to_log(hc.url, '\r\n', tostring(_CM_CURRENT_REQUEST_DATA.ContentType))
		if _CM_CURRENT_REQUEST_DATA.ContentType=='html' and not _CM_CURRENT_REQUEST_DATA.CharsetByHeader then	-- это html с необъявленным чарсетом. Попытаемся установить его сами. Если не получится, полагаем, что это 'iso-8859-1'
		-- более крутой алгоритм определения: http://www-archive.mozilla.org/projects/intl/UniversalCharsetDetection.html
			local charset = re.find(new_body, [[<meta\s++(?>http-equiv="Content-Type"\s*+content="text/html;\s*+)?+charset="?+\K[^\s";]++]])
			_CM_CURRENT_REQUEST_DATA.CharsetByBody = charset and _CM_CODINGS_ALIASES[charset:lower()]
			_CM_CURRENT_REQUEST_DATA.Charset = _CM_CURRENT_REQUEST_DATA.CharsetByBody or 'iso-8859-1'
-- hc.put_to_log(hc.url, '\r\n#new_body = ', #new_body, '\r\n', _CM_CURRENT_REQUEST_DATA.Charset)
		else
			_CM_CURRENT_REQUEST_DATA.Charset = _CM_CURRENT_REQUEST_DATA.CharsetByHeader or 'iso-8859-1'
		end
		if not _CM_CURRENT_REQUEST_DATA.ContentType then	-- если так и не смогли определить тип контента, то не обрабатываем его
			_CM_CURRENT_REQUEST_DATA.UnregisterBeforeAnswerBodySend = true	-- "разрегистрируем" обработчик
			return
		elseif _CM_CURRENT_REQUEST_DATA.ContentType~=_CM_CURRENT_REQUEST_DATA.ContentTypeByHeader and not(_CM_CURRENT_REQUEST_DATA.ContentType=='image/jpeg' and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader=='image/pjpeg') then	-- несоответствие объявленного типа ответа его реальному содержимому
			InitiateWorkers()
			if not _CM_CURRENT_REQUEST_DATA.RawWorker and not _CM_CURRENT_REQUEST_DATA.Worker then	-- этот тип контента СМ не обрабатывает
				_CM_CURRENT_REQUEST_DATA.UnregisterBeforeAnswerBodySend = true	-- "разрегистрируем" обработчик
				-- hc.put_to_log(hc.url, '\r\nIt seems this file declared as ' .. (_CM_CURRENT_REQUEST_DATA.ContentTypeByHeader and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader:upper() or 'UNDEFINED') .. ' have ' .. _CM_CURRENT_REQUEST_DATA.ContentTypeByBody:upper(), ' format instead.\r\nContent Master bypass it.')
				return
			-- else
				-- hc.put_to_log(hc.url, '\r\nIt seems this file declared as ' .. (_CM_CURRENT_REQUEST_DATA.ContentTypeByHeader and _CM_CURRENT_REQUEST_DATA.ContentTypeByHeader:upper() or 'UNDEFINED') .. ' have ' .. _CM_CURRENT_REQUEST_DATA.ContentTypeByBody:upper(), ' format instead.\r\nContent Master process it accordingly.')
			end
		elseif _CM_CURRENT_REQUEST_DATA.ContentType=='html' or	-- воркеры не инициализировались в BeforeAnswerHeaderSend, делаем это сейчас
			-- если чарсет оказался другим, чем тот, что указан в HTTP-заголовке, то переинициализируем заново воркеры, инициализированные ранее в конце BeforeAnswerHeaderSend
			(_CM_CURRENT_REQUEST_DATA.CharsetByHeader and _CM_CURRENT_REQUEST_DATA.Charset~=_CM_CURRENT_REQUEST_DATA.CharsetByHeader) then
			InitiateWorkers()
			if not _CM_CURRENT_REQUEST_DATA.RawWorker and not _CM_CURRENT_REQUEST_DATA.Worker then	-- этот тип контента СМ не обрабатывает
				_CM_CURRENT_REQUEST_DATA.UnregisterBeforeAnswerBodySend = true	-- "разрегистрируем" обработчик
				return
			end
		end
		_CM_CURRENT_REQUEST_DATA.FirstChunk = nil
-- hc.put_to_log(_CM_CURRENT_REQUEST_DATA.ContentType, '\r\n', tostring(_CM_CURRENT_REQUEST_DATA.RawWorker), '\r\n', tostring(_CM_CURRENT_REQUEST_DATA.Worker))
	end
	
-- hc.put_to_log(string.rep('-', 80), '\r\n', #new_body, '\r\n', string.rep('-', 80))
-- clck2 = clck2 - os.clock()
	if _CM_CURRENT_REQUEST_DATA.RawWorker then
		new_body = _CM_CURRENT_REQUEST_DATA.RawWorker:Process(new_body, partial)
	end
-- clck2 = clck2 + os.clock()
-- hc.put_to_log(string.rep('-', 80), '\r\n', #new_body, '\r\n', string.rep('-', 80))
	if _CM_CURRENT_REQUEST_DATA.Worker
		and not(partial and #new_body==0) then	-- после RawWorker:Process часто остается тело нулевой длины, т.к. RawWorker:Process придерживает чанки
			new_body = _CM_CURRENT_REQUEST_DATA.Worker:Process(new_body, partial)
	end
	if not new_body then return end	-- это не HTML вопреки Content-Type ответа или внутри была ошибка (например, unknown coding problem), и тело не обрабатываем
-- hc.put_to_log(string.rep('-', 80), '\r\n', new_body, '\r\n', string.rep('-', 80))
-- hc.put_to_log(hc.url, '\r\n', #new_body, '\r\n', new_body)
	if partial then	-- не последний чанк
-- clck1 = clck1 + os.clock()
	else	--	последний чанк
		local ReplaceCount = (_CM_CURRENT_REQUEST_DATA.RawWorker and _CM_CURRENT_REQUEST_DATA.RawWorker.ReplaceCount or 0) + (_CM_CURRENT_REQUEST_DATA.Worker and _CM_CURRENT_REQUEST_DATA.Worker.ReplaceCount or 0)
		if ReplaceCount==0 and _CM_USERS.ALL.BypassNoHits and hc.method=='GET' then hc.set_global_table_item('CM_URL_CACHE', '-' .. _CM_CURRENT_REQUEST_DATA.URL, true) end
		hc.monitor_string = hc.monitor_string .. 'CM:' .. ReplaceCount .. ' hits'
		if _CM_CURRENT_REQUEST_DATA.LogFragment2 then	-- если включен лог и было его реальное наполнение, то сохраним его в файл
			local old_path = package.path
			package.path = hc.script_name:match('.*\\') .. '?.lua'
			local json = require('dkjson')
			package.path = old_path

			local t = {
				UserName = _CM_USER.Name,
				Hits = ReplaceCount,
				MonitorIndex = mindex,
				Date = os.date(),
				URL = hc.recode(_CM_CURRENT_REQUEST_DATA.URL, _CM_OPTIONS.SystemCoding, _CM_CODINGS['utf-8']),
				LogData = _CM_CURRENT_REQUEST_DATA.LogFragment2
			}
			_CM_WRITE_FILE(_CM_DIR .. 'log\\ContentMasterLog.txt', 'ab', ',' .. json.encode(t))
		end
		if _CM_CURRENT_REQUEST_DATA.Worker and _CM_CURRENT_REQUEST_DATA.ContentType=='html' and _CM_CURRENT_REQUEST_DATA.InteractiveModeOn then	-- если интерактивный режим включен, то добавляем на страницу CSS и JS, обеспечивающие его работу
			new_body = new_body .. '\r\n<!--/*--><style id="cm_only" cm_mindex="' .. mindex .. '" cm_interactive_mode="' .. _CM_CURRENT_REQUEST_DATA.InteractiveModeOn .. '">' .. hc.get_global_table_item('CM_ADMUNCHER_FILES', 'december.css') .. '</style>\r\n<script>' .. hc.get_global_table_item('CM_ADMUNCHER_FILES', 'december.js') .. '</script><!--*/-->'
			hc.set_global_table_item('CM_DOMS', tostring(mindex), _CM_SAVE_TABLE(_CM_CURRENT_REQUEST_DATA.Worker.document))
		end
		_CM_DATA[mindex], _CM_CURRENT_REQUEST_DATA = nil, nil	-- очищаем глобальные переменные
-- local cld = clck1
-- clck1 = clck1 + os.clock()
-- if clck1>=1 or clck1<0 then
-- hc.put_to_log('Content Master: статистика загрузки страницы ', hc.url, string.format(
	-- '\r\nВремя обработки страницы СМ = %g сек' ..
	-- '\r\n   Из них:' ..
	-- '\r\n   обработчиком заголовка запроса = %g' ..
	-- '\r\n   обработчиком заголовка ответа = %g' ..
	-- '\r\n   обработчиком тела ответа = %g' ..
	-- '\r\n' .. string.rep('-', 40) .. ' в том числе: ' .. string.rep('-', 40) ..
	-- '\r\n      Замена текста = %g' ..
	-- '\r\n      Построение DOM = %g' ..
	-- '\r\n      Вырез. по прямому указанию пользователя = %g' ..
	-- '\r\n      Удаление по комментарию = %g' ..
	-- '\r\n      Удаление по стартовому тэгу = %g' ..
	-- '\r\n      Вырез. в CSS = %g' ..
	-- '\r\n      Вырез. в JS = %g' ..
	-- '\r\n      Вырез. по содержащемуся тексту = %g', clck1, clck8, clck11, clck1-clck8-clck11, clck2, clck5, clck8, clck7, clck3, clck9, clck10, clck4))
-- end
-- if clck1<0 then hc.put_msg(hc.url, '\r\nclck1<0') hc.put_to_log(cld, '\r\n', clck1) end
	end
-- hc.put_to_log('_CM_HTML_WORKER:Process: ', hc.url, '\r\nОТДАН фрагмент длиной ', #new_body, not hc.last_part and '' or ' (последний)', '\r\nНачало = ', new_body:sub(1,200), '\r\nКонец = ', new_body:sub(-200))
	hc.answer_body = new_body
-- collectgarbage()
-- hc.put_to_log('------------ BeforeAnswerBodySend ENDS -----------\r\n', clck1)
end
