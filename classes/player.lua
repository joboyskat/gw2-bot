--[[
	State base class. All other states should inherit from this.
]]

Player = class();

function Player:constructor()
	self.Name = "playername"
	self.Karma = 0
	self.Gold = 0
	self.HP = 1000
	self.MaxHP = 1000
	self.Heal = profile['heal'] or 60
	self.HealCD = 25
	self.X = 0
	self.Z = 0
	self.Y = 0
	self.Dir1 = 0
	self.Dir2 = 0
	self.TargetMob = 0
	self.TargetAll = 0
	self.Loot = false
	self.Interaction = false
	self.InCombat = false
	self.Ftext = ""
	self.TargetX = 0
	self.TargetZ = 0
	self.TargetY = 0

	self.turnDir = nil; -- Turn left/right
	self.fbMovement = nil; -- Move forward/backward
	self.skill1used = 0
	self.skill2used = 0
	self.skill3used = 0
	self.skill4used = 0
	self.skill5used = 0
	self.skill6used = 0
	self.skill7used = 0
	self.skill8used = 0
	self.skill9used = 0	
	self.skill0used = 0

	self.movementLastUpdate = 0;
end
function Player:targetupdate()
	local proc = getProc()
	self.TargetMob = memoryReadInt(proc, addresses.TargetMob) or self.TargetMob;
	self.TargetAll = memoryReadInt(proc, addresses.TargetAll) or self.TargetAll;
	if self.TargetAll ~= 0 then
		self.TargetX = memoryReadFloatPtr(proc, addresses.targetbaseAddress, addresses.targetXoffset) or self.TargetX
		self.TargetZ =  memoryReadFloatPtr(proc, addresses.targetbaseAddress, addresses.targetZoffset) or self.TargetZ
		self.TargetY =  memoryReadFloatPtr(proc, addresses.targetbaseAddress, addresses.targetYoffset) or self.TargetY
	else
		self.TargetX = 0
		self.TargetZ = 0
		self.TargetY = 0		
	end

