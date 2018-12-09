-- Generated from template
_G.nCOUNTDOWNTIMER = 1200

if CSniperWarsGameMode == nil then
	_G.CSniperWarsGameMode = class({})
end

require( "libraries/utility_functions" )
require( "libraries/notifications" )
require( "libraries/projectiles" )
require( "statcollection/init" )
require( "libraries/physics" )
require( "libraries/timers" )
require( "itemspawning" )

function Precache( context )
	PrecacheItemByNameSync( "item_treasure_chest", context )
	PrecacheModel( "item_treasure_chest", context )
    PrecacheUnitByNameAsync( "npc_dota_treasure_courier", function(unit) end )
    PrecacheModel( "npc_dota_treasure_courier", context )
    PrecacheUnitByNameAsync( "npc_sniper_barricade", function(unit) end )
    PrecacheModel( "npc_sniper_barricade", context )
    PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
    PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
    PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timber_chain_trail.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf", context )
    PrecacheResource( "particle", "particles/newplayer_fx/npx_wood_break.vpcf", context )
    PrecacheResource( "particle", "particles/sniper_grenade_explosion.vpcf", context )
    PrecacheResource( "particle", "particles/items2_fx/tranquil_boots_healing.vpcf", context)
	PrecacheResource( "particle", "particles/econ/events/ti7/ti7_hero_effect.vpcf", context)
	PrecacheResource( "particle", "particles/developer_effects/ti7_hero_effect_pink.vpcf", context)
	PrecacheResource( "particle", "particles/econ/events/ti6/phase_boots_ti6.vpcf", context)
	PrecacheResource( "particle", "particles/newplayer_fx/npx_wood_break.vpcf", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context )	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", context )
end

-- Create the game mode when we activate
function Activate()
	-- Create our game mode and initialize it
	CSniperWarsGameMode:InitGameMode()
end

function CSniperWarsGameMode:InitGameMode()			
	print( "[SniperWars] is loaded." )
	-- Handle Custom Teams
	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	PLAYER_COLORS = {}
    PLAYER_COLORS[0] = "#3dd296;"
    PLAYER_COLORS[1] = "#f3c909;"
    PLAYER_COLORS[2] = "#c54da8;"
    PLAYER_COLORS[3] = "#FF6C00;"
    PLAYER_COLORS[4] = "#3455FF;"
    PLAYER_COLORS[5] = "#65d413;"
    PLAYER_COLORS[6] = "#815336;"
    PLAYER_COLORS[7] = "#1bc0d8;"
    PLAYER_COLORS[8] = "#c7e40d;"
    PLAYER_COLORS[9] = "#8c2af4;"

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self.m_GatheredShuffledTeams = {}

	self.numSpawnCamps = 5
	self.specialItem = ""
	self.spawnTime = 90
	self.nNextSpawnItemNumber = 1
	self.hasWarnedSpawn = false
	self.allSpawned = false
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	self.itemSpawnIndex = 1
	self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	self.tier1ItemBucket = {}
	self.tier2ItemBucket = {}
	self.tier3ItemBucket = {}
	self.tier4ItemBucket = {}

	self.TEAM_KILLS_TO_WIN = 25
	self.CLOSE_TO_VICTORY_THRESHOLD = 5
	self.LAST_KILL = 1

	self:GatherAndRegisterValidTeams()
	GameRules:GetGameModeEntity().CSniperWarsGameMode = self

	-- Custom XP
	MAX_LEVEL = 24
	XP_PER_LEVEL_TABLE = {
		0, -- 1
		100, -- 2
		400, -- 3
		700, -- 4
		1000, -- 5
		1300, -- 6
		1600, -- 7
		1900, -- 8
		2200, -- 9
		2500, -- 10
		2800, -- 11
		3100,  -- 12
		3400,  -- 13
		3700,  -- 14
		4000,  -- 15
		4400,  -- 16
		4800,  -- 17
		5200,  -- 18
		5700,  -- 19
		6200,  -- 20
		6700,  -- 21
		7500,  -- 22
		8000,  -- 23
		8500  -- 24
	}

	--for k,v in pairs(XP_PER_LEVEL_TABLE) do print(k,v) end

	GameRules:GetGameModeEntity():SetUseCustomHeroLevels ( true )
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel ( MAX_LEVEL )
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

	-- Rules
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:SetPreGameTime( 5 )
	GameRules:SetHeroSelectionTime( 20.0 )
	GameRules:SetTreeRegrowTime( 10.0 )
	-- Gamemode Rules
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled( false )
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 100 )
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 100 )
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 30 )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 5.0 )
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1250.0 )
	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_sniper")

	-- Hooks
	ListenToGameEvent('npc_spawned', Dynamic_Wrap( CSniperWarsGameMode, 'OnNPCSpawned' ), self )
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap( CSniperWarsGameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( CSniperWarsGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap( CSniperWarsGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap( CSniperWarsGameMode, "OnItemPickUp"), self )
	ListenToGameEvent('dota_npc_goal_reached', Dynamic_Wrap( CSniperWarsGameMode, "OnNpcGoalReached" ), self )

	Convars:RegisterCommand( "sniper_wars_force_item_drop", function(...) self:ForceSpawnItem() end, "Force an item drop.", FCVAR_CHEAT )
end

--------------------------------------------------------------------------------
-- Event: OnItemPickUp
--------------------------------------------------------------------------------
function CSniperWarsGameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )

	if event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Stop", "0", 0, self, self )
		CSniperWarsGameMode:SpecialItemAdd( event )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end

--------------------------------------------------------------------------------
-- Event: OnNpcGoalReached
--------------------------------------------------------------------------------
function CSniperWarsGameMode:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )
	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		CSniperWarsGameMode:TreasureDrop( npc )
	end
