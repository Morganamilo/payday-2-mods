local add_grenade_amount  = PlayerManager.add_grenade_amount

function PlayerManager:add_grenade_amount(amount, sync)
	if amount == -1 and managers.blackmarket:equipped_grenade() == "damage_control" then
		local player_unit = managers.player:player_unit()

		if player_unit then
			local player_damage = player_unit:character_damage()
			if player_damage:remaining_delayed_damage() <= 0 then
				return
			end
		end
	end

	add_grenade_amount(self, amount, sync)
end
