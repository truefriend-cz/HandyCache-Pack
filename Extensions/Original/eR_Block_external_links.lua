--[[ <HCExtension>
@name            Блокировать внешние ссылки (R-ext)
@author          DenZzz
@version         3.2
@min_HC_version  1.0.0.232
@description     Блокирует загрузку внешних ссылок (объектов), если таких файлов нет в кэше
@event           Init/Init
@event           Options/Options
@event           Destroy/Destroy
@event           RequestHeaderReceived/RequestReceived
@event           BeforeAnswerHeaderSend/AnswerSend
</HCExtension> ]]


function GetReferer(s)   -- Выделяем реферер из заголовка
	s = re.find(s, [[^Referer: *(\S+)]], 1)
	if s then s = string.lower(s) end
	return s
end


function UnifyURL(s)   -- Унифицируем ссылки (удаляем WebWarper, Turbo-сервер и т.п.)
	s = re.replace(s, [[^http://\K\w*-turbo[^.]*\.opera-mini\.net:80/]], '')
	s = re.replace(s, [[^http://\Kwww\.webwarper\.net/ww/(~clientscriptgz/)?(?=[^/]+\.\w+/)]], '')
	return s
end


function GetHost(s)   -- Выделяем домены в соответствии с настроками группы: Уровень захвата доменов в ссылках
	s = re.find(s, [[^http://([^/]+\.)?([^/.]+)(\.\w+)(:\d+)?/]])
	if not s then return nil end
	if  hc_static.Options['Host_Capture_Mode'].Value=='Mode_B' then  s = re.substr(2)..re.substr(3)     -- Домены второго + первого уровня
	elseif  hc_static.Options['Host_Capture_Mode'].Value=='Mode_C' then  s = re.substr(1)..re.substr(2)..re.substr(3)     -- Полные хосты целиком
	else  s = re.substr(2)     -- Только домены второго уровня
	end
	return string.lower(s)
end


function toregexp(str)	-- Преобразовывает из простой формы в RegExp
	str = re.replace(str, [=[[.+|)(}{\][\\$^]]=], [[\\\0]], true)	-- замена спецсимволов
	str = re.replace(str, [[^\*+|\*+$]], '', true)	-- удаление первых и последних '*'
	str = re.replace(str, [[\*+]], '.*', true)
	str = re.replace(str, [[\?]], '.', true)
	return str
end

---------------------------------------------------------------------------------------------------------------------

function MakeRules()   -- Создаем правила в формате рег.выражений

	local function MakeRuleFromTable(tabl)  -- Собираем одно правило из таблицы
		local t = {}
		for ii,tt in ipairs(tabl) do
			if re.find(tt, [[\S]]) then
				local tmp = re.find(tt, [[^\+\K.*]])  -- если это упрощенный синтаксис
				table.insert(t, tmp and toregexp(tmp) or tt)
			end
		end
		if #t == 0  then  return  '<пусто>'  else  return table.concat(t, '|')  end
	end

	hc_static.Options['URL_Exceptions'].Rule  = MakeRuleFromTable(hc_static.Options['URL_Exceptions'].Value)
	--hc.put_to_log(hc_static.Options['URL_Exceptions'].Rule)

	hc_static.Options['Ref_Exceptions'].Rule  = MakeRuleFromTable(hc_static.Options['Ref_Exceptions'].Value)
	--hc.put_to_log(hc_static.Options['Ref_Exceptions'].Rule)

	local KeySetID=tonumber((re.find(hc_static.Options['HotKey'].Value, [[^<Set>(\d+)]] ,1)))
	if KeySetID and hc_static.Options['HotKey'].KeySet_Rule[KeySetID+1] then
		hc_static.Options['HotKey'].Rule = hc_static.Options['HotKey'].KeySet_Rule[KeySetID+1]
	else
		hc_static.Options['HotKey'].Rule = hc_static.Options['HotKey'].Value
	end
	--hc.put_to_log(hc_static.Options['HotKey'].Rule)
	
end  -- Конец функции  MakeRules

---------------------------------------------------------------------------------------------------------------------

function RequestReceived()   -- Обрабатываем поступивший запрос

	-- Только для GET-запросов
	if  hc.method~='GET' then return end
	-- Если нажаты горячие клавиши, то отключить расширение
	if  hc_static.Options['HotKey'].Rule~='<Нет>' and  re.find(hc.get_keyboard_state(), hc_static.Options['HotKey'].Rule)  then return end
	-- Проверяем исключения для ссылок (URL)
	if  re.find(hc.url, hc_static.Options['URL_Exceptions'].Rule)  then return end
	-- Опция: Не блокировать внешние ссылки, если файлы с таким именем уже есть в кэше
	if  hc_static.Options['Dont_Block_if_in_Cache'].Value  and  hc.cache_file_size~=-1  then return end

	local function Stop()
		-- Учитывать при блокировании активность "Черного списка" и правила "Белого списка" HC'
		if  hc_static.Options['Conditional_Stop'].Value  then  hc.action = 'stop-'
		else  hc.action = 'stop'  end
		hc.monitor_string = hc.monitor_string..'R-ext '
	end
								
	-- Забираем Referer из заголовков запроса
	local ref = UnifyURL(GetReferer(hc.request_header))
	-- Если нет реферера, то прекращаем выполнение фунуции
	if  not ref  then  return  end
	-- Проверяем исключения для рефереров
	if  re.find(ref, hc_static.Options['Ref_Exceptions'].Rule)  then  return  end
	
	-- Выделяем из ссылок домены 2-го уровня
	local ref_host = GetHost(ref)
	local url_host = GetHost(UnifyURL(hc.url))
			
	-- Если не выделены домены, то прекращаем выполнение фунуции
	if  not ref_host  or  not url_host  then  return  end

	-- Если домены в Referer и URL совпадают, то прекращаем выполнение фунуции
	if  ref_host==url_host  then  return  end
	
	-- Проверка активности опции: Ограничить время блокирования внешних ссылок ... секундами
	if  hc_static.Options['Block_on_Time'].Value  then
		local Ref_Time = hc.get_global('Block_Ext_Ref_Time')
		if Ref_Time and Ref_Time[hc.user_name..'~'..ref_host] and os.time() - Ref_Time[hc.user_name..'~'..ref_host] < hc_static.Options['Block_TimeOut'].Value then
			Stop() -- Блокируем загрузку
		elseif Ref_Time and Ref_Time[hc.user_name..'~'..ref_host] then  -- если время просрочено, то удаляем о нем инфу
			Ref_Time[hc.user_name..'~'..ref_host] = nil
			Ref_Time['<Num>'] = Ref_Time['<Num>'] - 1
			hc.set_global('Block_Ext_Ref_Time', Ref_Time)
		end
	else
			Stop() -- Блокируем загрузку
	end

end  -- Конец функции  RequestReceived

---------------------------------------------------------------------------------------------------------------------

function AnswerSend()   -- Выполняется при передаче ответа клиенту

	-- Проверка активности опции: Блокировать загрузку внешних ссылок только на время
	if  not  hc_static.Options['Block_on_Time'].Value  then return end
	-- Проверка кода ответа: если 302, 403, 404, 430, 431 c добавкой '(HC)' - то не фиксируем время загрузки, т.к. такие ответы не могут стать реферером
	if re.find(hc.answer_header, [[\AHTTP/1\.\d +(302|40[34]|43[01]) [^\r\n]*\(HC\)]]) then return end
	
	local Ref_Time = hc.get_global('Block_Ext_Ref_Time') or {}
	if Ref_Time['<Num>'] and Ref_Time['<Num>'] > 1000 then   -- Запуск процедуры очистки внутренней таблицы
		for k,v in pairs(Ref_Time) do
			if k ~= '<Num>' and  os.time() - v  >  hc_static.Options['Block_TimeOut'].Value then
				Ref_Time[k] = nil
				Ref_Time['<Num>'] = Ref_Time['<Num>'] - 1
			end
		end
		hc.set_global('Block_Ext_Ref_Time', Ref_Time)
	end

	local url_host = GetHost(UnifyURL(hc.url))
	if url_host then
		if not Ref_Time[hc.user_name..'~'..url_host] then
			Ref_Time['<Num>'] = (Ref_Time['<Num>'] or 0) + 1
		end
		Ref_Time[hc.user_name..'~'..url_host] = os.time()
		hc.set_global('Block_Ext_Ref_Time', Ref_Time)
		--hc.put_to_log('Всего записей в таблице Ref_Time: ', Ref_Time['<Num>'])
	end
	
end  -- Конец функции  AnswerSend

---------------------------------------------------------------------------------------------------------------------

function Init()   -- Инициализация расширения
	hc_static.Options = {}
	hc_static.Options['URL_Exceptions'] = {
		Rus_name = 'Исключения для ссылок (URL) в формате рег.выражений или простом формате:',
		Rus_hint = 'Указывает, какие ссылки не нужно блокировать',
		Value = { [=[\b(10pix\.ru|imageshack\.us|imagevenue\.com|immage\.de|tinypic\.com)/]=],
		          [=[\b(fastpic|imageshost|imgsmail|ipicture|photofile|radikal)\.ru/]=],
		          [=[\b(wikimedia\.org|(media-imdb|av-desk|ytimg|googlevideo)\.com)/]=],
		          [=[+http://www.youtube.com/]=] }
		}
	hc_static.Options['Ref_Exceptions'] = {
		Rus_name = 'Исключения для рефереров (сайтов) в формате рег.выражений или простом формате:',
		Rus_hint = 'Указывает, на каких сайтах (реферерах) не блокировать внешние ссылки',
		Value = { [=[^http://[^/]*\b(yandex|google)\.\w+[/:]]=] }
		}
	hc_static.Options['HotKey'] = {
		Rus_name = 'Горячая клавиша для временного отключения расширения:',
		Rus_hint = 'При удержании этой кнопки расширение не будет блокировать внешние ссылки',
		KeySet = { '<Нет>','Ctrl','Shift','Alt','Shift+Ctrl','Shift+Alt','Shift+Win','Ctrl+Win','Alt+Win' },
		KeySet_Rule = { '<Нет>','VK_CONTROL','VK_SHIFT','VK_MENU','VK_SHIFT.+VK_CONTROL','VK_SHIFT.+VK_MENU','VK_SHIFT.+VK_[LR]WIN','VK_CONTROL.+VK_[LR]WIN','VK_MENU.+VK_[LR]WIN' },
		Value = '<Set>1'
		}
	hc_static.Options['Dont_Block_if_in_Cache'] = {
		Rus_name = 'Не блокировать внешние ссылки, если файлы с таким именем уже есть в кэше',
		Rus_hint = 'Загрузка внешних ссылок не будет блокироваться, если такие файлы ранее уже были сохранены в кэш',
		Value = true
		}
	hc_static.Options['Conditional_Stop'] = {
		Rus_name = 'Учитывать при блокировании активность "Черного списка" и правила "Белого списка" HC',
		Rus_hint = 'Блокировка внешних ссылок сработает только если "Черный список" не отключен галкой "Разрешить", горячей клавишей или правилами "Белого списка"',
		Value = true
		}
	hc_static.Options['Block_on_Time'] = {
		Rus_name = 'Ограничить время блокирования внешних ссылок',
		Rus_hint = 'Загрузка внешних ссылок будет заблокирована на указанное время',
		Value = true
		}
	hc_static.Options['Block_TimeOut'] = {
		Rus_name = 'Число секунд, на которое будет заблокирована загрузка внешних ссылок',
		Rus_hint = 'Число секунд, на которое будет заблокирована загрузка внешних ссылок.\r\nДля быстрых каналов обычно достаточно 15-20 секунд.\r\nДля медленных каналов поставьте 30-60 секунд или больше.',
		Value = 15
		}
	hc_static.Options['Host_Capture_Mode'] = {
		Rus_name = 'Уровень захвата доменов в ссылках:',
		Rus_hint = 'Эта группа определяет, какие домены будет захватывать и сравнивать расширение',
		Value = 'Mode_A'
		}

	local fn= re.replace(hc.script_name, [[(.*\.).*]], [[\1ini]])
	local f = io.open(fn, 'r')
	if f then
		local t = {}
		while true do
			local s = f:read("*line")
			if s then table.insert(t, s) else break end
		end
		f:close()
		for i=1, #t do
			local option = re.find(t[i], [[^(\w+?)_?(\d*)\s*=\s*(.+?)\s*$]], 1)
			local option_num = re.substr(2)
			local value = re.substr(3)
			--hc.put_to_log(option,'   ', option_num,'   ',value)
			if option and hc_static.Options[option] and value then
				local ValueType = type(hc_static.Options[option].Value)
				if not option_num or option_num == '' then  -- Однострочная опция
					if  ValueType=='boolean'  then  value = value~='false'     -- если 'false', то false, иначе true
					elseif  ValueType=='number'  then  value = tonumber(value)
					end
					if value~=nil then hc_static.Options[option].Value = value end
				else  -- Многострочная опция
					if not hc_static.Options[option].User_Table then
						hc_static.Options[option].Value = {}            -- очистка таблицы от дефолтных значений
						hc_static.Options[option].User_Table = true
					end
					table.insert(hc_static.Options[option].Value, value)
				end
			end
		end
	end
	
	MakeRules()
end

---------------------------------------------------------------------------------------------------------------------

function Options()   -- Окно настроек
	require "vcl"
	if Form then
		Form:Free()
		Form=nil
	end

	local hei = 400 -- высота окна настроек
	local wid = 650 -- ширина окна настроек
	
	Form = VCL.Form('Form')
	OkButton = VCL.Button(Form, "OkButton")
	CancelButton = VCL.Button(Form, "CancelButton")
	Form._ = {Caption='Настройки расширения "Блокировать внешние ссылки (R-ext)"', Width=wid, ClientHeight=hei+OkButton.Height+10, Position='poOwnerFormCenter', BorderIcons='biSystemMenu', BorderStyle='Fixed3D'}
	OkButton._ = {Caption = "Сохранить", Width=100, Left=100, Top=Form.ClientHeight-OkButton.Height-10, OnClick = "onOkButtonClick"}
	CancelButton._ = {Caption = "Отменить", Width=100, Left=wid-200, Top=OkButton.Top, OnClick = "onCancelButtonClick"}

	PC = VCL.PageControl(Form, "PC")
	PC._= { Width=Form.ClientWidth, Height=Form.ClientHeight-OkButton.Height-20, Left=1 }
	Tab1 = VCL.TabSheet(PC,"Tab1")
	Tab1._= { Caption='Исключения' }
	Tab2 = VCL.TabSheet(PC,"Tab2")
	Tab2._= { Caption='Другие настройки' }
	
	local FontFactor   -- поправочный коэффициент на размер шрифта
	if Form.PixelsPerInch == 96 then FontFactor = 1
	else FontFactor = 1.15 end   -- крупный шрифт

	Label_11 = VCL.Label(Tab1,"Label_11")
	Label_11._ = { Caption=hc_static.Options['URL_Exceptions'].Rus_name, Left=15, Top=10, Height=20 }
	Memo_11 = VCL.Memo(Tab1,"Memo_11")
	Memo_11._ = { Top=Label_11.Top+Label_11.Height, Left=Label_11.Left, Width=Tab1.Width-2*Label_11.Left, Height=(PC.Height-Label_11.Height*2-60)/2, Scrollbars='ssBoth', WordWrap=false, Hint=hc_static.Options['URL_Exceptions'].Rus_hint, ShowHint=true }
	Memo_11.Font._ = { Height = 16, Name = 'Courier New' }
	if hc_static.Options['URL_Exceptions'].Value[1] ~= '<пусто>' then
		Memo_11:SetText(hc_static.Options['URL_Exceptions'].Value)
	else
		Memo_11:SetText({})
	end

	Label_12 = VCL.Label(Tab1,"Label_12")
	Label_12._ = { Caption=hc_static.Options['Ref_Exceptions'].Rus_name, Left=15, Top=Memo_11.Top+Memo_11.Height+15, Height=20 }
	Memo_12 = VCL.Memo(Tab1,"Memo_12")
	Memo_12._ = { Top=Label_12.Top+Label_12.Height, Left=Label_12.Left, Width=Tab1.Width-2*Label_12.Left, Height=(PC.Height-Label_12.Height*2-60)/2, Scrollbars='ssBoth', WordWrap=false, Hint=hc_static.Options['Ref_Exceptions'].Rus_hint, ShowHint=true }
	Memo_12.Font._ = { Height = 16, Name = 'Courier New' }
	if hc_static.Options['Ref_Exceptions'].Value[1] ~= '<пусто>' then
		Memo_12:SetText(hc_static.Options['Ref_Exceptions'].Value)
	else
		Memo_12:SetText({})
	end

	Label_21 = VCL.Label(Tab2, 'Label_21')
	Label_21._ = { Caption=hc_static.Options['HotKey'].Rus_name, Left=30, Top=30, Height=35, Hint=hc_static.Options['HotKey'].Rus_hint, ShowHint=true }
	ComboBox_21 = VCL.ComboBox(Tab2, "ComboBox_21" )
	ComboBox_21:SetText(hc_static.Options['HotKey'].KeySet)
	local KeySetID=tonumber((re.find(hc_static.Options['HotKey'].Value,[[<Set>(\d+)]],1)))
	ComboBox_21._= { ItemIndex=KeySetID, Left=Label_21.Left+Label_21.Width+10, Top=Label_21.Top-3, Height=35, Width=150, Hint='Выберите набор из списка или впишите свой RegExp-шаблон', ShowHint=true }

	CheckBox_22 = VCL.CheckBox(Tab2, "CheckBox_22")
	CheckBox_22._= { Caption=hc_static.Options['Dont_Block_if_in_Cache'].Rus_name, Left=30, Top=Label_21.Top+Label_21.Height, Height=35, Width=wid-70, Hint=hc_static.Options['Dont_Block_if_in_Cache'].Rus_hint, ShowHint=true, WordWrap=true, Checked=hc_static.Options['Dont_Block_if_in_Cache'].Value }

	CheckBox_23 = VCL.CheckBox(Tab2, "CheckBox_23")
	CheckBox_23._= { Caption=hc_static.Options['Conditional_Stop'].Rus_name, Left=30, Top=CheckBox_22.Top+CheckBox_22.Height, Height=35, Width=wid-70, Hint=hc_static.Options['Conditional_Stop'].Rus_hint, ShowHint=true, WordWrap=true, Checked=hc_static.Options['Conditional_Stop'].Value }

	function onCheckBox_24_Click(Sender)
		Edit_24.Enabled = CheckBox_24.Checked
		Label_24a.Enabled = Edit_24.Enabled
	end

	CheckBox_24 = VCL.CheckBox(Tab2, "CheckBox_24")
	Edit_24 = VCL.Edit(Tab2,"Edit22")
	Edit_24._ = { Text=hc_static.Options['Block_TimeOut'].Value, Width=30, MaxLength=3, Hint=hc_static.Options['Block_TimeOut'].Rus_hint, ShowHint=true, Enabled=CheckBox_24.Checked }
	Label_24a = VCL.Label(Tab2,"Label_24a")
	Label_24a._ = { Caption='секундами', Enabled=Edit_24.Enabled }
	CheckBox_24._= { Caption=hc_static.Options['Block_on_Time'].Rus_name, Left=30, Top=CheckBox_23.Top+CheckBox_23.Height, Height=35, Width=#hc_static.Options['Block_on_Time'].Rus_name*6.32*FontFactor, Hint=hc_static.Options['Block_on_Time'].Rus_hint, ShowHint=true, Checked=hc_static.Options['Block_on_Time'].Value, OnClick = "onCheckBox_24_Click" }
	Edit_24._ = { Top=CheckBox_24.Top+8/FontFactor, Left=CheckBox_24.Left+CheckBox_24.Width+2}
	Label_24a._ = { Left=Edit_24.Left+Edit_24.Width+8, Top=Edit_24.Top+3/FontFactor^3 }

	RG_25 = VCL.RadioGroup(Tab2, 'RG_25')
	RG_25._ = { Caption=hc_static.Options['Host_Capture_Mode'].Rus_name, Top=CheckBox_24.Top+CheckBox_24.Height+10, Left=30, Height=110, Width=320, Hint=hc_static.Options['Host_Capture_Mode'].Rus_hint, ShowHint=true }
	rb_25a = VCL.RadioButton(RG_25, 'rb_25a')
	rb_25a._ = { Caption='Домены второго уровня  (рекомендуется)', Top=25, Left=15, Width=RG_25.Width-30, Hint='Будут сравниваться только домены второго уровня', ShowHint=true, Checked=true }
	rb_25b = VCL.RadioButton(RG_25, 'rb_25b')
	rb_25b._ = { Caption='Домены второго + первого уровня', Top=rb_25a.Top+25, Left=rb_25a.Left, Width=rb_25a.Width, Hint='Будут сравниваться домены второго + первого уровня', ShowHint=true, Checked=hc_static.Options['Host_Capture_Mode'].Value=='Mode_B' }
	rb_25c = VCL.RadioButton(RG_25, 'rb_25c')
	rb_25c._ = { Caption='Полные хосты', Top=rb_25b.Top+25, Left=rb_25a.Left, Width=rb_25a.Width, Hint='Будут сравниваться полные хосты целиком', ShowHint=true, Checked=hc_static.Options['Host_Capture_Mode'].Value=='Mode_C' }

	Form:ShowModal()
end

---------------------------------------------------------------------------------------------------------------------

function onOkButtonClick(Sender)

	function TakeMemo(memo)  -- Очищаем многострочное поле ввода от пустот
		local t = {}
		for ii,tt in ipairs(memo) do
			if re.find(tt, [[\S]]) and not re.find(tt, '<пусто>') then  -- убираем пустые строки
				tt = re.replace(tt, [[\s+]], '', true)  -- убираем лишние пробелы из правил
				table.insert(t, tt)
			end
		end
		if #t == 0  then  return {'<пусто>'}  else  return t  end
	end

	hc_static.Options['URL_Exceptions'].Value = TakeMemo(Memo_11:GetText())

	hc_static.Options['Ref_Exceptions'].Value = TakeMemo(Memo_12:GetText())

	if ComboBox_21.ItemIndex >= 0 then 	hc_static.Options['HotKey'].Value = '<Set>'.. tostring(ComboBox_21.ItemIndex)
	elseif ComboBox_21.Text == '' then  hc_static.Options['HotKey'].Value = '<Set>0'
	else hc_static.Options['HotKey'].Value = ComboBox_21.Text
	end

	hc_static.Options['Dont_Block_if_in_Cache'].Value = CheckBox_22.Checked
	
	hc_static.Options['Conditional_Stop'].Value = CheckBox_23.Checked
	
	hc_static.Options['Block_on_Time'].Value = CheckBox_24.Checked

	if tonumber(Edit_24.Text) then
		hc_static.Options['Block_TimeOut'].Value = tonumber(Edit_24.Text)
	end

	if  rb_25a.Checked  then  hc_static.Options['Host_Capture_Mode'].Value = 'Mode_A'
	elseif  rb_25b.Checked  then  hc_static.Options['Host_Capture_Mode'].Value = 'Mode_B'
	elseif  rb_25c.Checked  then  hc_static.Options['Host_Capture_Mode'].Value = 'Mode_C'
	end


	Form:Close()
	MakeRules()
	SaveOptions()
end

---------------------------------------------------------------------------------------------------------------------

function onCancelButtonClick(Sender)
	Form:Close()
end

---------------------------------------------------------------------------------------------------------------------

function SaveOptions()   -- Сохраняет настроки
	local f = assert(io.open(re.replace(hc.script_name, [[(.*\.).*]], [[\1ini]]), 'w'))
	if not f then return end
	for k,v in pairs(hc_static.Options) do
		if type(v.Value) ~= 'table' then   -- если параметр не таблица
			f:write(k .. '=' .. tostring(v.Value) .. '\n')
		else
			for i=1, #v.Value do
				f:write(k .. '_' .. tostring(i) .. '=' .. v.Value[i] .. '\n')
			end
		end
	end
	f:close()
end

---------------------------------------------------------------------------------------------------------------------

function Destroy()
	hc.set_global('Block_Ext_Ref_Time')	-- очищаем память
end
