--[[
	Child of State class.
]]

include("../state.lua");

FarmState = class(State);

function FarmState:constructor()
	self.name = "Farm";
end

function FarmState:update()
	Player:update()
	if Player.TargetMob ~= 0 then
		stateman:pushEvent("Firstattack","farm have target");
	else
		for i = 1,10 do
			keyboardPress(Settings['turnleft'])
		end
	end
	keyboardPress(Settings['nexttarget'])	
end
table.insert(events,{name = "Farm" ,func = FarmState()})