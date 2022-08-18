--[[
	https://github.com/leme6156/proxi-stuff

	For the noobs

	Requires https://github.com/awesomeusername69420/miscellaneous-gmod-stuff/blob/main/Includes/modules/md5.lua
]]

pcall(include, "includes/modules/md5.lua")

local SpreadCones = {}

local function CalculateNoSpread(Weapon, cmd, pAngle)
	local WeaponCone = SpreadCones[Weapon:GetClass()]

	if not md5 or not WeaponCone then
		return pAngle
	end

	local Seed = md5.PseudoRandom(cmd:CommandNumber())

	local X = md5.EngineSpread[Seed][1]
	local Y = md5.EngineSpread[Seed][2]

	local Forward = pAngle:Forward()
	local Right = pAngle:Right()
	local Up = pAngle:Up()

	local SpreadVector = Forward + (X * WeaponCone.x * Right * -1) + (Y * WeaponCone.y * Up * -1)
	local SpreadAngle = SpreadVector:Angle()
	SpreadAngle:Normalize()

	return SpreadAngle
end

hook.Add("EntityFireBullets", "pt_EntityFireBullets", function(Entity, Data)
	if Entity ~= LocalPlayer() then return end

	local Weapon = Entity:GetActiveWeapon()
	if not IsValid(Weapon) then return end

	SpreadCones[Weapon:GetClass()] = Data.Spread
end)

hook.Add("CreateMoveEx", "pt_CreateMoveEx", function(cmd)
	if not cmd:KeyDown(IN_ATTACK) then return end

	local pAngle = Angle(0, 90, 0) -- Set to your aimbot angle [ (TargetPos - EyePos):Angle() ]

	local Weapon = LocalPlayer():GetActiveWeapon()

	if IsValid(Weapon) then
		pAngle = CalculateNoSpread(Weapon, cmd, pAngle)
	end

	cmd:SetInWorldClicker(true)
	cmd:SetWorldClickerAngles(pAngle:Forward())
end)
