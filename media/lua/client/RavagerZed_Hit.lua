
function RavagerZed.hitZed(zed, pl, part, wpn)
    if not zed or not pl then return end

	
	if RavagerZed.isRavagerZed(zed) then

		zed:setAvoidDamage(true)
		local hp = zed:getHealth()
		if hp then
	

			if hp < 0.15 then
				zed:setAvoidDamage(false)
				zed:setImmortalTutorialZombie(false)
			end
		end

		if plAtkPos and isDebugEnabled() then
			zed:addLineChatElement(tostring(plAtkPos))
		end

		
		if not zed:isUnderVehicle()  then

			if zed:getPlayerAttackPosition() == 'BEHIND' then
				zed:setVariable("hitreaction", "Ravager_Hit")
			else
				if RavagerZed.isUnarmed(pl) then
					zed:setVariable("hitreaction", "Ravager_ToFloor")
				end
				--zed:setVariable("hitreaction", "Ravager_ToFloor")					
			end

			local varHP = SandboxVars.RavagerZed.HP
			local mult = SandboxVars.RavagerZed.dmgMult
			local healthDmg = mult / varHP

			if not RavagerZed.isUnarmed(pl) then
				zed:setHealth(zed:getHealth() - healthDmg)
				zed:update()

				if  getCore():getDebug() then
					zed:addLineChatElement(tostring(zed:getHealth()))
					print(tostring(zed:getHealth()))
				end
			else
				zed:setVariable("Ravager_Slam", false)
			end

		end
	end
end

Events.OnHitZombie.Remove(RavagerZed.hitZed)
Events.OnHitZombie.Add(RavagerZed.hitZed)

function RavagerZed.hitPl(zed, pl, wpn, dmg)
	if not zed or not pl then return end
	if instanceof(zed, "IsoZombie") and instanceof(pl, "IsoPlayer") then	
		if RavagerZed.isRavagerZed(zed) then
			if getCore():getDebug() then 
				zed:addLineChatElement(tostring(zed:getHealth()))
			end
		end
	end
end
Events.OnWeaponHitCharacter.Remove(RavagerZed.hitPl)
Events.OnWeaponHitCharacter.Add(RavagerZed.hitPl)





function RavagerZed.deathSfx(zed)
	if instanceof(zed, "IsoZombie") and RavagerZed.isRavagerZed(zed) then	
		
	end
end

Events.OnCharacterDeath.Add(RavagerZed.deathSfx)