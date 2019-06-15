--[[ <HCExtension>
@name			Processor
@author			truefriend-cz
@version		1.2
@description	Script for Main operations (must use with truefriend-cz script pack only) - Extension list position priority: 1
@license		CC BY-NC-SA (Attribution-NonCommercial-ShareAlike - https://creativecommons.org/licenses/by-nc-sa/)
@event			BeforeViewInMonitor
@event			RequestHeaderReceived
@event			AnswerHeaderReceived
@event			BeforeAnswerHeaderSend
</HCExtension> ]]

-- >>> Settings
admin_name = 'truefriend.cz'
admin_mail = 'truefriend.cz@gmail.com'
server_name = 'HandyCache'
server_favicon = 'data:image/x-icon;base64,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'

-- >>> Define functions
local function set_var(x, y)
	_G[x] = y
end

function set_color(color, priority)
	local data = MY_EXTENSION_DATA[hc.monitor_index]

	local function rgb(r, g, b)
		return r + g*256 + b*256*256
	end

	if not data.color_priority or priority < data.color_priority then
		data.color = rgb(table.unpack(color))
		data.color_priority = priority
	end
end

-- >>> Start

function BeforeViewInMonitor()
-- >>> Get define method POST
	if hc.method == 'POST' then
		set_var('post', 'yes')
		hc.action = 'dont_update'
		do return end
	end

-- >>> Get define for Excluded by Extensions
	local type_exclude = re.find(hc.url, [[\.(htm|html|php|php3|php5|asp|aspx|txt)(\?|$)]], 1)
	if type_exclude then
		set_var('accept', 'exclude')
		set_var('type_define', 'Excluded: '..type_exclude)
		set_var('file_type_group', 'Excluded')
		set_var('file_type', type_exclude)
		do return end
	end

-- >>> Define File Types by Extensions
	file_type = {}
	local name_type = 'Image'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(jpg|jpeg|bmp|png|webp|gif|svg)$]]
	local name_type = 'Video'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(mp4|flv|mpg)$]]
	local name_type = 'Style'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(css)$]]
	local name_type = 'Javascript'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(js)$]]
	local name_type = 'Database'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(db)$]]
	local name_type = 'Icon'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(ico)$]]
	local name_type = 'Compress'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(zip|rar|7z|tar|g2z)$]]
	local name_type = 'Audio'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(mp3)$]]
	local name_type = 'Video - fragmented'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(ts)$]]
	local name_type = 'Flash'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(swf)$]]
	local name_type = 'Font'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(woff|woff2|ttf|otf)$]]
	local name_type = 'Ant. updates: Eset'
	file_type[name_type] = {}
	file_type[name_type].extension = [[\.(nup)$]]
	local name_type = 'Ant. updates: AVG'
	file_type[name_type] = {}
	file_type[name_type].extension = [[.*avg.*\.(bin)$]]

	for i, v in pairs(file_type) do
		if re.match(hc.url, v.extension) then
			local a = re.find(hc.url, v.extension, 1)
			set_var('accept', 'yes')
			set_var('type_define', i..': '..a)
			set_var('file_type_group', i)
			set_var('file_type', a)
		end
	end
end

function RequestHeaderReceived()
-- >>> Create Tables
	MY_EXTENSION_DATA = MY_EXTENSION_DATA or {}
	MY_EXTENSION_DATA[hc.monitor_index] = { monitor_string_array={} }
	local data = MY_EXTENSION_DATA[hc.monitor_index]

-- >>> Definitions for Caching
	if accept == 'yes' and accept ~= 'exclude' and hc.cache_file_name == '' then
		set_var('for_saving', 'yes')
	end
	if hc.cache_file_name ~= '' then
		set_var('good', 'yes')
		set_var('for_saving', 'no')
		hc.action = 'dont_update' --uncomment for speed access without get headers form internet
	end
end

function AnswerHeaderReceived()
	local data = MY_EXTENSION_DATA[hc.monitor_index]

-- >>> Definitions for Caching
	if re.find(hc.answer_header, [[\A\S++\s++200\s]]) then
		set_var('good', 'yes')
		if for_saving == 'yes' then
			hc.action = 'save'
		end
--	if hc.cache_file_name ~= '' then
--		hc.answer_header = re.replace(hc.answer_header, [[^Server:\s\K[^\r\n]+]], 'HandyCache')
--		hc.action = 'dont_update'
--	end
	else
		set_var('for_saving', 'no')
	end
end

