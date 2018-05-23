local _check_bleed_out = PlayerDamage._check_bleed_out

local function try_damage_control(self, can_activate_berserker, ignore_movement_state)
	local player_unit = managers.player:player_unit()
	if not player_unit then
		return
	end

	local local_peer_id = managers.network:session():local_peer():id()
	local has_no_grenades = managers.player:get_grenade_amount(local_peer_id) == 0
	local is_downed = game_state_machine:verify_game_state(GameStateFilters.downed)
	local swan_song_active = managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier")

	if has_no_grenades or is_downed or swan_song_active or not can_activate_berserker then
		return
	end

	
	
	local ability = managers.blackmarket:equipped_grenade()
	if ability ~= "damage_control" or self:remaining_delayed_damage() <= 0 then
		return
	end

	managers.player:attempt_ability(ability)
	return true
end

function PlayerDamage:_check_bleed_out(can_activate_berserker, ignore_movement_state)
	if self:get_real_health() == 0 and not self._check_berserker_done then
		if self._unit:movement():zipline_unit() then
			self._bleed_out_blocked_by_zipline = true

			return
		end

		if not ignore_movement_state and self._unit:movement():current_state():bleed_out_blocked() then
			self._bleed_out_blocked_by_movement_state = true

			return
		end
	
		if try_damage_control(self, can_activate_berserker, ignore_movement_state) then
			return
		end
	end

	_check_bleed_out(self, can_activate_berserker, ignore_movement_state)
end
