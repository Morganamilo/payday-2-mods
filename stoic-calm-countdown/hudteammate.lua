Hooks:RegisterHook("check_calm_time")

Hooks:PostHook(HUDTeammate,"_create_radial_health","_create_radial_health_stoic_calm_countdown",function(self,radial_health_panel)
	local teammate_panel = self._panel
	local health = self._radial_health_panel:child("radial_health")
	local colour = health.color
	
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
		local player_unit = managers.player:player_unit()

		if player_unit then
			local damage = player_unit:character_damage()

			if num <= 0 or damage:is_downed() then
				calm_panel:set_text("")
			else
				local total_tick = 0
				local chunks = {}

				for _, damage_chunk in ipairs(damage._delayed_damage.chunks) do
					local chunk = {
						tick = damage_chunk.tick,
						remaining = damage_chunk.remaining
					}
					table.insert(chunks, chunk)
				end


				local now  = TimerManager:game():time()
				local next_tick = damage._delayed_damage.next_tick or 0

				local timer = num - (next_tick - now)
				while timer >= 0 do
					local remaining_chunks = {}

					for _, damage_chunk in ipairs(chunks) do
						total_tick = total_tick + damage_chunk.tick
						damage_chunk.remaining = damage_chunk.remaining - damage_chunk.tick

						if damage._delayed_damage.epsilon < damage_chunk.remaining then
							table.insert(remaining_chunks, damage_chunk)
						end
					end
					
					chunks = remaining_chunks
					timer = timer - 1
				end

				if total_tick > damage:get_real_health() then
					calm_panel:set_color(Color.red)
				else
					calm_panel:set_color(Color.white)
				end

				calm_panel:set_text(string.format("%.1f", num))
			end
		end
	end)
end)







