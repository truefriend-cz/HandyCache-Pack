--[[ <HCExtension>
@name          Сохранять или блокировать ответы 403 и 404 (A-40X)
@author        DenZzz
@version       1.2 для HC v1.00 RC2 (1.0.0.175) и возможно выше
@description   Сохраняет или блокирует ответы 403 и 404
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetAnswerCode(s)
  _,_,x = string.find(s, 'HTTP/1%.%d +(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end

function GetContentType(s)
  _,_,x = string.find(s, '[cC]ontent%-[tT]ype: *([^;\r\n]+)')
  if x~=nil then x = string.lower(x) end
  return x
end

function GetContentLength(s)
  _,_,x = string.find(s, '[cC]ontent%-[lL]ength: *(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end



function Answer()

 -- выясняем код ответа из заголовка
  local answ_code = GetAnswerCode(hc.answer_header)
 -- забираем тип файла из заголовка 'Content-Type'
  local Type = GetContentType(hc.answer_header)
 -- есть ли в поле заголовка 'Content-Type' слово 'image'
  if Type~=nil then img = string.find(Type,'image',1,true)
  else img = nil  end
 -- забираем размер файла из заголовка 'Content-Length' 
  local Len = GetContentLength(hc.answer_header)

 -- если код ответа 403 или 404
  if answ_code==403 or answ_code==404 then

   -- и если тип 'картинка', то сохранить ее в кэше
    if img~=nil then
       hc.action = 'save-'
       hc.monitor_string = hc.monitor_string..'A-40Xs '
   -- если тип не 'картинка'
    else    
     -- и если в заголовке нет размера файла или он больше 1000 байт (не влезет в 1 пакет), то блокировать загрузку
      if Len == -1 or Len > 1000 then
       hc.action = 'stop-'
       hc.monitor_string = hc.monitor_string..'A-40X '
      end
    end

  end

end  -- Конец функции Answer

