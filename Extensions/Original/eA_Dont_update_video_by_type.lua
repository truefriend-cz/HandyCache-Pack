--[[ <HCExtension>
@name          Не обновлять видео по типу с сервера (A-vid)
@author        DenZzz
@version       1.2 для HC v1.00 RC2 (1.0.0.175) и возможно выше
@description   Не обновлять видео по типу файла в заголовке ответа сервера
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetContentType(s)
  _,_,x = string.find(s, '[cC]ontent%-[tT]ype: *([^;\r\n]+)')
  if x~=nil then x = string.lower(x) end
  return x
end



function Answer()

 -- Только для GET-запросов
  if hc.method == 'GET' then

   -- забираем тип файла из заголовка 'Content-Type'
    local Type = GetContentType(hc.answer_header)
   -- есть ли в поле заголовка 'Content-Type' слово 'video'
    if Type~=nil then vid = string.find(Type,'video',1,true)
    else vid = nil  end

      if vid~=nil then
         -- если видео есть в кэше
          if hc.cache_file_size>=0 then 
           -- то не обновлять видео
            hc.action = 'dont_update-'
            hc.monitor_string = hc.monitor_string..'A-vid '
          end  
      end
  end

end  -- Конец функции Answer
