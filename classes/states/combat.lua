--[[
	Child of State class.
]]

include("../state.lua");

CombatState = class(State);

function CombatState:constructor()
	self.name = "Combat";
	self.autostarted = nil
	self.combat = false
	--self.startfight = os.time() -- DEPRECATED
	self.startfighttime = getTime();
	self.lastTargetTime = getTime();
end

function CombatState:update()
	logger:log('debug-states',"Coming to CombatState:update()");
	
	targetupdate();
	statusupdate();
	
	if not player.InCombat	then
--		statusupdate();
		if profile['loot'] == true and deltaTime(getTime(), self.startfighttime) > 1000 then
			stateman:pushEvent("Loot", "finished combat"); 
		end
		stateman:popState("combat ended");	
	end

	if player.TargetMob ~= 0 then
		player:useSkills()
	else
		-- So we don't target TOO fast.
		if( deltaTime(getTime(), self.lastTargetTime) > 500 ) then
			keyboardPress(keySettings['nexttarget']);
			self.lastTargetTime = getTime();
		end
	end
end

-- Handle events
function CombatState:handleEvent(event)
	if event == "Heal"  then
		player:useSkills(_heal)
		return true;
	end
end
table.insert(events,{name = "Combat", func = CombatState()})