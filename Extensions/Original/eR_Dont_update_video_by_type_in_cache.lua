--[[ <HCExtension>
@name          Не обновлять видео по типу в кэше (RS-vid)
@author        DenZzz
@version       1.2 для HC v1.00 RC2 (1.0.0.185) и возможно выше
@description   Не обновляет видео по сигнатуре файла в кэше без запроса на сервер
@event         BeforeRequestHeaderSend/Request
</HCExtension> ]]



function Request()

 -- Только для GET-запросов
  if hc.method == 'GET' then

   -- Выясняем, является ли файл в кэше видео-файлом
    vid = string.find(hc.cache_file_content_type,'video',1,true) 

      if vid~=nil then
       -- если файл в кэше - видео, то берем его из кэша
        hc.action = 'dont_update-'
        hc.monitor_string = hc.monitor_string..'RS-vid '
      end  

  end  -- Конец блока 'Только для GET-запросов'

end  -- Конец функции Request
