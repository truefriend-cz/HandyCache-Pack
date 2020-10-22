--[[ <HCExtension>
@name			Monitor Hide
@author			truefriend-cz
@version		1.1
@description	Script for Monitor Hide objects
@license		CC BY-NC-SA (Attribution-NonCommercial-ShareAlike - https://creativecommons.org/licenses/by-nc-sa/)
@rule			https|http
@event			BeforeViewInMonitor
</HCExtension> ]]

function BeforeViewInMonitor()
	if re.match(hc.url, [[.*(oneoneoneone|:443|:1001|:5228|:9614|chat|detectportal.firefox.com|accounts.firefox.com|services.mozilla.com|api.accounts.firefox.com|/search|min.js|BlueBox|app.standsapp.org|newtab|blogID|chrome-sync/command|api/stats/qoe|gen_204|osname|chrome-cache-killer-defaults).*]]) then
		hc.hide_in_active_list = true
		hc.hide_in_monitor = true
	end
end
