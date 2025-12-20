

function RavagerZed.hitZed(zed, pl, part, wpn)


	if RavagerZed.isRavager(zed) then


		zed:setAvoidDamage(true)

		local hp = zed:getHealth()
		if hp then
			if isDebugEnabled() then
				zed:SayDebug(tostring(hp))
				print(tostring(hp))
			end

			if hp < 0.15 then
				zed:setAvoidDamage(false)
				zed:setImmortalTutorialZombie(false)
			end
		end




		if plAtkPos and isDebugEnabled() then
			zed:addLineChatElement(tostring(plAtkPos))
		end


		if RavagerZed.isUnarmed(pl) then
			zed:setVariable("hitreaction", "HitArmor")


		else
			if not zed:isUnderVehicle()  then
				if zed:getPlayerAttackPosition() == 'BEHIND' then
					local page = RavagerZed.getSandboxPage(num)
					local varHP = page.HP or 12
					local mult = page.Multiplier or 1
					local healthDmg = mult / varHP

					zed:setHealth(zed:getHealth() - healthDmg)
					zed:setVariable("hitreaction", "TankZed_HitReact")
					zed:update();
				else
					zed:setVariable("hitreaction", "HitArmor")
				end


				if pl == getPlayer() then
					zed:getEmitter():stopAll()
					RavagerZed.playPainSfx(zed)
				end
			end
		end
	end
end


Events.OnHitZombie.Remove(RavagerZed.hitZed)
Events.OnHitZombie.Add(RavagerZed.hitZed)