end
function Player:update()
	local curtime = getTime();
	local proc = getProc()
	--self.Name = memoryReadUString(getProc(),addresses.playerName)
	self.Name = memoryReadRepeat("ustring", proc, addresses.playerName);
	--self.Name = string.gsub(self.Name,"%s","_") -- Note: We should keep spaces here. Replace with _ where needed elsewhere.
	--self.Account = memoryReadUString(getProc(),addresses.playerAccount)
	self.Account = memoryReadRepeat("ustring", proc, addresses.playerAccount);

	self.Karma = memoryReadRepeat("intptr", proc, addresses.playerbasehp, addresses.playerKarmaoffset) or self.Karma; --memoryReadIntPtr(proc, addresses.playerbasehp, addresses.playerKarmaoffset) or self.Karma;
	self.Gold = memoryReadRepeat("intptr", proc, addresses.playerbasehp, addresses.playerGoldoffset) or self.Gold; --memoryReadIntPtr(proc, addresses.playerbasehp, addresses.playerGoldoffset) or self.Gold;
	self.HP = memoryReadRepeat("floatptr", proc, addresses.playerbasehp, addresses.playerHPoffset) or self.HP; --memoryReadFloatPtr(proc, addresses.playerbasehp, addresses.playerHPoffset) or self.HP;
	self.MaxHP = memoryReadRepeat("floatptr", proc, addresses.playerbasehp, addresses.playerMaxHPoffset) or self.MaxHP; --memoryReadFloatPtr(proc, addresses.playerbasehp, addresses.playerMaxHPoffset) or self.MaxHP;
	self.X = memoryReadRepeat("float", proc, addresses.playerX) or self.X; --memoryReadFloat(proc,  addresses.playerX) or self.X;
	self.Z = memoryReadRepeat("float", proc, addresses.playerZ) or self.Z; --memoryReadFloat(proc,  addresses.playerZ) or self.Z;
	self.Y = memoryReadRepeat("float", proc, addresses.playerY) or self.Y; --memoryReadFloat(proc,  addresses.playerY) or self.Y;
	self.Dir1 = memoryReadRepeat("float", proc, addresses.playerDir1) or self.Dir1; --memoryReadFloat(proc,  addresses.playerDir1) or self.Dir1;
	self.Dir2 = memoryReadRepeat("float", proc, addresses.playerDir2) or self.Dir2; --memoryReadFloat(proc,  addresses.playerDir2) or self.Dir2;
	self.TargetMob = memoryReadRepeat("int", proc, addresses.TargetMob) or self.TargetMob; --memoryReadInt(proc, addresses.TargetMob) or self.TargetMob;
	self.TargetAll = memoryReadRepeat("int", proc, addresses.TargetAll) or self.TargetAll; --memoryReadInt(proc, addresses.TargetAll) or self.TargetAll;
	self.Interaction = (memoryReadRepeat("int", proc, addresses.Finteraction) ~= 0)
	self.InCombat = (memoryReadRepeat("int", proc, addresses.playerInCombat) ~= 0)
	
	if self.TargetAll ~= 0 then
		self.TargetX = memoryReadFloatPtr(proc, addresses.targetbaseAddress, addresses.targetXoffset) or self.TargetX
		self.TargetZ =  memoryReadFloatPtr(proc, addresses.targetbaseAddress, addresses.targetZoffset) or self.TargetZ
		self.TargetY =  memoryReadFloatPtr(proc, addresses.targetbaseAddress, addresses.targetYoffset) or self.TargetY
	else
		self.TargetX = 0
		self.TargetZ = 0
		self.TargetY = 0		
	end

	-- Only update movement info occasionally; reduce unnecessary memory reads
	if( deltaTime(curtime, self.movementLastUpdate) > 1000 ) then
		if( self.turnDir == "left" ) then
			-- Ensure we're turning left.
			memoryWriteInt(proc, addresses.turnLeft, 1);
			memoryWriteInt(proc, addresses.turnRight, 0);
		elseif( self.turnDir == "right" ) then
			-- Ensure we're turning right.
			memoryWriteInt(proc, addresses.turnLeft, 0);
			memoryWriteInt(proc, addresses.turnRight, 1);
		else
			-- Ensure we're not turning
			memoryWriteInt(proc, addresses.turnLeft, 0);
			memoryWriteInt(proc, addresses.turnRight, 0);
		end

		if( self.fbMovement == "forward" ) then
			-- Ensure we're moving foward
			memoryWriteInt(proc, addresses.moveForward, 1);
			memoryWriteInt(proc, addresses.moveBackward, 0);
		elseif( self.fbMovement == "backward" ) then
			-- Ensure we're moving backward
			memoryWriteInt(proc, addresses.moveForward, 0);
			memoryWriteInt(proc, addresses.moveBackward, 1);
		else
			-- Ensure we're not moving
			memoryWriteInt(proc, addresses.moveForward, 0);
			memoryWriteInt(proc, addresses.moveBackward, 0);
		end

		self.movementLastUpdate = curtime;
	end

	self.Angle = math.atan2(self.Dir2, self.Dir1) + math.pi;

	--self.Ftext = "" -- reset it as the text doesn't change in memory if no "F" on screen	
	--[[if self.Interaction == true then
		self.Ftext = memoryReadUStringPtr(proc,addresses.FtextAddress, addresses.FtextOffset) or ""
		if( SETTINGS['language'] == "russian" ) then
			self.Ftext = utf82oem_russian(self.Ftext)
		else
			self.Ftext = utf8ToAscii_umlauts(self.Ftext)
		end
	end]]
end