function BeforeAnswerHeaderSend()
	local data = MY_EXTENSION_DATA[hc.monitor_index]

	local function monitor_show(monitor_string, monitor_color)
		hc.monitor_string = monitor_string
		if monitor_color then
			hc.monitor_text_color = monitor_color
		end
	end

	local _,_,x = string.find(hc.answer_header, 'HTTP/1%.%d +(%d+)')
	if x == nil then
		set_var('good', 'no')
		set_var('clear', 'yes')
		set_var('for_saving', 'no')
		set_var('accept', 'no')
		table.insert(data.monitor_string_array, {priority=4, text='Empty'})
		set_color({124, 124, 124}, 10)
	end

	if good == 'yes' then
		if post == 'yes' then
			table.insert(data.monitor_string_array, {priority=99, text='(Post)'})
			set_color({102, 51, 0}, 1000)
		end
		if accept == 'yes' or accept == 'exclude' then
			table.insert(data.monitor_string_array, {priority=2, text='('..type_define..')'})
			set_color({124, 124, 124}, 300)
		end
		if accept ~= 'yes' and accept ~= 'exclude' and clear ~= 'yes' then
			table.insert(data.monitor_string_array, {priority=4, text='Object do not defined for processing'})
			set_color({124, 124, 124}, 10)
		end
		if for_saving == 'yes' then
			table.insert(data.monitor_string_array, {priority=6, text='Saved to Cache'})
			set_color({51, 170, 255}, 20)
		end
	end

	if clear ~= 'yes' then
		name_header = {}
		local header_string = 'Load from Cache'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++200\s(.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 44
		name_header[header_string].color = {102, 150, 0}

		local header_string = 'Switching Protocols'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++101\s]]
		name_header[header_string].priority = 42
		name_header[header_string].color = {0, 153, 0}

		local header_string = 'Client Disconnected'
		name_header[header_string] = {}
		name_header[header_string].definition = [[^*Client Disconnection*\r\n]]
		name_header[header_string].priority = 40
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Stop Command'
		name_header[header_string] = {}
		name_header[header_string].definition = [[^HTTP/1.*Stop Command*\r\n]]
		name_header[header_string].priority = 38
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Incomplete - Ignore (from Cache)'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++206\s(.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 36
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Incomplete - Ignore'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++206\s(?!.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 34
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Redirected HC'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++302\s(.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 32
		name_header[header_string].color = {255, 128, 0}

		local header_string = 'Redirected'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++302\s(?!.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 30
		name_header[header_string].color = {255, 128, 0}

		local header_string = 'Moved permanently'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++301\s]]
		name_header[header_string].priority = 28
		name_header[header_string].color = {255, 128, 0}

		local header_string = 'Client Cache'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++304\s(.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 26
		name_header[header_string].color = {153, 153, 0}

		local header_string = 'Not modified'
		name_header[header_string] = {}
		name_header[header_string].definition = [[^HTTP/1.*Not Modified*\r\n]]
		name_header[header_string].priority = 24
		name_header[header_string].color = {124, 124, 124}

		local header_string = 'No Content'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++204\s]]
		name_header[header_string].priority = 22
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Bad Request'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++400\s]]
		name_header[header_string].priority = 20
		name_header[header_string].color = {255, 128, 0}

		local header_string = 'No authorized - 401'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++401\s]]
		name_header[header_string].priority = 18
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'No authorized - 403'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++403\s(?!.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 16
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Blocked by HC'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++403\s(.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 14
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'No exist'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++404\s]]
		name_header[header_string].priority = 12
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Proxy Authentication'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++407\s(.*?^Server:\s*+HandyCache)]]
		name_header[header_string].priority = 14
		name_header[header_string].color = {153, 0, 0}

		local header_string = 'Bad Gateway'
		name_header[header_string] = {}
		name_header[header_string].definition = [[\A\S++\s++502\s]]
		name_header[header_string].priority = 10
		name_header[header_string].color = {153, 0, 0}

		for i, v in pairs(name_header) do
			if re.match(hc.answer_header, v.definition) then
				table.insert(data.monitor_string_array, {priority=v.priority, text=i})
				set_color(v.color, v.priority)
			end
		end

		if re.find(hc.answer_header, [[^Content-Encoding:\s*+((x-)?compress|deflate|(x-)?gzip)]]) then
			table.insert(data.monitor_string_array, {priority=1000, text='('..re.substr(1)..')'})
			set_color({102, 51, 0}, 1000)
		end
	end

	table.sort(data.monitor_string_array,
		function(record1, record2)
			return record1.priority <= record2.priority
		end
	)

	local texts = {}
	for i,record in ipairs(data.monitor_string_array) do
		texts[i] = record.text
	end

	local delimiter = ' - ||| - '
	monitor_show(table.concat(texts, delimiter), data.color)
end

-- >>> End