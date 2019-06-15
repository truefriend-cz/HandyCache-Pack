--[[ <HCExtension>
@name          Блокировать загрузку больших файлов (A-long)
@author        DenZzz
@version       1.2 для HC v1.00 RC2 (1.0.0.175) и возможно выше
@description   Блокирует загрузку файлов, которые больше заданного предельного размера
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]



function GetContentLength(s)
  _,_,x = string.find(s, '[cC]ontent%-[lL]ength: *(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end



function Answer()

 -- забираем размер файла из заголовка 'Content-Length' 
  local Len = GetContentLength(hc.answer_header)

   -- если размер файла есть в заголовке и он больше 1000000 байт
    if Len > 1000000 then
     -- и действие HC еще не присвоено или присвоено 'Сохранять', то блокировать загрузку
      if hc.action=='' or hc.action==nil or hc.action=='save' or hc.action=='save-' then
        hc.action = 'stop-'
        hc.monitor_string = hc.monitor_string..'A-long '
      end
    end

end  -- Конец функции Answer
