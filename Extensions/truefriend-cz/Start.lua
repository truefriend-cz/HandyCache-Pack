--[[ <HCExtension>
@name			Start
@author			truefriend-cz
@version		1.3
@description	Script for Init
@license		CC BY-NC-SA (Attribution-NonCommercial-ShareAlike - https://creativecommons.org/licenses/by-nc-sa/)
@event    		Init
</HCExtension> ]]

function Init()
-- >>> Start
	hc.sleep(1000)
	hc.put_to_log('HandyCache: truefriend-cz pack started')
	hc.play_sound(hc.exe_path..[[Sounds\Startup.wav]])
	hc.put_msg(3, 'HandyCache: truefriend-cz pack started')
	hc.execute_cmd('SSLhandling off')

-- >>> Path validator
	local temp_path = hc.exe_path
	if not temp_path:find('^[%-%.%w_.%s]+$') then
		hc.shell_execute('cmd', '/C robocopy '..[["]]..hc.exe_path..[[Support\Certificate\Install"]]..[[ ]]..[["]]..os.getenv('TEMP')..[[\HandyCache\Support\Certificate\Install]]..[[" /E]], nil, SW_HIDE, true)
		hc.shell_execute('cmd', '/C robocopy '..[["]]..hc.exe_path..[[Support\Visual C++ Redistributable Package"]]..[[ ]]..[["]]..os.getenv('TEMP')..[[\HandyCache\Support\Visual C++ Redistributable Package]]..[[" /E]], nil, SW_HIDE, true)
		temp_path = os.getenv('TEMP')..[[\HandyCache\]]
	end

	hc.shell_execute('cmd', '/C '..[["]]..temp_path..[[Support\Certificate\Install\Install.cmd"]], nil, SW_HIDE, true)
	hc.shell_execute('cmd', '/C '..[["]]..temp_path..[[Support\Visual C++ Redistributable Package\Install.cmd"]], nil, SW_HIDE, true)

-- >>> End


-- >>> Others (planned in future)

--	hc.put_to_log(hc.cache_path)
--	hc.shell_execute('cmd.exe',[[ /k ]]..[[""]]..hc.ini_path..[[Cache\MountVHD.cmd]]..[["]]..[[ ]]..[["]]..hc.ini_path..[[Cache\File.vhd]]..[["]]..[[ ]]..[["]]..[[M]]..[[""]], nil, SW_HIDE, false)
--ok	hc.shell_execute([["]]..hc.ini_path..[[Cache\MountVHD.cmd"]], [["]]..hc.ini_path..[[Cache\File.vhd]]..[["]]..[[ ]]..[["]]..[[M]]..[["]], nil, 'SW_HIDE', false)
--	hc.monitor_string = 'Timer'
end