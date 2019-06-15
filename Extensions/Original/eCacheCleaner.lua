--[[ <HCExtension>
@name          Cache cleaner
@author        mai62
@version       0.61
@description   Планировщик очистки кэша
@event         Init/init
@event         Timer1m/timer
@event         Options/options
</HCExtension> ]]

function ini_file_name()
  local fn= hc.script_name
  if not fn or (fn=='') then return [[c:\eCacheCleaner.ini]] end
  return re.replace(fn, [[(.*\.).*]], [[\1ini]])
end

function SaveParams()  
  local f = assert(io.open(ini_file_name(), 'w'))
  if not f then return end
  f:write('Period='..hc_static['Period']..'\n')
  f:write('LastStart='..hc_static['LastStart']..'\n')
  f:write('NextStart='..hc_static['NextStart']..'\n')
  f:close()
end  

function timer()
  t= os.time()
  if hc_static['NextStart'] < t then
    hc_static['LastStart']= t
    hc_static['NextStart']= t+hc_static['Period']*3600
    SaveParams()
    hc.execute_cmd('ClearCache')
    hc.put_msg('Очистка кэша запущена')
  end
end

function init()
  hc.put_to_log('function init is called')
  local f = io.open(ini_file_name(), 'r')
  if f then 
    local s
    local t= {}
    while true do
      s = f:read("*line")
      if s then table.insert(t, s) else break end
    end
    f:close()
    local i
    for i=1, #t do
      s= re.find(t[i],'Period=(.*)',1)
      if s then
        hc_static['Period']= tonumber(s)
      else
        s= re.find(t[i],'LastStart=(.*)',1)
        if s then
          hc_static['LastStart']= tonumber(s)
        else
          s= re.find(t[i],'NextStart=(.*)',1)
          if s then
            hc_static['NextStart']= tonumber(s)
          end  
        end
      end
    end
  end
  if not hc_static['Period'] then hc_static['Period']= 72 end
  if not hc_static['LastStart'] then hc_static['LastStart']= 0 end
  if not hc_static['NextStart'] then hc_static['NextStart']= os.time()+hc_static['Period']*3600 end
  if hc_static['LastStart'] == 0 then SaveParams() end
end

function options()
  require "vcl"
  if Form then
    Form:Free()
    Form=nil
  end
  Form = VCL.Form('Form')
  x,y,w,h= hc.window_pos()
  Form._ = { Caption='Настройки Cache cleaner', width=380, height=160, BorderStyle='Fixed3D' }
  Form._ = { left=x+(w-Form.width)/2, top=y+(h-Form.height)/2 }
  Label1 = VCL.Label(Form,"Label1")
  Label1._ = { caption='Запускать очистку кэша каждые ', top=20, left=30, width=200}
  Edit1 = VCL.Edit(Form,"Edit1")
  Edit1._ = { text=hc_static['Period'], parentfont=true, top=17, left=230, width=50, onchange=nil}
  Label2 = VCL.Label(Form,"Label2")
  Label2._ = { caption='часов', top=20, left=290, width=70}
  Label3 = VCL.Label(Form,"Label3")
  Label3._ = { caption='Следующий запуск: '..hc.systime_to_str(hc_static['NextStart'],false), top=50, left=30, width=300}
  OkButton = VCL.Button(Form, "OkButton")
  OkButton._ = {onclick = "onOkButtonClick", width=100, left=30, caption = "OK", top= Form.clientheight-OkButton.height-10}
  CancelButton = VCL.Button(Form, "CancelButton")
  CancelButton._ = {onclick = "onCancelButtonClick", width=100, left=140, top=OkButton.top, caption = "Cancel"}
  Form:ShowModal()
  Form:Free()
  Form=nil
end

function onOkButtonClick(Sender)
  hc_static['Period']= Edit1.text
  Form:Close()
  hc.put_to_log(hc_static['Period'])
  if hc_static['LastStart'] == 0 then hc_static['LastStart']= os.time() end
  hc_static['NextStart']= hc_static['LastStart'] + hc_static['Period']*3600
  SaveParams()
end

function onCancelButtonClick(Sender)
  Form:Close()
end

