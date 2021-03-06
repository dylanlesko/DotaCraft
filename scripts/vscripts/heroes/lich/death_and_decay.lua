--[[
	Author: Noya
	Date: 20.01.2015.
	Creates a dummy unit to apply the Rain of Fire thinker modifier which does the waves
]]
function DeathAndDecayStart( event )
	-- Variables
	local caster = event.caster
	local point = event.target_points[1]

	caster.death_and_decay_dummy = CreateUnitByName("dummy_unit_vulnerable", point, false, caster, caster, caster:GetTeam())
	event.ability:ApplyDataDrivenModifier(caster, caster.death_and_decay_dummy, "modifier_death_and_decay_thinker", nil)
end

function DeathAndDecayEnd( event )
	local caster = event.caster

	caster:StopSound("Hero_Lich.ChainFrostLoop")
	caster.death_and_decay_dummy:RemoveSelf()
end


--[[
	Author: Noya
	Date: 29.01.2015.
	Does health percentage damage based on every target
]]
function DeathAndDecayDamage( event )
	local caster = event.caster
	local ability = event.ability
	local AbilityDamageType = ability:GetAbilityDamageType()
	local targets = event.target_entities
	local health_percent_damage_per_sec = ability:GetLevelSpecialValueFor( "health_percent_damage_per_sec" , ability:GetLevel() - 1  ) * 0.01

	for _,target in pairs(targets) do
		local targetHP = target:GetMaxHealth()
		local damage = targetHP * health_percent_damage_per_sec

		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = AbilityDamageType })

		-- Apply particle on each damaged targed, ignore the dummy
		local particleName = "particles/custom/enigma_malefice.vpcf"
		if target:GetUnitName() ~= "dummy_unit_vulnerable" then
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
			Timers:CreateTimer(1.0, function() ParticleManager:DestroyParticle(particle,false) end)
		end
	end
end