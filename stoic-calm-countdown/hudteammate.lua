Hooks:RegisterHook("check_calm_time")

Hooks:PostHook(HUDTeammate,"_create_radial_health","_create_radial_health_stoic_calm_countdown",function(self,radial_health_panel)
	local calm_panel = self._radial_health_panel:text({
		name = "stoic_calm_countdown",
		vertical = "center",
		font_size = 22,
		align = "center",
		text = "",
		font = "fonts/font_medium_mf",
		layer = 1,
		visible = true,
		color = Color.white,
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})

	Hooks:Add("check_calm_time", "stoic_calm_countdown", function(num) 
		if num <= 0 then
			calm_panel:set_text("")
		else
			calm_panel:set_text(string.format("%.1f", num))
		end
	end)
end)







