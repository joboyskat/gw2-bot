--[[
	Child of State class.
]]

include("../state.lua");

CombatState = class(State);

function CombatState:constructor()
	self.name = "Combat";
	self.selfskill1cd = 0
	self.selfskill2cd = 8
	self.selfskill3cd = 5
	self.selfskill4cd = 30
	self.autostarted = nil
	self.combat = false
	if self.timerset == nil then -- to set the timers
		self.selfskill1used = 0
		self.selfskill2used = 0
		self.selfskill3used = 0
		self.selfskill4used = 0
		self.timerset = true
	end
	self.startfight = os.time()
end

function CombatState:update()
	Player:update()
	if not Player.InCombat	then stateman:pushEvent("Loot","finished combat"); stateman:popState("combat ended");	end
	if Player.TargetMob ~= 0 then
		if self.autostarted == nil then
			keyboardPress(key.VK_1)
			self.autostarted = true
			cprintf(cli.red,"auto attack started\n")
		end
		if os.difftime(os.time(),self.selfskill2used) > self.selfskill2cd then
			keyboardPress(key.VK_2)
			yrest(100)
			keyboardPress(key.VK_2) -- target ground skill
			self.selfskill2used = os.time()
			cprintf(cli.red,"attack 2\n")
		elseif os.difftime(os.time(),self.selfskill3used) > self.selfskill3cd then
			keyboardPress(key.VK_3)	
			self.selfskill3used = os.time()
			cprintf(cli.red,"attack 3\n")
		elseif os.difftime(os.time(),self.selfskill4used) > self.selfskill4cd then
			keyboardPress(key.VK_4)
			self.selfskill4used = os.time()
			cprintf(cli.red,"attack 4\n")			
		end
		yrest(1000)
	else
		stateman:popState("combat no target");
	end
end

-- Handle events
function CombatState:handleEvent(event)
	if event == "Heal"  then
		Logger:log('info',"in combat need heals")
		self.newbattle = false
		stateman:pushState(HealState())
		return true;
	end
end
table.insert(events,{name = "Combat", func = CombatState()})