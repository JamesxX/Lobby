AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
--[[
local schdChase = ai_schedule.New( "Wandering_Citizen" )
	
schdChase:EngTask( "TASK_GET_PATH_TO_RANDOM_NODE", 	60 )
schdChase:EngTask( "TASK_WALK_PATH", 0 )
//schdChase:EngTask( "TASK_STOP_MOVING", 0 )
schdChase:EngTask( "TASK_WAIT", 5 )
schdChase:EngTask( "TASK_SOUND_IDLE")--]]

local models = {}
models[1] = "models/Humans/Group01/Female_01.mdl"
models[2] = "models/Humans/Group01/Female_02.mdl"
models[3] = "models/Humans/Group01/Female_03.mdl"
models[4] = "models/Humans/Group01/Female_04.mdl"
models[5] = "models/Humans/Group01/Female_06.mdl"
models[6] = "models/Humans/Group01/Female_07.mdl"
models[7] = "models/Humans/Group01/Male_01.mdl"
models[8] = "models/Humans/Group01/Male_02.mdl"
models[9] = "models/Humans/Group01/Male_03.mdl"
models[10] = "models/Humans/Group01/Male_04.mdl"
models[11] = "models/Humans/Group01/Male_05.mdl"
models[12] = "models/Humans/Group01/Male_06.mdl"
models[13] = "models/Humans/Group01/Male_08.mdl"
models[14] = "models/Humans/Group01/Male_09.mdl"
 
function ENT:Initialize()
 
	local r = math.random(#models)
	self:SetModel( models[r] )
	//self:SetModel( "models/Humans/Group01/Female_01.mdl" )
	
 
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
 
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
 
	self:CapabilitiesAdd( CAP_MOVE_GROUND  + CAP_ANIMATEDFACE + CAP_TURN_HEAD  )
 
	self:SetMaxYawSpeed( 5000 )

	self:SetHealth(100)
	
	self:SetUseType(SIMPLE_USE)
 
end


 
function ENT:SelectSchedule()
 
	--self:StartSchedule( schdChase )
 
end