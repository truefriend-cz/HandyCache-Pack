
-- Названия кодировок (указываются после "charset=")
-- список возможных чарсетов на http://www.firstobject.com/character-set-name-alias-code-page.htm
-- и http://www.iana.org/assignments/character-sets/character-sets.xhtml
_CM_CODINGS_ALIASES = {
	['utf-8']='utf-8', ['unicode-1-1-utf-8']='utf-8', ['unicode-2-0-utf-8']='utf-8', ['x-unicode-2-0-utf-8']='utf-8', cp65001='utf-8', utf8='utf-8', csutf8='utf-8',
	['koi8-r']='koi8-r', cskoi8r='koi8-r', koi='koi8-r', koi8='koi8-r', koi8r='koi8-r',
	['koi8-u']='koi8-u', cskoi8u='koi8-u', ['koi8-ru']='koi8-u',
	['windows-31j']='windows-31j', cswindows31j='windows-31j',
	['windows-1250']='windows-1250', cswindows1250='windows-1250', ['x-cp1250']='windows-1250', cp1250='windows-1250', ['ms-ee']='windows-1250',
	['windows-1251']='windows-1251', cswindows1251='windows-1251', ['x-cp1251']='windows-1251', cp1251='windows-1251', ['ms-cyrl']='windows-1251',
	
	['win-1251']='windows-1251',	-- такого чарсета в описаниях нет, но он есть на playset.ru
	
	['windows-1252']='windows-1252', cswindows1252='windows-1252', ['x-ansi']='windows-1252', cp1252='windows-1252', ['ms-ansi']='windows-1252',
	['windows-1253']='windows-1253', cswindows1253='windows-1253', cp1253='windows-1253', ['ms-greek']='windows-1253',
	['windows-1254']='windows-1254', cswindows1254='windows-1254', cp1254='windows-1254', ['ms-turk']='windows-1254',
	['iso-8859-1']='iso-8859-1', ['iso-ir-100']='iso-8859-1', ['iso_8859-1']='iso-8859-1', latin1='iso-8859-1', l1='iso-8859-1', ibm819='iso-8859-1', cp819='iso-8859-1', csisolatin1='iso-8859-1', ['iso_8859-1:1987']='iso-8859-1', ['iso8859-1']='iso-8859-1',
	['iso-8859-2']='iso-8859-2', ['iso-ir-101']='iso-8859-2', ['iso_8859-2']='iso-8859-2', latin2='iso-8859-2', l2='iso-8859-2', csisolatin2='iso-8859-2', ['iso_8859-2:1987']='iso-8859-2', ['iso8859-2']='iso-8859-2',
	['iso-8859-5']='iso-8859-5', csisolatincyrillic='iso-8859-5', cyrillic='iso-8859-5', ['iso_8859-5']='iso-8859-5', ['iso_8859-5:1988']='iso-8859-5', ['iso-ir-144']='iso-8859-5', ['iso8859-5']='iso-8859-5',
	['iso-8859-7']='iso-8859-7', csisolatingreek='iso-8859-7', ['ecma-118']='iso-8859-7', elot_928='iso-8859-7', greek='iso-8859-7', greek8='iso-8859-7', ['iso_8859-7']='iso-8859-7', ['iso_8859-7:1987']='iso-8859-7', ['iso-ir-126']='iso-8859-7', ['iso8859-7']='iso-8859-7',
	['iso-8859-9']='iso-8859-9', ['iso_8859-9:1989']='iso-8859-9', latin5='iso-8859-9', l5='iso-8859-9', ['iso_8859-9']='iso-8859-9', ['iso-ir-148']='iso-8859-9', csisolatin5='iso-8859-9',
	['iso-8859-15']='iso-8859-15', latin9='iso-8859-15', ['iso_8859-15']='iso-8859-15', l9='iso-8859-15', ['latin-9']='iso-8859-15', ['iso8859-15']='iso-8859-15', csiso885915='iso-8859-15',
	['us-ascii']='us-ascii', ['iso-ir-6']='us-ascii', ['ansi_x3.4-1968']='us-ascii', ['ansi_x3.4-1986']='us-ascii', ['iso_646.irv:1991']='us-ascii', ['iso646-us']='us-ascii', us='us-ascii', ibm367='us-ascii', cp367='us-ascii', csascii='us-ascii', ascii='us-ascii', ['iso-ir-6us']='us-ascii',
	gbk='gbk', cp936='gbk', ms936='gbk', ['windows-936']='gbk', csgbk='gbk',
	gb2312='gb2312', csgb2312='gb2312',
	['euc-jp']='euc-jp', cseucpkdfmtjapanese='euc-jp', extended_unix_code_packed_format_for_japanese='euc-jp',
	shift_jis='shift_jis', ms_kanji='shift_jis', csshiftjis='shift_jis', ['shift-jis']='shift_jis', ['x-ms-cp932']='shift_jis', ['x-sjis']='shift_jis', sjis='shift_jis', cp932='shift_jis', ms932='shift_jis', shifft_jis='shift_jis', ['shifft_jis-ms']='shift_jis', ['sjis-ms']='shift_jis', ['sjis-open']='shift_jis', ['sjis-win']='shift_jis', ['windows-932']='shift_jis',
}

-- Соответствие названий кодировок номерам кодовых страниц
_CM_CODINGS = { ['utf-8']=65001, ['koi8-r']=20866, ['koi8-u']=21866, ['windows-31j']=932, ['windows-1250']=1250, ['windows-1251']=1251, ['windows-1252']=1252, ['windows-1253']=1253, ['windows-1254']=1254, ['iso-8859-1']=28591, ['iso-8859-2']=28592, ['iso-8859-5']=28595, ['iso-8859-7']=28597, ['iso-8859-9']=28599, ['iso-8859-15']=28605, ['us-ascii']=20127, gbk=936, gb2312=936, ['euc-jp']=20932, shift_jis=932 }

