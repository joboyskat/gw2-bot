-- Auto-generated by patchupdate.lua
return {
	base = 0x1793830,


	-- Player info
	playerName = 0x1700D34,
	playerAccount = 0x1700E60,

	playerDir1 = 0x17937A0,
	playerDir2 = 0x17937A4,
	playerX = 0x17937B8,
	playerZ = 0x17937BC,
	playerY = 0x17937C0,

	playerbasehp = 0x1705898,
	playerHPoffset = {0x168, 0x8},
	playerMaxHPoffset = {0x168, 0xC},
	playerKarmaoffset = {0x1B0, 0x4, 0x1B4},
	playerGoldoffset = {0x4, 0x16C, 0x50},
	playerInCombat = 0x16B8D64,
	playerDowned = 0x17051C4,

	skillCDaddress = 0x16DAC88,
	statbase = 0x16DAC88,
	actlvlOffset = 0x84,
	adjlvlOffset = 0xAC,
	TargetMob = 0x17DA430,
	TargetAll = 0x17DA448,

	XPbase = 0x17D9B1C,
	xpOffset = {0x80, 0x120, 0x14, 0x4},
	xpnextlvlOffset = {0x80, 0x120, 0x14, 0xC},


	-- Target info
	targetbaseAddress = 0x170D5A8,
	targetXoffset = {0x8, 0x2C, 0x104},
	targetZoffset = {0x8, 0x2C, 0x108},
	targetYoffset = {0x8, 0x2C, 0x10C},


	-- Interaction (F key) stuff
	Finteraction = 0x17DA418,
	FtextAddress = 0x1700C0C,
	FtextOffset = {0x0, 0x94, 0x14, 0x22},


	-- Input, movement, etc.
	moveForward = 0x17DCCC0,
	moveBackward = 0x17DCCC4,
	turnLeft = 0x17DCCD0,
	turnRight = 0x17DCCD4,


	-- UI based stuff
	mousewinX = 0x17DA454,
	mousewinZ = 0x17DA458,
	mousepointX = 0x17DA474,
	mousepointZ = 0x17DA478,
	mousepointY = 0x17DA47C,

	loadingbase = 0x17021DC,
	loadingOffset = {0xC8, 0x4, 0x0, 0x3BC},
	
	objectArray = 0x17DA4B8,

	--[[ NOTE: Unorganized addresses
		Anything below this line has (probably) *NOT* been updated automatically!
		It has only been retained from previous versions.
	--]]
	playerServX = {0x44, 0x1C, 0x88, 0xD0},
	playerVisX = {0x44, 0x1C, 0x5C, 0xB4},
	playerServZ = {0x44, 0x1C, 0x88, 0xD4},
	playerServY = {0x44, 0x1C, 0x88, 0xD8},
	FidOffset = {0x0, 0x94, 0x14, 0x8},
	speed = 0x17DA4C0,
	playerbaseui = 0x17DA3B8,
	speedOffset = {0x44, 0x1C, 0x170},
	playerVisZ = {0x44, 0x1C, 0x5C, 0xB8},
	playerVisY = {0x44, 0x1C, 0x5C, 0xBC},
}
