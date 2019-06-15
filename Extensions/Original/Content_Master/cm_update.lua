
if hc.event=='RequestHeaderReceived' then
	hc.read_from_cache_on = false
	hc.white_mask = 'WBSDORU'
	
	if hc.method=='CONNECT' then return end
	
	local req_url, header = hc.url, hc.request_header
	if header:match('CM%-Info:%s*UpdateCM') then
		_CM_UPDATE_3 = 1
		hc.call_me_for('AnswerHeaderReceived')
	else
		local path = _CM_DIR .. req_url:sub(#_CM_FOLDER_URL + 1):gsub('/', '\\')
		hc.request_header = header:gsub('\r\n$', 'If-Modified-Since: ' .. hc.systime_to_str(hc.file_last_modified_time(path) or 0) .. '\r\n\r\n', 1)
		-- hc.request_header = re.replace(header, [[(*ANYCRLF)^Host:\s*+\K.*?$]], req_url:match('^https?://(.-)[/%?]'))

		hc.call_me_for('BeforeAnswerHeaderSend')
	end
elseif hc.event=='AnswerHeaderReceived' then
	if _CM_UPDATE_3 then
		_CM_BODY = ''
		hc.answer_header = hc.answer_header:gsub('(.*)\r\n$', '%1Content-Encoding: gzip\r\n\r\n', 1)
		hc.call_me_for('BeforeAnswerBodySend')
	end
elseif hc.event=='BeforeAnswerHeaderSend' then
-- hc.put_to_log(hc.url, '\r\n', hc.answer_header)
	if not hc.answer_header:match('^%S+%s*200%s') then
		hc.set_global('CM_UPDATE_COUNTER', hc.get_global('CM_UPDATE_COUNTER') - 1)
		return
	end
	_CM_BODY = ''
	hc.call_me_for('BeforeAnswerBodySend')
elseif hc.event=='BeforeAnswerBodySend' then
	_CM_BODY = _CM_BODY .. hc.answer_body
	if hc.last_part then
		loadstring(hc.get_global('CM_COMMON'))()	-- подгружаем библиотеку общих функций
		if _CM_UPDATE_3 then
			local Min_HC_Version = _CM_BODY:match('[\r\n]%s*@min_HC_version%s*(%S+)') or '0.0.0'
			local HC_Version = hc.version_number
			if HC_Version < Min_HC_Version then	-- если обновление СМ требует более высокой версии НС
				hc.put_msg('Content Master\r\n', lng["Can't update. Needed HandyCache version:"], ' ', Min_HC_Version)
				hc.play_sound('SystemHand')
				return
			end
			
			local package_length = _CM_BODY:match('^%d+')
			if not package_length or tonumber(package_length)~=(#_CM_BODY-#package_length) then
				hc.put_msg('ERROR\r\nContent Master is NOT updated')
				hc.play_sound('SystemHand')
				hc.set_global('CM_UPDATE_COUNTER', hc.get_global('CM_UPDATE_COUNTER') - 1)
				return
			end

			local StartDelimiter, EndDelimiter = 'CM##~~##~~##' .. 'Start', 'CM##~~##~~##' .. 'End'
			local regex = StartDelimiter .. '(%S+) (.-)' .. EndDelimiter
			for file,body in _CM_BODY:gmatch(regex) do
				local dir = file:match('(.*)/')
				if dir then hc.shell_execute('cmd', '/C md ' .. dir:gsub('/', '\\\\'), _CM_DIR, 'SW_HIDE', true) end
				_CM_WRITE_FILE(_CM_DIR .. file, 'wb', body)
			end
			hc.answer_body = _CM_BODY
			_CM_UPDATE_3 = nil
		elseif hc.request_header:match('CM%-Info:%s*UpdateSource') then
			local parser = hc.request_header:match('CM%-Info:%s*UpdateSource%-(%S*)')
			_CM_WRITE_FILE(_CM_DIR .. 'rules\\remote\\' .. parser .. '\\' .. hc.url:match('.*/(.+)'), 'wb', _CM_BODY)
		end
		hc.set_global('CM_UPDATE_COUNTER', hc.get_global('CM_UPDATE_COUNTER') - 1)
	end
end