end

---------------------------------------------------------------------------
-- Event: OnNPCSpawned, handle first spawn
---------------------------------------------------------------------------
function CSniperWarsGameMode:OnNPCSpawned(event)
	print ('[SniperWars] OnNPCSpawned')
	local spawnedUnit = EntIndexToHScript(event.entindex)
	local hero = EntIndexToHScript(event.entindex)
	local ability1 = spawnedUnit:FindAbilityByName("sniper_assassinate_wars")
	local ability2 = spawnedUnit:FindAbilityByName("sniper_jump_wars")
	
	Physics:Unit(hero)
	hero:SetPhysicsFriction(0)
	hero:SetPhysicsAcceleration(Vector(0,0,-900))

	hero:OnPhysicsFrame(function(unit)
		local origin = unit:GetAbsOrigin()
		local vel = hero:GetPhysicsVelocity()
		local ground = GetGroundPosition(origin, unit)

		if origin.z - 10 < ground.z then
			hero.onground = true
			hero:PreventDI(false)
			hero:SetPhysicsVelocity(Vector(0,0,vel.z))
			hero:RemoveGesture(ACT_DOTA_TELEPORT)
			hero:FollowNavMesh(true)
			hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
     		FindClearSpaceForUnit(hero, origin, false)
			return
		end

		local forward = hero:GetForwardVector() * hero.forwardSpeed
		hero:SetPhysicsVelocity(Vector(forward.x, forward.y, vel.z))
		end)

	if spawnedUnit:IsRealHero() and spawnedUnit.bFirstSpawned == nil then
		spawnedUnit.bFirstSpawned = true
		spawnedUnit:SetGold(0,false)
		spawnedUnit:SetGold(500,true)
		ability1:SetLevel(1)
		ability2:SetLevel(1)
	end
end

