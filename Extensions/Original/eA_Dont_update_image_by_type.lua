--[[ <HCExtension>
@name          Не обновлять картинки по типу с сервера (A-img)
@author        DenZzz
@version       1.2 для HC v1.00 RC2 (1.0.0.175) и возможно выше
@description   Не обновлять картинки по типу файла в заголовке ответа сервера
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


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

 -- Только для GET-запросов
  if hc.method == 'GET' then

   -- забираем тип файла из заголовка 'Content-Type'
    local Type = GetContentType(hc.answer_header)
   -- есть ли в поле заголовка 'Content-Type' слово 'image'
    if Type~=nil then img = string.find(Type,'image',1,true)
    else img = nil  end
   -- забираем размер файла из заголовка 'Content-Length' 
    local Len = GetContentLength(hc.answer_header)

      if img~=nil then
         -- если картинка есть в кэше и ее размер на сервере не известен или больше 1000 байт (не влезет в 1 пакет)
          if hc.cache_file_size>=0 and (Len == -1 or Len > 1000) then
           -- то не обновлять картинку
            hc.action = 'dont_update-'
            hc.monitor_string = hc.monitor_string..'A-img '
          end  
      end
  end

end  -- Конец функции Answer
