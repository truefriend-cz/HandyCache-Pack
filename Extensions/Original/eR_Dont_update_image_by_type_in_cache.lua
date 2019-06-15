--[[ <HCExtension>
@name          Не обновлять картинки по типу в кэше (RS-img)
@author        DenZzz
@version       1.2 для HC v1.00 RC2 (1.0.0.185) и возможно выше
@description   Не обновляет картинки по сигнатуре файла в кэше без запроса на сервер
@event         BeforeRequestHeaderSend/Request
</HCExtension> ]]



function Request()

 -- Только для GET-запросов
  if hc.method == 'GET' then

   -- Выясняем, является ли файл в кэше картинкой
    img = string.find(hc.cache_file_content_type,'image',1,true) 

      if img~=nil then
       -- если файл в кэше - картинка, то берем ее из кэша
        hc.action = 'dont_update-'
        hc.monitor_string = hc.monitor_string..'RS-img '
      end  

  end  -- Конец блока 'Только для GET-запросов'

end  -- Конец функции Request
