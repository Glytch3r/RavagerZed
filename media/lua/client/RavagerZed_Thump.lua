
RavagerZed = RavagerZed or {}

function RavagerZed.doSledge(obj)
    if obj then
        local sq = obj:getSquare()
        if isClient() then
            sledgeDestroy(obj)
        else
            if sq then
                sq:RemoveTileObject(obj);
                sq:getSpecialObjects():remove(obj);
                sq:getObjects():remove(obj);
            end
        end
        if sq then
            sq:transmitRemoveItemFromSquare(obj)
        end
    end
end
function RavagerZed.thumpHandler(zed)
    if not zed or zed:isDead() then return end
    local isRavagerZed = RavagerZed.isRavagerZed(zed)
    local pl = getPlayer() 
    if isRavagerZed and pl then
        if RavagerZed.isClosestPl(pl, zed) then
            local rState =  zed:getRealState()
            if rState and string.lower(rState) == 'thump' then   
                local thump = zed:getThumpTarget()
                if thump then
                    local cond = zed:getThumpCondition() 
                    if cond and cond <= 0 then    
                        RavagerZed.doSledge(thump)
                        if getCore():getDebug() then 
                            zed:addLineChatElement('thump: '..tostring(thump))
                        end
                    else
                        zed:setThumpCondition(0) 
                    end
                end
            end
        end
    end
end
Events.OnZombieUpdate.Remove(RavagerZed.thumpHandler)
Events.OnZombieUpdate.Add(RavagerZed.thumpHandler)



function TriggerClimb(zombie)
	zombie:setVariable("hitreaction","Ravager_ClimbStart")
	zombie:setVariable("ZombieClimbWallChanceNumber",ZombRand(0,100))
end

function ClimbWallFunction(Zombie)
	if Zombie ~= nil and not Zombie:isDead() and not Zombie:isOnFloor() and not Zombie:isStaggerBack() then
		local objectDirection = 0.5
		local forwardDirectionX,forwardDirectionY = 1,1
		local countX,countY = 1,1
		if Zombie:getForwardDirection():getX() >= 0 then
			forwardDirectionX = math.ceil(Zombie:getForwardDirection():getX())
			countX = 1
		else
			forwardDirectionX = math.floor(Zombie:getForwardDirection():getX())
			countX = -1
		end

		if Zombie:getForwardDirection():getY() >= 0 then
			forwardDirectionY = math.ceil(Zombie:getForwardDirection():getY())
			countY = 1
		else
			forwardDirectionY = math.floor(Zombie:getForwardDirection():getY())
			countY = -1
		end

		for x = 0,forwardDirectionX+countX * 3,countX do
			for y = 0,forwardDirectionY+countY * 3,countY do
				local ZombieSquare = Zombie:getCurrentSquare()
				local square = getCell():getGridSquare(ZombieSquare:getX()+x,ZombieSquare:getY()+y,ZombieSquare:getZ())

				if square ~= nil then
					local objects = square:getObjects()
					for index = 0,objects:size()-1 do
						local object = objects:get(index)
						local square = object:getSquare()
						local properties = object:getProperties()

						if properties ~= nil then
							local name = properties:Val("FenceTypeHigh")
							if name ~= nil then
								if Zombie:getTarget() ~= nil then
									if Zombie:getVariableBoolean("bPathfind") or not Zombie:getVariableBoolean("bMoving") then
										Zombie:setVariable("bPathfind", false)
										Zombie:setVariable("bMoving", true)
									end

									if not Zombie:isFacingObject(object,objectDirection) and not Zombie:getVariableBoolean("Ravager_ClimbStart") then
										Zombie:faceThisObject(object)
									end

									if Zombie:isCollidedThisFrame() then
										if Zombie:isFacingObject(object,objectDirection) and not Zombie:getVariableBoolean("Ravager_ClimbStart") then
											TriggerClimb(Zombie)
										end
									end
								end
							end
						end

					end
				end
			end
		end
	end
end

function ClimbWallScript(zed)
	if zed:getVariableBoolean("Ravager_ClimbStart") and not zed:isDead() and not zed:isOnFloor() then
		if not zed:isVariable("hitreaction", "Ravager_ClimbDone") then
            zed:setVariable("hitreaction", "Ravager_ClimbDone")
        end
	end
end
Events.OnZombieUpdate.Add(ClimbWallScript)
