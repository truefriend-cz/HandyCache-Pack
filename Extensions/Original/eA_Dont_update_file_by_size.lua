--[[ <HCExtension>
@name          Не обновлять файлы по размеру (A-size)
@author        DenZzz
@version       1.3 для HC v1.00 RC2 (1.0.0.175) и возможно выше
@description   Не обновляет файл, если его размер не изменился
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetContentLength(s)
  _,_,x = string.find(s, '[cC]ontent%-[lL]ength: *(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end

function GetContentType(s)
  _,_,x = string.find(s, '[cC]ontent%-[tT]ype: *(.-) *\r?\n')
  if x~=nil then x = string.lower(x) end
  return x
end

function GetContentEncoding(s)
  _,_,x = string.find(s, '[cC]ontent%-[eE]ncoding: *(.-) *\r?\n')
  if x~=nil then x = string.lower(x) end
  return x
end



function Answer()

 -- Только для GET-запросов
 if hc.method == 'GET' then

  -- Забираем размер файла из заголовка 'Content-Length' 
  local Len = GetContentLength(hc.answer_header)

  -- Если в заголовке есть размер файла и он больше 1000 байт
  if Len > 1000 then

   -- и если размеры файла в кэше и на сервере равны        
   if hc.cache_file_size == Len then
    -- то прервать загрузку с сервера и загрузить файл из кэша
    hc.action = 'dont_update-'
    hc.monitor_string = hc.monitor_string..'A-size '

   -- Если размеры не равны:
   else    
    -- Забираем содержимое заголовка 'Content-Encoding' 
    local Enc = GetContentEncoding(hc.answer_header)
    -- Забираем тип файла из заголовка 'Content-Type'
    local Type = GetContentType(hc.answer_header)
    local Len2 = nil

    -- Проверяем отсутствие заголовка 'Content-Encoding' и наличие 'Content-Type'
    if Enc == nil and Type ~= nil then
      -- и если тип HTML или XML
      if string.find(Type,'text/html',1,true) ~= nil or string.find(Type,'/xml',1,true) ~= nil then
       -- Вычисляем длину файла в кэше с учетом дописанного HC тэга
       Len2 = Len + 5 + string.len(Type) + 21 + 4
      end
    end

    -- Если длина увеличенного тела совпадает с размером файла в кэше
    if Len2 ~= nil and hc.cache_file_size == Len2 then
     -- то прервать загрузку с сервера и загрузить файл из кэша
     hc.action = 'dont_update-'
     hc.monitor_string = hc.monitor_string..'A-size2 '
    end

   end  -- Конец блока сравнения размеров и принятия решения
  end  -- Конец блока 'Размер больше 1000 байт'
 end  -- Конец блока 'Только для GET-запросов'

end  -- Конец функции Answer