function _CM_GET_COMPLEX_USER_NAME(user)
	return _CM_OPTIONS.HaveDifferentUsers and user.Name or ''
end

function _CM_READ_FILE(fname, ErrMessage)
-- Возвращает содержимое файла с именем fname
-- Если при чтении файла возникла ошибка, то:
	-- возвращает пустую строку, а вторым параметром - сообщение об ошибке
	-- если ErrMessage = false, то сообщение об ошибке не выводится
	-- если ErrMessage, то в лог НС и всплывающее окно выводится это сообщение, иначе штатное Lua
	local f, err = io.open(fname, 'rb')
	if f then
		local ret = f:read('*a')
		f:close()
		return ret
	end
	if ErrMessage~=false then
		hc.put_to_log('Content Master:\r\n', ErrMessage or err)
		hc.put_msg('Content Master:\r\n', ErrMessage or err)
	end
	return '', err
end

function _CM_WRITE_FILE(fname, mode, ...)
	local path = fname:match('^.*\\')
	if path then hc.prepare_path(path) end
	local f, err = io.open(fname, mode)
	if f then
		f:write(...)
		f:close()
		return true
	end
	hc.put_to_log('Content Master:\r\n', err)
	hc.put_msg('Content Master:\r\n', err)
end

function _CM_IS_FILE_EXIST(fname)
	local f, err = io.open(fname, 'rb')
	if f then
		f:close()
		return true
	end
end

_CM_FILTER_CODES = {
	J = 'ContentMaster: Remove by comment',
	C = 'ContentMaster: Remove by class/id',
	K = 'ContentMaster: Remove by size',
	P = 'ContentMaster: Remove scripts with text',
	R = 'ContentMaster: Replace text',
	G = 'ContentMaster: Insert CSS',
	AC = 'ContentMaster: Insert JS',
	V = 'ContentMaster: No filtering on URL',
	X = 'ContentMaster: Remove interactively',
	Z = 'ContentMaster: Remove by start tag',
	AA = 'ContentMaster: Remove elements and blocking by URL',
	AB = 'ContentMaster: Block request by IP',
	O = 'AdMuncher: Block retrieval of URL',
	I = 'AdMuncher: Remove images/etc with URL',
	L = 'AdMuncher: Remove links to URL',
	T = 'AdMuncher: Remove tables with text',
	D = 'AdMuncher: Remove divs/spans with text',
	S = 'AdMuncher: Remove scripts with text',
	F = 'AdMuncher: Remove forms with text',
	Y = 'AdMuncher: Remove images with "alt" text',
	E = 'AdMuncher: Replace text',
	U = 'AdMuncher: No filtering on URL',
	Q = 'AdMuncher: Don\'t match against keyword',
	AD = 'AdMuncher: Add javascript to all pages',
	AE = 'AdMuncher: Add CSS to all pages',
	M = 'AdBlockPlus: Remove elements by URL',
	A = 'AdBlockPlus: Element hiding',
	N = 'AdBlockPlus: Do not track',
}