--		self.fbMovement
function Player:moveForward()
	if( self.fbMovement == "forward" ) then
		return; -- If we're already doing it, ignore this call.
	end

	if( self.fbMovement == "backward" ) then
		--keyboardRelease(keySettings['backward']); -- Stop turning right
		memoryWriteInt(getProc(), addresses.moveBackward, 0);
	end

	self.fbMovement = "forward";

	--keyboardHold(keySettings['forward']);
	memoryWriteInt(getProc(), addresses.moveForward, 1);
	self.movementLastUpdate = getTime();
end

function Player:moveBackward()
	if( self.fbMovement == "backward" ) then
		return; -- If we're already doing it, ignore this call.
	end

	if( self.fbMovement == "forward" ) then
		--keyboardRelease(keySettings['forward']); -- Stop turning right
		memoryWriteInt(getProc(), addresses.moveForward, 0);
	end

	self.fbMovement = "backward";

	--keyboardHold(keySettings['backward']);
	memoryWriteInt(getProc(), addresses.moveBackward, 0);
	self.movementLastUpdate = getTime();
end

function Player:stopMoving()
	if( self.fbMovement ) then
		memoryWriteInt(getProc(), addresses.moveForward, 0);
		memoryWriteInt(getProc(), addresses.moveBackward, 0);
	end

	self.movementLastUpdate = getTime();
	self.fbMovement = nil;
end

function Player:turnLeft()
	if( self.turnDir == "left" ) then
		return; -- If we're already doing it, ignore this call.
	end

	if( self.turnDir == "right" ) then
		--keyboardRelease(keySettings['turnright']); -- Stop turning right
		memoryWriteInt(getProc(), addresses.turnRight, 0);
	end

	self.turnDir = "left";

	--keyboardHold(keySettings['turnleft']);
	memoryWriteInt(getProc(), addresses.turnLeft, 1);
	self.movementLastUpdate = getTime();
end

function Player:turnRight()
	if( self.turnDir == "right" ) then
		return; -- If we're already doing it, ignore this call.
	end

	if( self.turnDir == "left" ) then
		--keyboardRelease(keySettings['turnleft']); -- Stop turning left
		memoryWriteInt(getProc(), addresses.turnLeft, 0);
	end

	self.turnDir = "right";

	--keyboardHold(keySettings['turnright']);
	memoryWriteInt(getProc(), addresses.turnRight, 1);
	self.movementLastUpdate = getTime();
end

function Player:stopTurning()
	if( not self.turnDir ) then
		return;
	end

	if( self.turnDir ) then
		--keyboardRelease(keySettings['turnleft']);
		--keyboardRelease(keySettings['turnright']);

		memoryWriteInt(getProc(), addresses.turnLeft, 0);
		memoryWriteInt(getProc(), addresses.turnRight, 0);
	end

	self.turnDir = nil;
end

function Player:facedirection(x, z,_angle)
	x = x or 0;
	z = z or 0;
	_angle = _angle or 0.13
	-- Check our angle to the waypoint.
	local angle = math.atan2(z - self.Z, x - self.X) + math.pi;
	local anglediff = self.Angle - angle;

	if( math.abs(anglediff) > _angle ) then
		if( self.fbMovement ) then -- Stop running forward.
			self:stopMoving();
		end

		-- Attempt to face it
		if( anglediff < 0 or anglediff > math.pi ) then
			-- Rotate left
			self:turnLeft();
		else
			-- Rotate right
			self:turnRight();
		end
	else
		self:stopTurning();
		return true
	end
end

function Player:moveTo_step(x, z, _dist)
	x = x or 0;
	z = z or 0;
	_dist = _dist or 50;

	-- Check our angle to the waypoint.
	local angle = math.atan2(z - self.Z, x - self.X) + math.pi;
	local anglediff = self.Angle - angle;

	if player:facedirection(x, z) then
		if distance(player.X, player.Z, x, z) > _dist then
			self:moveForward()
		else
			self:stopMoving()
			return true
		end
	end

end

