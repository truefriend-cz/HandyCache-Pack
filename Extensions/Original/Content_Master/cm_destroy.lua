
local old_path = package.path
package.path = _CM_DIR .. '?.lua'
require('cm_common')
package.path = old_path

hc.put_to_log('Content Master destroy started...')

local users = loadstring(hc.get_global('CM_USERS'))()

users.ALL.AutoUpdate = hc.get_global('CM_AUTO_UPDATE')
users.ALL.StatUpdatePeriod = hc.get_global('CM_AUTO_STAT')

_CM_WRITE_FILE(hc.script_name:match('.*%.') .. 'ini', 'wb', _CM_SAVE_TABLE(users))

-- освобождаем память глобальных переменных
hc.remove_global('CM_WORKERS')	-- обработчики контента различного типа (html, js, css, raw, url)

local js_parsers = hc.get_global_table_item('CM_PARSERS', 'JS')
if js_parsers then
	for _,v in pairs(js_parsers) do	-- удалем зарегистрированные в кэше JS-регэкспы
		if v:sub(1, 1)=='*' then re.unregister_regex(v) end
	end
end
hc.remove_global('CM_PARSERS')	-- парсер контента (html, js)

local function unregister_rules(rules)
	if type(rules)=='table' then
		for _,v in pairs(rules) do unregister_rules(v) end
	elseif type(rules)=='string' and rules:sub(1, 1)=='*' then
		re.unregister_regex(rules)
	end
end
unregister_rules(hc.get_global('CM_RULES'))	-- удаляем зарегистрированные в кэше НС регэкспы
hc.remove_global('CM_RULES')	-- правила, индексированные по имени пользователя и типу контента

hc.remove_global('CM_RULES_SOURCE')	-- данные о фильтре, номере файла и номере строки в этом файле для каждого правила
hc.remove_global('CM_RULES_ADDITIONS')	-- дополнительные данные (домен, строка замены и т.п.) для некоторых правил

hc.remove_global('CM_OPTIONS')	-- некоторые настройки ‘Њ:
--	SystemCoding				: число		- локаль системы, на которой запущен ‘Њ. ‡начениЯ: https://msdn.microsoft.com/en-us/library/windows/desktop/dd317756(v=vs.85).aspx
--	LanguageID					: число		- Язык ‘Њ. Џпо умолчанию беретсЯ Язык Ќ‘ из hc.language_id. ‡начениЯ: https://support.microsoft.com/en-us/kb/221435
--	LAST_OPTIONS_CHANGE_TIME	: число		- времЯ последнего изменениЯ настроек ‘Њ
--	ExtensionName				: строка	- наименование расширениЯ (используетсЯ при автоматическом перезапуске ‘Њ)
--	Version						: строка	- номер версии ‘Њ
--	ctypes						: таблица	- задает соответствие конкретных типов контента обобщенным типам (html, js)
--	HaveDifferentUsers			: boolean	- флаг, показывающий наличие пользователей с разными настройками

hc.remove_global('CM_USERS')	-- список пользователей с привязкой к каждому включенных для него групп фильтров, фильтров, файлов подписок
hc.remove_global('CM_URL_CACHE')	-- кэш срабатывания фильтров по URL
hc.remove_global('CM_AUTO_UPDATE')
hc.remove_global('CM_AUTO_STAT')
hc.remove_global('CM_DOMS')	-- DOM страниц, загруженных при включенном интерактивном режиме (НАДО БЫ ЭФФЕКТИВНО ОЧИЩАТЬ!!!)
hc.remove_global('CM_COMMON')	-- библиотека общих функций
hc.remove_global('CM_LANGUAGES')
hc.remove_global('CM_ADMUNCHER_FILES')
hc.remove_global('CM_SITE_SPECIFIC_CSS')
hc.remove_global('CM_SITE_SPECIFIC_JS')
hc.remove_global('CM_ABP_SITE_SPECIFIC_CSS')

local rtmp = hc.get_global('CM_ABP_GENERIC_BLOCK_REGEX') or {}
for k,v in pairs(rtmp) do
	re.unregister_regex(v)
end
hc.remove_global('CM_ABP_GENERIC_BLOCK_REGEX')
local rtmp = hc.get_global('CM_ABP_GENERIC_HIDE_REGEX') or {}
for k,v in pairs(rtmp) do
	re.unregister_regex(v)
end
hc.remove_global('CM_ABP_GENERIC_HIDE_REGEX')


_CM_SAVE_HITS()	-- база данных срабатываний правил фильтров
hc.remove_global('CM_HITS')
hc.remove_global('CM_LAST_HITS_SAVE_TIME')	-- время последнего автосохранениЯ числа срабатываний правил

hc.remove_global('CM_REMOVE_INTERACTIVE_MODE_BY_USERS')
hc.remove_global('CM_ORIGINAL_RULES')	-- все файлы правил, разбитые по строкам (для вывода в лог сработавшего правила)
hc.remove_global('CM_UPDATE_COUNTER')	-- счетчик текущего обновлениЯ

hc.remove_global('CM_HTML_ENGINE_INITIALIZED')	-- флаг устанавливается после инициализации HTML-движка для каждого пользователя. Специфичные правила JS формируются при обработке первого HTML. Однако уже до этого браузер может запросить helper_ss.js. В этом случае держим паузу



hc.put_to_log('Content Master destroyed')