function PREPARE_CM_RESPONSE_HEADER(answer_header)	-- оформляет ответ клиенту с учетом различных требований HTTP
	local request_header = hc.request_header
	local origin = request_header:match('[\r\n]Origin:[^%S\r\n]*(%S+)')
	if origin then	-- надо выполнить дополнительные требования при ответе на запрос с заголовком Origin (https://habrahabr.ru/post/219895/)
		answer_header = answer_header:gsub('\r\n', '\r\nAccess-Control-Allow-Origin: ' .. origin .. '\r\n', 1)
		if request_header:match('[\r\n]Cookie:') or request_header:match('[\r\n]Authorization:') then
			answer_header = answer_header:gsub('\r\n', '\r\nAccess-Control-Allow-Origin: true\r\n', 1)
		end
	end
	return answer_header
end


function _CM_UNQOUTIFY(str, quote)
	-- replaced_fragment = re.replace(replaced_fragment, [[~=~=~\K~=~=~[!@](.*?)~=~=~]], [[ + \1]], true)
	-- replaced_fragment = re.replace(replaced_fragment, [[~=~=~@(.*?)~=~=~]], [[" + \1]], true)	-- пробел между знаком "плюс" не убирать, т.к. возможная конструкция с унарным "плюсом": A + +B
	if quote=='"' then
		str = str:gsub('~=~=~~=~=~@', ' + '):gsub('~=~=~@(.-)~=~=~(.)', '" + %1 + "%2'):gsub('~=~=~@(.-)~=~=~$', '" + %1')
	else
		str = str:gsub('~=~=~~=~=~!', ' + '):gsub('~=~=~!(.-)~=~=~(.)', '\' + %1 + \'%2'):gsub('~=~=~!(.-)~=~=~$', '\' + %1')
	end
	str = str:gsub('#!!!#', '\''):gsub('#@@@#', '"')
	return str
end


function _CM_TO_LOG(fragment, replacement, RuleCode, IsException, RuleType, quotified)
-- hc.put_to_log(tostring(fragment))
	if quotified then
		fragment = quotified .. _CM_UNQOUTIFY(fragment, quotified) .. quotified
		if replacement then replacement = quotified .. _CM_UNQOUTIFY(replacement, quotified) .. quotified end
	end
	_CM_CURRENT_REQUEST_DATA.LogFragment2 = (_CM_CURRENT_REQUEST_DATA.LogFragment2 or {})
	if not RuleCode then
		fragment = hc.recode(fragment, _CM_MESSAGES_CODING, _CM_CODINGS['utf-8'])
		table.insert(_CM_CURRENT_REQUEST_DATA.LogFragment2, { Filter = fragment })
		return
	end
	local t = {}
	local fnum, rule, strnum = RuleCode:match('^(%d+)(%D+)(%d+)')
	if fnum then
		fnum, strnum = tonumber(fnum), tonumber(strnum)
		local ParserFilter = _CM_FILTER_CODES[rule]
		t = {
			UserName = _CM_USER.Name,
			IsException = IsException,
			Parser = ParserFilter:match('^[^:]+'),
			Filter = ParserFilter:match(':%s*(.*)'),
			FileNumber = fnum,
			StrNumber = strnum,
			RuleText = hc.get_global_table_item('CM_ORIGINAL_RULES', ParserFilter:match('^[^:]+'))[fnum][strnum],
			RuleType = RuleType,
		}
	end
	if fragment then
		if _CM_CURRENT_REQUEST_DATA.Charset~='utf-8' then fragment = hc.recode(fragment, _CM_CODINGS[_CM_CURRENT_REQUEST_DATA.Charset], _CM_CODINGS['utf-8']) end
		if IsException then t.Fragment = fragment
		else
			if replacement then
				if not fnum then t.Filter = RuleCode end
				t.Fragment = fragment
				t.Replacement = replacement
			else t.Fragment = fragment
			end
		end
	end
	table.insert(_CM_CURRENT_REQUEST_DATA.LogFragment2, t)
end

function _CM_SAVE_HITS()
	
	local old_path = package.path
	package.path = hc.script_name:match('.*\\') .. '?.lua'
	local json = require('dkjson')
	package.path = old_path
	
	_CM_WRITE_FILE(_CM_DIR .. 'log\\stat.json', 'wb', json.encode(hc.get_global('CM_HITS')))
end

function _CM_FIND_SOURCE_BY_URL(url, SourceList)
	for _,source in ipairs(SourceList or (_CM_USERS and _CM_USERS.ALL.Sources) or loadstring(hc.get_global('CM_USERS'))().ALL.Sources) do
		if source.URL==url then return source end
	end
end

function _CM_GET_FILTER_FILE_PATH_FROM_URL(url, sources)
	local parser, fname = url:match('^https?://local%.cm/rules/(%w+)/(.*)')
	if parser then
		return _CM_DIR .. 'rules\\local\\' .. parser .. '\\' .. fname
	else
		local source = _CM_FIND_SOURCE_BY_URL(url, sources)
		if source then
			return _CM_DIR .. 'rules\\remote\\' .. source.Parser .. '\\' .. url:match('.*/(.*)')
		end
	end
end

function _CM_UPDATE_CORE()
	hc.set_global('CM_UPDATE_COUNTER', (hc.get_global('CM_UPDATE_COUNTER') or 0) + 1)
	hc.send_request('GET ' .. _CM_FOLDER_URL .. 'update_package.gz HTTP/1.1\r\nUser-Agent: ContentMaster\r\nCM-Info: UpdateCM\r\nConnection: close\r\n\r\n')
	while hc.get_global('CM_UPDATE_COUNTER')>0 do	-- ждем пока закончится обновление файла
		hc.sleep(200)
	end
	_CM_USERS = _CM_USERS or loadstring(hc.get_global('CM_USERS'))()
	if _CM_USERS.ALL.EnablePopupsAndSound then
		_CM_OPTIONS = hc.get_global('CM_OPTIONS')
		local lng = _CM_PREPARE_LANGUAGE(_CM_OPTIONS.LanguageID, true)	-- создаем переводчик с англ. языка на текущий язык НС
		hc.put_msg('Content Master:\r\n' .. lng['Extension was updated'])
		hc.play_sound('SystemExclamation')
	end
end

function _CM_UPDATE_FILTERS()
	_CM_UPDATE_REMOTE_SOURCES(true)
	while hc.get_global('CM_UPDATE_COUNTER')>0 do
		hc.sleep(400)
	end
	_CM_OPTIONS = hc.get_global('CM_OPTIONS')
	local lng = _CM_PREPARE_LANGUAGE(_CM_OPTIONS.LanguageID, true)	-- создаем переводчик с англ. языка на текущий язык НС
	hc.put_msg('Content Master:\r\n' .. lng['Filters was updated'])
end

function _CM_UPDATE_REMOTE_SOURCES(forceUpdate)
	hc.set_global('CM_UPDATE_COUNTER', hc.get_global('CM_UPDATE_COUNTER') or 0)
	local function update(source)
		-- пытаемся скачать удаленный файл
		if source.URL:match('^https') then
			local url, host, domain = _CM_NORMALIZE_URL(source.URL)
			local https_header = 'CONNECT ' .. domain .. ':443 HTTP/1.1\r\nHost: ' .. domain .. '\r\nCM-Info: UpdateSource-' .. source.Parser .. '\r\nConnection: keep-alive\r\n\r\n'
			hc.send_request('GET ' .. source.URL .. ' HTTP/1.1\r\nUser-Agent: ContentMaster\r\nCM-Info: UpdateSource-' .. source.Parser .. '\r\nConnection: close\r\n\r\n', '', https_header)
		else
			hc.send_request('GET ' .. source.URL .. ' HTTP/1.1\r\nUser-Agent: ContentMaster\r\nCM-Info: UpdateSource-' .. source.Parser .. '\r\nConnection: close\r\n\r\n')
		end
		hc.set_global('CM_UPDATE_COUNTER', hc.get_global('CM_UPDATE_COUNTER') + 1)
	end
	local users = loadstring(hc.get_global('CM_USERS'))()
	local sources = users.ALL.Sources
	local local_user_name = next(hc.get_users_stat("#local"))
	local some_updates_failed
	for _,source in ipairs(sources) do
-- if hc.event ~= 'Init' then hc.put_to_log(source.URL) end
		if not source.URL:match('^https?://local%.cm/') then	-- только для удаленных источников
			local SSL_enabled = hc.ssl_handling_enabled(source.URL, local_user_name)
			if source.URL:match('^http:') or (source.URL:match('^https:') and SSL_enabled) then	-- для источника разрешена обработка SSL
				if forceUpdate then
					update(source)
				else
					local f, err = io.open(_CM_GET_FILTER_FILE_PATH_FROM_URL(source.URL, sources), 'rb')
					if f then f:close()
					else update(source)	-- обновляем только если на диске нет файла
					end
				end
				source.FailedUpdate = nil
			elseif source.URL:match('^https:') and not SSL_enabled then	-- обработка SSL запрещена
				if forceUpdate then
					source.FailedUpdate = "Last download was failed. Check Handycache 'SSL handling' is ON"	-- устанавливаем признак неудачного последнего обновления
					some_updates_failed = true
				else
					local f, err = io.open(_CM_GET_FILTER_FILE_PATH_FROM_URL(source.URL, sources), 'rb')
					if f then
						f:close()
						source.FailedUpdate = nil
					else
						source.FailedUpdate = "Last download was failed. Check Handycache 'SSL handling' is ON"	-- устанавливаем признак неудачного последнего обновления
						some_updates_failed = true
					end
				end
			end
		end
	end
	hc.set_global('CM_USERS', _CM_SAVE_TABLE(users))
	if some_updates_failed then
		hc.put_msg('Fail to download some files\r\nCheck Handycache "SSL handling" is ON')
	end
end

function _CM_LOCALIZE_PCRE_ERROR(regex, ErrorText, engine)
	local LocalizedError
	local err_position = ErrorText:match('at (%d+) position')
	if err_position then
		local err_rule_hash = regex:match('%(%*:([^)]+)', tonumber(err_position))
		if err_rule_hash then
			local err_code = hc.get_global_table_item('CM_RULES_SOURCE', err_rule_hash)
			local fnum, rule, strnum = err_code:match('^(%d+)(%D+)(%d+)')
			fnum, strnum = tonumber(fnum), tonumber(strnum)
			local ParserName = _CM_FILTER_CODES[rule]:match('^[^:]+')
			local fname = _CM_GET_FILTER_FILE_PATH_FROM_URL(_CM_USERS.ALL.Parsers[ParserName].Files[fnum].URL)
			local f, f_err = io.open(fname, 'rb')
			if f then
				local FileContent = f:read('*a')
				f:close()
				if FileContent:match('^%s*[%[{]') then	-- это json

					local old_path = package.path
					package.path = hc.script_name:match('.*\\') .. '?.lua'
					local json = require('dkjson')
					package.path = old_path
					
					local rules = json.decode(FileContent)
					local log_record = ''
					for k,v in pairs(rules[strnum]) do
						log_record = log_record .. '\r\n   ' .. k .. ' = ' .. tostring(v)
					end
					LocalizedError = 'File: ' .. fname .. '\r\nRule ' .. strnum .. ':' .. tostring(log_record) .. '\r\n\r\nFilter "' .. _CM_FILTER_CODES[rule] .. '" is turned off.'
				else
					local err_str = re.find(FileContent, [[\A(?>.*?\r?+\n){]] .. (strnum-1) .. [[}\K[^\r\n]++]])
					LocalizedError = 'File: ' .. fname .. '\r\nLine ' .. strnum .. ': ' .. tostring(err_str) .. '\r\n\r\nFilter "' .. _CM_FILTER_CODES[rule] .. '" is turned off.'
				end
			end
		else hc.put_to_log('Error hash: ', tostring(err_rule_hash))
		end
	end
	hc.put_msg('Erroneous regular expression:\r\n', err, '\r\nSome Content Master functions are blocked\r\n(see more in НС log)')
	if LocalizedError then hc.put_to_log('\r\n', engine, ' engine error:\r\n', ErrorText:gsub('at (%d+) position', ''), '\r\n\r\nError probably located at ', LocalizedError, '\r\nPlease check your regular expression.')
	else hc.put_to_log(hc.url, '\r\n', engine, ' engine ', ErrorText, '\r\n\r\nSome Content Master functions are blocked\r\nErroneous regular expression:\r\n', tostring(regex))
	end
end

function _CM_PREPARE_LANGUAGE(LanguageID, DecodeFromUTF)
	local lng = {}
	local lngtable = { [1049]='russian' }
	local current_language = lngtable[LanguageID] or 'english'
	local lngfile = hc.get_global_table_item('CM_LANGUAGES', current_language)
	if not lngfile then
		lngfile = _CM_READ_FILE(_CM_DIR .. 'language\\' .. current_language .. '.lng', false)
		hc.set_global_table_item('CM_LANGUAGES', current_language, lngfile)
	end
	for engl,native in lngfile:gmatch('#~#(.-)#~#(.-)#~#') do lng[engl] = native end
	local MessagesCoding
	if DecodeFromUTF then
		local DecodeIdTable = { [1049]=1251 }
		if DecodeIdTable[LanguageID] then
			MessagesCoding = DecodeIdTable[LanguageID]
			for i,v in pairs(lng) do lng[i] = hc.recode(v, 65001, MessagesCoding) end
		end
	end
	local lngmetatable = { __index=function(table, key) return key end }
	setmetatable(lng, lngmetatable)
	return lng, MessagesCoding
end

function _CM_TO_REGEXP(str, hc)	-- преобразовывает из простой формы в регэксп
	return (str:gsub('[.+|(){}[%]\\$^#%s ]', '\\%0'):	-- замена спецсимволов
		gsub('%?', hc and '.' or '\\?'):			-- для правил НС '?' заменяется на '.', иначе на '\?'
		gsub('^%*', ''):gsub('%*$', ''):			-- удаление первой и последней '*'
		gsub('%*', '(*THEN).*?'))					-- замена спецсимвола '*'
end


local no_toplevel_alts = [=[\A(?-i)([^\\[()|]++|\\(?>Q.*?\\E|.)|\[(?>[^\\\][]++|\\.|\[:\w++:\]|\[)*+\]|\((?:(?>\*(?>MARK|SKIP|THEN|):|\?\#)[^)]*+|(?>(?-1)|.)*?)\)|[^|])*+\z]=]
-- local AdBlockDelimiter = [[(?>[^\w.%-]|\z)]]
_CM_UP_DOMAINS_REGEXP = [[(?:|[^/?]*?\.)]]
_CM_IMG_STR = [[(?=[^?]*?\.(?>bmp|gif|ico|jpe?g|png|svg|tiff?)\b).*?]]
_CM_URL_WWW_REGEXP = [[(?>www\.|)]]
local IndexRegex = [[\A(?-i)(?>[^\\*+?[({|][?*+]*+(?!{)|\\(?>Q.*?\\E|(?>x..|.)[?*+]*+(?!{))|\Q]] .. _CM_UP_DOMAINS_REGEXP .. [[\E|\Q]] .. _CM_IMG_STR .. [[\E|\Q]] .. _CM_URL_WWW_REGEXP .. [[\E|)]]
function _CM_REGEXP_FROM_LIST(lst, UTF)	-- преобразование списка регэкспов в один регэксп
	if not lst[1] then return '' end

	re.set_regex(no_toplevel_alts)
	local alts_lst, no_alts_lst = {}, {}
	for _,rule in ipairs(lst) do
		if not rule:find('|', 1, true) or re.find(rule) then
			table.insert(no_alts_lst, rule)
		else
			table.insert(alts_lst, '(?:' .. rule .. ')')	-- в скобки, т.к. если без них, то выражения типа (?|(a)|b(?-1)) дадут ошибку PCRE
		end
	end

	re.set_regex(UTF and ('(*UTF8)(*UCP)' .. IndexRegex) or IndexRegex)
	local function delist(lst)
		if not lst[2] then return lst[1] end
		local lst_tmp, s = {}, {}
		for _,rule in ipairs(lst) do
			local index = re.find(rule)
			if #index==1 and (not UTF or index:byte()<128) then index = index:lower() end	-- если UTF, то регистр у символов >127 менять на нижний нельзя
			if not lst_tmp[index] then lst_tmp[index] = {} end
			table.insert(lst_tmp[index], rule:sub(#index+1))
		end
		for ind,v in pairs(lst_tmp) do
			if ind=='' then 
				for _,k in ipairs(v) do
					if k:match('^%(%*:[^)]*%)$') then v = {k} break end
				end
				table.insert(s, v[2] and ('(?|' .. table.concat(v, '|') .. ')') or v[1])
			else table.insert(s, ind .. delist(v))
			end
		end
		for _,k in ipairs(s) do
			if k:match('^%(%*:[^)]*%)$') then return k end
		end
		return s[2] and ('(?|' .. table.concat(s, '|') .. ')') or s[1]
	end

	return (no_alts_lst[1] and delist(no_alts_lst) or '') .. (alts_lst[1] and ((no_alts_lst[1] and '|' or '') .. table.concat(alts_lst, '|')) or '')
end


-- если в регэкспе r есть альтернативы верхнего уровня, то он обрамляется скобками
function _CM_BRACKETS_IF_TOPLEVEL_ALTS(r)
	return (re.find(r, no_toplevel_alts) and r or ('(?:' .. r .. ')'))
end


function _CM_ENCODE_FUNCTION(f)
	return hc.encode_base64(string.dump(f))
end


function _CM_DECODE_FUNCTION(f)
	return loadstring(hc.decode_base64(f))
end


-- отсекает в УРЛ префиксы, добавляемые WebWarper и OperaTurbo, преобразует из punycode в национальные символы, деобфусцирует
function _CM_NORMALIZE_URL(url)


	-- ============================== РАСКРЫТИЕ URL, СПРЯТАННЫХ ЗА СЕРВИСОМ-СОКРАЩАТЕЛЕМ ССЫЛОК (ИЛИ ИНЫМ РЕДИРЕКТОМ) ==============================
	local redirected
	while true do	-- настоящий URL может быть скрыт сокращателем (редиректором) или их цепочкой
		local t, err, mark = re.find(url, _CM_OPTIONS.ShortenersRegexp)
		if not t then break end
		local cache_indx = 'shorten' .. _CM_GET_COMPLEX_USER_NAME(_CM_USER) .. url
		local entry = hc.get_global_table_item('CM_URL_CACHE', cache_indx)
		if not entry then
			local fcontent = _CM_READ_FILE(hc.cache_path .. hc.prepare_url(url) .. '#m', false)
			if #fcontent > 0 then
				entry = fcontent:match('[lL]ocation:[^%S\r\n]*([^\r\n]+)')
			end
			if not entry then
				entry = loadstring(hc.get_global_table_item('CM_RULES_ADDITIONS', mark))(url)
				if not entry then break end
			end
		end
		redirected = true
		url = entry
	end
	-- ============================== КОНЕЦ РАСКРЫТИЯ URL, СПРЯТАННЫХ ЗА СЕРВИСОМ-СОКРАЩАТЕЛЕМ ССЫЛОК ==============================


	-- ============================== ДЕОБФУСКАЦИЯ URL ==============================
	if url:match('aHR0c') then
		url = url:
			gsub('^.-%?url=(aHR0c[%w=]*).*', function(s) return hc.decode_base64(s) end, 1):	-- попытка обобщения двух последующих правил
			-- gsub('/ref%?url=(aHR0c[%w=]*)', function(s) return hc.decode_base64(s) end, 1):	-- пока только gismeteo.ru: https://www.gismeteo.ru/ref?url=aHR0cDovL2FkLmFkcml2ZXIucnUvY2dpLWJpbi9jbGljay5jZ2k/c2lkPTEmYWQ9NTMyNjI0JmJ0PTIxJnBpZD0yMDU3NzYzJmJpZD0zOTUwMDY1JmJuPTM5NTAwNjUmcm5kPTEzMjc5NzY2Mw==
			gsub('^.-/go%.php%?%w+=(aHR0c[%w=]*).*', function(s) return hc.decode_base64(s) end, 1):	-- https://www.watchfree.to/go.php?gtfo=<base64_coded_url>
			gsub('^.-/cgi%-bin/goto%.cgi%?q=(aHR0c[%w=]*).*',  function(s) return hc.decode_base64(s) end, 1):	-- http://movpod.in/cgi-bin/goto.cgi?q=<base64_coded_url>
			gsub('^.-/engine/dude/index/leech_out%.php%?[ai][%:]3?[aA]?(aHR0c[%w=]*).*', function(s) s = s:gsub('%%3[dD]', '=') return hc.decode_base64(s) end, 1):	-- dude Smart Leech - модуль для движка сайтов dle. Н-р, http://nemo-crack.org/engine/dude/index/leech_out.php?a%3AaHR0cDovL2hvdC1nYW1lLmluZm8v
			gsub('^https://secure%.link/(aHR0c[%w=]*).*',  function(s) return hc.decode_base64(s) end, 1)	-- этот eyrn должен оставатьсЯ последним из-за двойного кодированиЯ. Ќ-р некоторые https://www.watchfree.to/go.php?gtfo=<base64_coded_url> раскодируютсЯ в https://secure.link/<base64_coded_url>
	end
	-- ============================== КОНЕЦ ДЕОБФУСКАЦИИ URL ==============================

	url = url:
		gsub('^SOCKS5: Connect to (.*):443$', 'https://%1'):
		gsub('^SOCKS5: Connect to (.*)', 'http://%1'):
		gsub('^(http://)%w+%-turbo[^%.]*%.opera%-mini%.net:80/', '%1', 1):	-- Opera Turbo
		gsub('^http://www%.webwarper%.net/ww/([^~])', 'http://%1', 1):				-- Web Warper
		gsub('^http://www%.webwarper%.net/ww/~clientscriptgz/', 'http://', 1):		-- Web Warper
		gsub('%%3A', ':'):gsub('%%2F', '/'):gsub('%%2E', '.'):gsub('%%3F', '?'):gsub('%%3D', '='):gsub('%%26', '&'):
		gsub('([/.])xn%-%-([%a%d-]+)', function(s1, s2) return s1 .. hc.recode(s2, _CM_OPTIONS.SystemCoding+200000, _CM_CODINGS['utf-8']) end)	-- Punycode
		
	return url,	((url:match('^https?://[^:/?]*') or '') .. '/'), (url:match('^https?://([^:/?]*)') or ''), redirected	-- возвращаем также имя хоста и домена и признак редиректа
end


function _CM_HASH(...)
	local crc, t, bracket = hc.crc32(table.concat({...})), {}, string.byte(')')
	while crc>0 do
		local crc2 = (crc % 126) + 1
		if crc2==bracket then crc2 = 127 end	-- закрывающая скобка - недопустимый символ
		table.insert(t, crc2)
		crc = math.floor(crc / 126)
	end
	return string.char(unpack(t))
end


function _CM_GET_RULE_HASH(rule, extra)
	local tmp_table, rule_uniquator = {}, {}
	for par_name,parameter in pairs(rule) do
		if par_name~='Comment' and par_name~='Tags' and par_name~='Off' and par_name~='Hash' then
			table.insert(tmp_table, { par_name, tostring(parameter) })
		end
	end
	table.sort(tmp_table, function(e1, e2) return e1[1]<e2[1] end)
	for _,v in ipairs(tmp_table) do
		table.insert(rule_uniquator, tostring(v[2]))
	end
	return _CM_HASH(table.concat(rule_uniquator) .. (extra or ''))
end

function _CM_PREPARE_ORIGINAL_RULES(Users, sources)
	-- if Users.ALL.Log.On then

		local old_path = package.path
		package.path = hc.script_name:match('.*\\') .. '?.lua'
		local json = require('dkjson')
		package.path = old_path

		local function parser_on(user, parser_name, slf)
			if not slf and user.Parsers[parser_name].On then return true end
			for _,child_user in ipairs(user) do
				if parser_on(child_user, parser_name) then return true end
			end
		end
		local function file_on(user, parser_name, file_number, slf)
			if not slf and user.Parsers[parser_name].Files[file_number].On then return true end
			for _,child_user in ipairs(user) do
				if file_on(child_user, parser_name, file_number) then return true end
			end
		end
		
		local logs = {}
		for ParserName,Parser in pairs(Users.ALL.Parsers) do
			if parser_on(Users.ALL, ParserName, true) then
			logs[ParserName] = {}
				for FileNumber,File in ipairs(Parser.Files) do
					if file_on(Users.ALL, ParserName, FileNumber, true) then
						local f, err = _CM_READ_FILE(_CM_GET_FILTER_FILE_PATH_FROM_URL(File.URL, sources), false)
						if f then
							logs[ParserName][FileNumber] = {}
							if ParserName=='ContentMaster' and f:match('^%s*[%[{]') then	-- это json
								for ruleNumber,rule in ipairs(json.decode(f)) do
									logs[ParserName][FileNumber][ruleNumber] = rule.Find
								end
							else
								local StrNumber = 0
								for str in f:gmatch('[^%S\r\n]*([^\r\n]*)\r?\n?') do
									StrNumber = StrNumber + 1
									logs[ParserName][FileNumber][StrNumber] = str:match('^%s*(.*)')
								end
							end
						else hc.put_to_log('Content Master - _CM_PREPARE_ORIGINAL_RULES:\r\n', err)
						end
					end
				end
			end
		end
		hc.set_global('CM_ORIGINAL_RULES', logs)
	-- end
end

_CM_WORKER = {}
function _CM_WORKER:New(o)
	if not self.Rules then
		local rules_index, Rules = _CM_GET_COMPLEX_USER_NAME(_CM_USER) .. '##' .. o.ContentType
		while true do	-- если правила уже создаются в параллельном потоке, то ждем
			Rules = hc.get_global_table_item('CM_RULES', rules_index)
			if Rules~=false then break end
			hc.sleep(100)
		end
		o.Rules = Rules or self.CreateRules(rules_index, o.InitFileName)
	end
	o.ReplaceCount = 0	-- счетчик числа срабатываний
	setmetatable(o, self)
	self.__index = self
	return o
end
function _CM_WORKER.CreateRules(rules_index, InitFileName)
	hc.set_global_table_item('CM_RULES', rules_index, false)
	local Rules = loadstring(_CM_READ_FILE(InitFileName))()
	-- Rules = f(Rules)	-- на самом деле CreateRules должна возвращать РАЗНЫЙ результат в зависимости от 
	hc.set_global_table_item('CM_RULES', rules_index, Rules)
	return Rules
end

function _CM_URL_CALLOUT(_, _, _, _, _, _, _, _, _, mark)
	local engine = re.engine
	re.engine = engine + 1
	local tmp = re.match(_CM_CURRENT_REQUEST_DATA.URL, (mark:gsub('####', ')')))
	re.engine = engine
	return tmp and 0 or 1
end

function _CM_SAVE_TABLE(...)
	local pairs, type, ipairs, tostring, select = pairs, type, ipairs, tostring, select
	local table_concat, table_remove = table.concat, table.remove
	local string_format, string_match = string.format, string.match
	local lua51_keywords = { ["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true, ["end"] = true, ["false"] = true, ["for"] = true,
		["function"] = true, ["if"] = true, ["in"] = true, ["local"] = true, ["nil"] = true, ["not"] = true, ["or"] = true, ["repeat"] = true, ["return"] = true,
		["then"] = true, ["true"] = true, ["until"] = true, ["while"] = true }

	local function serialize_number(number)
		-- no argument checking - called very often
		local text = ("%.17g"):format(number)
			:gsub(',','.',1)	-- если в системе выставлен формат десятичного разделителя "," вместо "."
		-- on the same platform tostring() and string.format()
		-- return the same results for 1/0, -1/0, 0/0
		-- so we don't need separate substitution table
		return text
	end

	-- local t = { [tostring(1/0)] = "1/0"; [tostring(-1/0)] = "-1/0"; [tostring(0/0)] = "0/0"; }
	-- local function serialize_number(number)
		-- local text = ("%.17g"):format(number)
		-- return t[text] or text
	-- end

	local cur_buf
	local function cat(v)
		cur_buf[#cur_buf + 1] = v
	end

	local function explode_rec(t, add, vis, added)
		local t_type = type(t)
		if t_type == "table" then
			if not (added[t] or vis[t]) then
				vis[t] = true
				for k,v in pairs(t) do
					explode_rec(k, add, vis, added)
					explode_rec(v, add, vis, added)
				end
			elseif not added[t] and vis[t] then
				add[#add+1] = t
				added[t] = { name="_[" .. #add .. "]", num=#add }
			end
		end
	end

  local parse_rec
  do
    local started

    local function impl(t, added, rec_info)
      local t_type = type(t)
      local rec = false
      if t_type == "table" then
        if not added[t]or not started then
          started = true
          for k, v in pairs(t) do
            if impl(k, added, rec_info) or impl(v, added, rec_info) then
              rec = true
              if type(k) == "table" then
                rec_info[k] = true
              end
              if type(v) == "table" then
                rec_info[v] = true
              end
            end
          end
        else
          return true
        end
      end
      return rec
    end

    parse_rec = function(t, added, rec_info)
      started = false
      rec_info[t] = true
      impl(t, added, rec_info)
    end

  end
  local function recursive_proceed(t, added, rec_info, after, started)
    local t_type = type(t)
    if t_type == "table" then
		if not started or not added[t] then
			local started = true
			cat("{")
			-- Serialize numeric indices
			local next_i = 0
			for i, v in ipairs(t) do
				next_i = i
				if not (rec_info[i] or rec_info[v]) then
					if i ~= 1 then cat(",") end
					recursive_proceed(v, added, rec_info, after, started)
				else
					next_i = i - 1
					break
				end
			end
			next_i = next_i + 1
			-- Serialize hash part
			-- Skipping comma only at first element if there is no numeric part.
			local comma = (next_i > 1) and "," or ""
			for k, v in pairs(t) do
				local k_type = type(k)
				if not (rec_info[k] or rec_info[v]) then
					-- that means, if the value does not contain a recursive link
					-- to the table itself
					-- and the index does not contain a recursive link...
					if k_type == "string"  then
						cat(comma)
						comma = ","
						-- check if we can use the short notation
						-- eg {a=3,b=5} istead of {["a"]=3,["b"]=5}
						if not lua51_keywords[k] and string_match(k, "^[%a_][%a%d_]*$")
						then cat(k); cat("=")
						else cat(string_format("[%q]=", k))
						end
						recursive_proceed(v, added, rec_info, after, started)
					elseif
						k_type ~= "number" or -- non-string non-number
						k >= next_i or k < 1 or -- integer key in hash part of the table
						k % 1 ~= 0 -- non-integral key.
					then
						cat(comma)
						comma = ","
						cat("[")
						recursive_proceed(k, added, rec_info, after, started)
						cat("]")
						cat("=")
						recursive_proceed(v, added, rec_info, after, started)
					end
				else after[#after + 1] = {k,v}
				end
			end
			cat("}")
		else cat(added[t].name)	-- already visited!
		end
    elseif t_type == "string" then cat(string_format("%q", t))
    elseif t_type == "number" then cat(serialize_number(t))
    elseif t_type == "boolean" then cat(tostring(t))
    elseif t == nil then cat("nil")
    else return nil
    end
    return true
  end

	local function recursive_proceed_simple(t, added)
		local t_type = type(t)
		if t_type == "table" then
			if not added[t] then
				cat("{")
				-- Serialize numeric indices
				local next_i = 0
				for i, v in ipairs(t) do
					next_i = i
					if i ~= 1 then cat(",") end
					recursive_proceed_simple(v, added)
				end
				next_i = next_i + 1
				-- Serialize hash part
				-- Skipping comma only at first element if there is no numeric part.
				local comma = (next_i > 1) and "," or ""
				for k, v in pairs(t) do
					local k_type = type(k)
					if k_type == "string"  then
						cat(comma)
						comma = ","
						-- check if we can use the short notation
						-- eg {a=3,b=5} istead of {["a"]=3,["b"]=5}
						-- if not lua51_keywords[k] and string_match(k, "^[%a_][%a%d_]*$") then cat(k); cat("=")
						-- else cat(string_format("[%q]=", k))
						-- end
						-- это не работает с национальными символами, поэтому всегда используем "long notation"
						cat(string_format("[%q]=", k))
						recursive_proceed_simple(v, added)
					elseif k_type ~= "number" or	-- non-string non-number
						k >= next_i or k < 1 or	-- integer key in hash part of the table
						k % 1 ~= 0 then				-- non-integral key
						cat(comma)
						comma = ","
						cat("[")
						recursive_proceed_simple(k, added)
						cat("]")
						cat("=")
						recursive_proceed_simple(v, added)
					end
				end
				cat("}")
			else cat(added[t].name)	-- already visited!
			end
		elseif t_type == "string" then cat(string_format("%q", t))
		elseif t_type == "number" then cat(serialize_number(t))
		elseif t_type == "boolean" then cat(tostring(t))
		elseif t == nil then cat("nil")
		else return nil
		end
		return true
	end

	local function afterwork(k, v, buf, name, added)
		cur_buf = buf
		cat(" ")
		cat(name)
		cat("[")
		local after = buf.afterwork
		if not recursive_proceed_simple(k, added) then return false end
		cat("]=")
		if not recursive_proceed_simple(v, added) then return false end
		cat(" ")
		return true
	end

  --===================================--
  --===========THE MAIN PART===========--
  --===================================--
    --PREPARATORY WORK: LOCATE THE RECURSIVE AND SHARED PARTS--
    local narg = select("#", ...)
    local visited = {}
    -- table, containing recursive parts of our variables
    local additional_vars = { }
    local added = {}
    for i = 1, narg do
      local v = select(i, ...)
      explode_rec(v, additional_vars, visited, added) -- discover recursive subtables
    end
    visited = nil -- no more needed
    local nadd = #additional_vars
    -- SERIALIZE ADDITIONAL FIRST --
    local rec_info = {}

    for i = 1, nadd do
      local v = additional_vars[i]
      parse_rec(v, added, rec_info)
    end
    local buf = {}
    for i = 1, nadd do
      local v = additional_vars[i]
      buf[i] = {afterwork = {}}
      local after = buf[i].afterwork
      cur_buf = buf[i]
      if not recursive_proceed(v, added, rec_info, after) then
        return nil, "Unserializable _CM_CURRENT_REQUEST_DATA in parameter #" .. i
      end
    end

    rec_info = {}
    for i = 1, nadd do
      local v = additional_vars[i]
      buf[i].afterstart = #buf[i]
      for j = 1, #(buf[i].afterwork) do
        if not afterwork(
              buf[i].afterwork[j][1],
              buf[i].afterwork[j][2],
              buf[i],
              added[v].name,
	      added
            )
        then
          return nil, "Unserializable _CM_CURRENT_REQUEST_DATA in parameter #" .. i
        end
      end
    end

    -- SERIALIZE GIVEN VARS --

    for i = 1, narg do
      local v = select(i, ...)
      buf[i + nadd] = {}
      cur_buf = buf[i + nadd]
      if not recursive_proceed_simple(v, added) then
        return nil, "Unserializable _CM_CURRENT_REQUEST_DATA in parameter #" .. i
      end
    end

    -- DECLARE ADDITIONAL VARS --
    local prevbuf = {}
    for v, inf in pairs(added) do
      prevbuf[ #prevbuf + 1] = "[" .. inf.num .. "]=" .. table_concat(buf[inf.num], "", 1, buf[inf.num].afterstart) .. ";"
    end

    -- CONCAT PARTS --
    for i = 1, nadd do buf[i] = table_concat(buf[i], "", buf[i].afterstart + 1) end
    for i = nadd + 1, nadd+narg do buf[i] = table_concat(buf[i]) end

    -- RETURN THE RESULT --
    if nadd == 0 then return "return " .. table_concat(buf, ",")
    else
      local rez = {
        "do local _={";
        table_concat(prevbuf, " ");
        '}';
        table_concat(buf, " ", 1, nadd);
        " return ";
        table_concat(buf, ",", nadd+1);
        " end";
      }
      return table_concat(rez)
    end
end

return true