-- look for target by pressing Next Targe Button
-- optional check distance
-- _dist = optional distance to look for target within
function Player:getNextTarget(_dist)

	keyboardPress(keySettings['nexttarget'])
	
	self:update()

	if self.TargetMob == 0 then
		return false
	end

	if distance( self.X, self.Z, self.TargetX, self.TargetZ) < _dist then	-- target within distances?
		return true
	else
		return false
	end

end


function Player:useSkills(_heal)
	if _heal then
		if profile['skill6use'] == true and os.difftime(os.time(),self.skill6used) > profile['skill6cd'] + SETTINGS['lagallowance'] then
			keyboardPress(key.VK_6)
			if profile['skill6ground'] == true then
				keyboardPress(key.VK_6)
			end
			cprintf(cli.green,"heal key 6\n")
			yrest(profile['skill6casttime']*1000)
			self.skill6used = os.time()			
		end
		return
	end
	if profile['skill2use'] == true and os.difftime(os.time(),self.skill2used) > profile['skill2cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_2)
		if profile['skill2ground'] == true then
			keyboardPress(key.VK_2)
		end
		cprintf(cli.red,"attack 2\n")
		yrest(profile['skill2casttime']*1000)
		self.skill2used = os.time()
	end
	if profile['skill3use'] == true and os.difftime(os.time(),self.skill3used) > profile['skill3cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_3)
		if profile['skill3ground'] == true then
			keyboardPress(key.VK_3)
		end		
		cprintf(cli.red,"attack 3\n")
		yrest(profile['skill3casttime']*1000)
		self.skill3used = os.time()
	end
	if profile['skill4use'] == true and os.difftime(os.time(),self.skill4used) > profile['skill4cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_4)	
		if profile['skill4ground'] == true then
			keyboardPress(key.VK_4)
		end		
		cprintf(cli.red,"attack 4\n")
		yrest(profile['skill4casttime']*1000)
		self.skill4used = os.time()
	end
	if profile['skill5use'] == true and os.difftime(os.time(),self.skill5used) > profile['skill5cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_5)
		if profile['skill5ground'] == true then
			keyboardPress(key.VK_5)
		end
		cprintf(cli.red,"attack 5\n")
		yrest(profile['skill5casttime']*1000)
		self.skill5used = os.time()		
	end
	if profile['skill7use'] == true and os.difftime(os.time(),self.skill7used) > profile['skill7cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_7)
		if profile['skill7ground'] == true then
			keyboardPress(key.VK_7)
		end
		cprintf(cli.red,"attack 7\n")	
		yrest(profile['skill7casttime']*1000)
		self.skill7used = os.time()		
	end
	if profile['skill8use'] == true and os.difftime(os.time(),self.skill8used) > profile['skill8cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_8)
		if profile['skill8ground'] == true then
			keyboardPress(key.VK_8)
		end
		cprintf(cli.red,"attack 8\n")
		yrest(profile['skill8casttime']*1000)
		self.skill8used = os.time()
	end
	if profile['skill9use'] == true and os.difftime(os.time(),self.skill9used) > profile['skill9cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_9)
		if profile['skill9ground'] == true then
			keyboardPress(key.VK_9)
		end
		cprintf(cli.red,"attack 9\n")
		yrest(profile['skill9casttime']*1000)
		self.skill9used = os.time()
	end
	if profile['skill0use'] == true and os.difftime(os.time(),self.skill0used) > profile['skill0cd'] + SETTINGS['lagallowance'] then
		keyboardPress(key.VK_0)
		if profile['skill0ground'] == true then
			keyboardPress(key.VK_0)
		end
		cprintf(cli.red,"attack 0\n")
		yrest(profile['skill0casttime']*1000)
		self.skill0used = os.time()
	end
	if os.difftime(os.time(),self.skill1used) > profile['skill1cd'] then
		keyboardPress(key.VK_1)
		self.skill1used = os.time()	
	end	
end