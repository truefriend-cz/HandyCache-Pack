--[[ <HCExtension>
@name			Exit
@author			truefriend-cz
@version		1.1
@description	Script for Destroy
@license		CC BY-NC-SA (Attribution-NonCommercial-ShareAlike - https://creativecommons.org/licenses/by-nc-sa/)
@event    		Destroy
</HCExtension> ]]

function Destroy()
	function isFileOrDir(name)
		if type(name)~="string" then return false end
		return os.rename(name, name) and true or false
	end
-- >>> Start
	hc.execute_cmd('SSLhandling off')
	hc.play_sound(hc.exe_path..[[Sounds\Exit.wav]])

	if isFileOrDir(os.getenv('TEMP')..[[\HandyCache]]) then
		hc.shell_execute('cmd', '/C rmdir '..[["]]..os.getenv('TEMP')..[[\HandyCache]]..[[" /s /q]], nil, SW_HIDE, true)
		hc.put_msg(3, 'HandyCache: EXOI')
	end

	hc.sleep(1000)

-- >>> End


-- >>> Others (planned in future)

--	hc.shell_execute('cmd.exe',[[ /k ]]..[[""]]..hc.ini_path..[[Cache\UnMountVHD.cmd]]..[["]]..[[ ]]..[["]]..hc.ini_path..[[Cache\File.vhd]]..[[""]], nil, SW_HIDE, nil)
--ok	hc.shell_execute([["]]..hc.ini_path..[[Cache\UnMountVHD.cmd"]], [["]]..hc.ini_path..[[Cache\File.vhd]]..[["]], nil, 'SW_HIDE', false)
end