---------------------------------------------------------------------------
-- Event: OnTeamKillCredit, see if anyone won
---------------------------------------------------------------------------
function CSniperWarsGameMode:OnTeamKillCredit( event )
--	print( "OnKillCredit" )
--	DeepPrint( event )
	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = self.TEAM_KILLS_TO_WIN - nTeamKills
	local KillerName = PlayerResource:GetPlayerName(nKillerID)

	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= self.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	if nKillsRemaining == self.CLOSE_TO_VICTORY_THRESHOLD then
		Notifications:TopToAll({text="<font color='" .. PLAYER_COLORS[nKillerID] .. "'>" .. KillerName .. "</font>  Is Only <font color='#c50d23'>5 Kills</font> Away From Victory!", duration= 3.0})
	elseif nKillsRemaining == self.LAST_KILL then
		Notifications:TopToAll({text="<font color='" .. PLAYER_COLORS[nKillerID] .. "'>" .. KillerName .. "</font>  Is Only <font color='#c50d23'>1 Kill</font> Away From Victory!", duration= 3.0})
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end
---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function CSniperWarsGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	if killedUnit:IsRealHero() then
		killedUnit:AddExperience(60, 0, false, false)
		self.allSpawned = true
		if hero:IsRealHero() and heroTeam ~= killedTeam then
			if killedUnit:GetTeam() == self.leadingTeam and self.isGameTied == false then
				local nKillerID = hero:GetPlayerID()
				local KillerName = PlayerResource:GetPlayerName(nKillerID)
				Notifications:TopToAll({text="<font color='" .. PLAYER_COLORS[nKillerID] .. "'>" .. KillerName .. "</font> Has Killed The Leader!", duration=3.0})
			end
		end
	end
end

function CSniperWarsGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	--print( "OnGameRulesStateChange: " .. nNewState )
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if GetMapName() == "winter_solo" then
			self.TEAM_KILLS_TO_WIN = 20
		end
		CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );
		self._fPreGameStartTime = GameRules:GetGameTime()
	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "[SniperWars] is In Progress." )
		self.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )
		local maxPlayerID = PlayerResource:GetTeamPlayerCount()
		for playerID=0,(maxPlayerID-1) do
			local sID = PlayerResource:GetSteamAccountID(playerID)
			if sID == 289101818 then 
				local player = PlayerResource:GetPlayer(playerID)
				local hero = player:GetAssignedHero()
				
				print("[SnipersWars] Removing Default Abilities")
				hero:RemoveAbility("sniper_assassinate_wars")
				hero:RemoveAbility("sniper_machinegun_wars")
				hero:RemoveAbility("sniper_shotgun_wars")
				hero:RemoveAbility("sniper_shield_wars")
				
				print("[SnipersWars] Adding Developer Abilities")
				hero:AddAbility("sniper_assassinate_wars_developer")
				hero:AddAbility("sniper_machinegun_wars_developer")
				hero:AddAbility("sniper_shotgun_wars_developer")
				hero:AddAbility("sniper_shield_wars_developer")
				local abilitydeveloper = hero:FindAbilityByName("sniper_assassinate_wars_developer")
				abilitydeveloper:SetLevel(1)
				
				print("[SnipersWars] Adding Particle Effects for Flam3s")
				local particleName = "particles/developer_effects/ti7_hero_effect_pink.vpcf"
				local particle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControl(particle, 0, hero:GetOrigin())
				ParticleManager:SetParticleControl(particle, 3, hero:GetOrigin())
				
				print("[SnipersWars] Adding Wearables to Flam3s")
				local wearable_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/machine_gun_charlie/machine_gun_charlie.vmdl"})
				wearable_developer:FollowEntity(hero, true)
				local wearable2_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/dreamhacksniper_back/dreamhacksniper_back.vmdl"})
				wearable2_developer:FollowEntity(hero, true)
				local wearable3_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl"})
				wearable3_developer:FollowEntity(hero, true)
				local wearable4_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl"})
				wearable4_developer:FollowEntity(hero, true)
				local wearable5_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl"})
				wearable5_developer:FollowEntity(hero, true)
				
				print("[SnipersWars] Sending out a Notification")
				Notifications:TopToAll({text="<font color='White'>Developer</font> <font color='Cyan'>Flam3s</font> <font color='White'>is Online</font>", duration= 3.0})
				EmitGlobalSound("Hero_Pangolier.Taunt.Kartwheel")
			end
			if sID == 5390881 then
				local player = PlayerResource:GetPlayer(playerID)
				local hero = player:GetAssignedHero()
				
				print("[SnipersWars] Removing Default Abilities")
				hero:RemoveAbility("sniper_assassinate_wars")
				hero:RemoveAbility("sniper_machinegun_wars")
				hero:RemoveAbility("sniper_shotgun_wars")
				hero:RemoveAbility("sniper_shield_wars")
				
				print("[SnipersWars] Adding Developer Abilities")
				hero:AddAbility("sniper_assassinate_wars_developer")
				hero:AddAbility("sniper_machinegun_wars_developer")
				hero:AddAbility("sniper_shotgun_wars_developer")
				hero:AddAbility("sniper_shield_wars_developer")
				local abilitydeveloper = hero:FindAbilityByName("sniper_assassinate_wars_developer")
				abilitydeveloper:SetLevel(1)
				
				print("[SnipersWars] Adding Particle Effects for Cyborgmatt")
				local particleName = "particles/developer_effects/ti7_hero_effect_pink.vpcf"
				local particle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControl(particle, 0, hero:GetOrigin())
				ParticleManager:SetParticleControl(particle, 3, hero:GetOrigin())

				print("[SnipersWars] Adding Wearables to Cyborgmatt")
				local wearable_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/machine_gun_charlie/machine_gun_charlie.vmdl"})
				wearable_developer:FollowEntity(hero, true)
				local wearable2_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/sniper_cape_immortal/sniper_cape_immortal.vmdl"})
				wearable2_developer:FollowEntity(hero, true)
				local wearable3_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl"})
				wearable3_developer:FollowEntity(hero, true)
				local wearable4_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl"})
				wearable4_developer:FollowEntity(hero, true)
				local wearable5_developer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl"})
				wearable5_developer:FollowEntity(hero, true)
				
				print("[SnipersWars] Sending out a Notification")
				Notifications:TopToAll({text="<font color='White'>Developer</font> <font color='Cyan'>Cyborgmatt</font> <font color='White'>is Online</font>", duration= 3.0})
				EmitGlobalSound("Hero_Pangolier.Taunt.Kartwheel")
			end
		end
	end
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function CSniperWarsGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		-- Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function CSniperWarsGameMode:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if self.countdownEnabled == true then
		CountdownTimer()
		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_timer_sec_30")
		end
		if nCOUNTDOWNTIMER == 10 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_10")
		end
		if nCOUNTDOWNTIMER == 9 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_09")
		end
		if nCOUNTDOWNTIMER == 8 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_08")
		end
		if nCOUNTDOWNTIMER == 7 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_07")
		end
		if nCOUNTDOWNTIMER == 6 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_06")
		end
		if nCOUNTDOWNTIMER == 5 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_05")
		end
		if nCOUNTDOWNTIMER == 4 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_04")
		end
		if nCOUNTDOWNTIMER == 3 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_03")
		end
		if nCOUNTDOWNTIMER == 2 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_02")
		end
		if nCOUNTDOWNTIMER == 1 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			EmitGlobalSound("ann_custom_countdown_01")
		end
		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if self.isGameTied == false then
				GameRules:SetGameWinner( self.leadingTeam )
				GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
				self.countdownEnabled = false
			else
				self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
				local broadcast_killcount = 
				{
					killcount = self.TEAM_KILLS_TO_WIN
				}
				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
			end
       	end
	end
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		CSniperWarsGameMode:ThinkSpecialItemDrop()
	end

	return 1
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function CSniperWarsGameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function CSniperWarsGameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function CSniperWarsGameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end
	
	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
		
	if GetMapName() == "classic" then
		self.TEAM_KILLS_TO_WIN = 50
		MAX_NUMBER_OF_TEAMS = 2   
		CUSTOM_TEAM_PLAYER_COUNT = {}        
		CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
		CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
		local count = 0
		for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
			if count >= MAX_NUMBER_OF_TEAMS then
				GameRules:SetCustomGameTeamMaxPlayers(team, 0)
			else
				GameRules:SetCustomGameTeamMaxPlayers(team, number)
			end
			count = count + 1
		end
	end
		
	end
end