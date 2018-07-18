--[[ itemspawning.lua ]]

function CSniperWarsGameMode:SpecialItemAdd( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	local hero = owner:GetClassname()
	local ownerTeam = owner:GetTeamNumber()
	local playerID = owner:GetPlayerOwnerID()
	local name = PlayerResource:GetPlayerName(playerID)
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )
	local n = TableCount( sortedTeams )
	local leader = sortedTeams[1].teamID
	local lastPlace = sortedTeams[n].teamID

	local tableindex = 0
	local tier1 = 
	{
		"item_sniper_grenade",
		"item_sniper_potato",
		"item_sniper_barricade",
		"item_creed_of_omniscience",
		"item_bear_cloak",
		"item_pelt_of_the_old_wolf",
		"item_longclaws_amulet",
		"item_bogduggs_lucky_femur",
		"item_bogduggs_baldric",
		"item_craggy_coat",
		"item_ambient_sorcery",
		"item_guardian_shell"
	}
	local tier2 = 
	{
		"item_sniper_grenade",
		"item_sniper_potato",
		"item_sniper_barricade",
		"item_creed_of_omniscience",
		"item_bear_cloak",
		"item_pelt_of_the_old_wolf",
		"item_longclaws_amulet",
		"item_bogduggs_lucky_femur",
		"item_bogduggs_baldric",
		"item_craggy_coat",
		"item_ambient_sorcery",
		"item_guardian_shell"
	}
	local tier3 = 
	{
		"item_sniper_grenade",
		"item_sniper_potato",
		"item_sniper_barricade",
		"item_creed_of_omniscience",
		"item_bear_cloak",
		"item_pelt_of_the_old_wolf",
		"item_longclaws_amulet",
		"item_bogduggs_lucky_femur",
		"item_bogduggs_baldric",
		"item_craggy_coat",
		"item_ambient_sorcery",
		"item_guardian_shell",
		"item_gravel_foot",
		"item_precious_egg"
	}

	local t1 = PickRandomShuffle( tier1, self.tier1ItemBucket )
	local t2 = PickRandomShuffle( tier2, self.tier2ItemBucket )
	local t3 = PickRandomShuffle( tier3, self.tier3ItemBucket )

	local spawnedItem = ""

	-- pick the item we're giving them
	if GetTeamHeroKills( leader ) <= 5 then
		spawnedItem = t1
	elseif GetTeamHeroKills( leader ) <= 10 then
		spawnedItem = t2
	elseif GetTeamHeroKills( leader ) <= 15 then
		spawnedItem = t3
	end

	-- add the item to the inventory and broadcast
	owner:AddItemByName( spawnedItem )
	EmitGlobalSound("powerup_04")
	local overthrow_item_drop =
	{
		hero_id = hero,
		player_name = name,
		dropped_item = spawnedItem
	}
	CustomGameEventManager:Send_ServerToAllClients( "overthrow_item_drop", overthrow_item_drop )
end

function CSniperWarsGameMode:ThinkSpecialItemDrop()
	-- Stop spawning items after 15
	if self.nNextSpawnItemNumber >= 15 then
		return
	end
	-- Don't spawn if the game is about to end
	if nCOUNTDOWNTIMER < 20 then
		return
	end
	local t = GameRules:GetDOTATime( false, false )
	local tSpawn = ( self.spawnTime * self.nNextSpawnItemNumber )
	local tWarn = tSpawn - 15
	
	if not self.hasWarnedSpawn and t >= tWarn then
		-- warn the item is about to spawn
		self:WarnItem()
		self.hasWarnedSpawn = true
	elseif t >= tSpawn then
		-- spawn the item
		self:SpawnItem()
		self.nNextSpawnItemNumber = self.nNextSpawnItemNumber + 1
		self.hasWarnedSpawn = false
	end
end

function CSniperWarsGameMode:PlanNextSpawn()
	local spawnPath =
	{
		"item_spawn_1"
	}
	local missingSpawnPoint =
	{
		origin = "0 0 384",
		targetname = "item_spawn_missing"
	}

	local r = RandomInt( 1, #spawnPath )
	local path_track = spawnPath[ r ]
	local spawnPoint = Vector( 0, 0, 700 )
	local spawnLocation = Entities:FindByName( nil, path_track )

	if spawnLocation == nil then
		spawnLocation = SpawnEntityFromTableSynchronous( "path_track", missingSpawnPoint )
		spawnLocation:SetAbsOrigin(spawnPoint)
	end
	
	self.itemSpawnLocation = spawnLocation
	self.itemSpawnIndex = r
end

function CSniperWarsGameMode:WarnItem()
	-- find the spawn point
	self:PlanNextSpawn()

	local spawnLocation = self.itemSpawnLocation:GetAbsOrigin();

	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_will_spawn", { spawn_location = spawnLocation } )
	EmitGlobalSound( "powerup_03" )
	
	-- fire the destination particles
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Start", "0", 0, self, self )
end

function CSniperWarsGameMode:SpawnItem()
	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_has_spawned", {} )
	EmitGlobalSound( "powerup_05" )

	-- spawn the item
	local startLocation = Vector( 0, 4000, 700 )
	local treasureCourier = CreateUnitByName( "npc_dota_treasure_courier" , startLocation, true, nil, nil, DOTA_TEAM_NEUTRALS )
	local treasureAbility = treasureCourier:FindAbilityByName( "dota_ability_treasure_courier" )
	treasureAbility:SetLevel( 1 )
    --print ("Spawning Treasure")
    targetSpawnLocation = self.itemSpawnLocation
    treasureCourier:SetInitialGoalEntity(targetSpawnLocation)
    local particleTreasure = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN_FOLLOW, treasureCourier )
	ParticleManager:SetParticleControlEnt( particleTreasure, PATTACH_ABSORIGIN_FOLLOW, treasureCourier, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", treasureCourier:GetAbsOrigin(), true )
	treasureCourier:Attribute_SetIntValue( "particleID", particleTreasure )
end

function CSniperWarsGameMode:ForceSpawnItem()
	self:WarnItem()
	self:SpawnItem()
end
function CSniperWarsGameMode:test()
	self:TreasureDrop()
end

function CSniperWarsGameMode:KnockBackFromTreasure( center, radius, knockback_duration, knockback_distance, knockback_height )
	local targetType = bit.bor( DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_HERO )
	local knockBackUnits = FindUnitsInRadius( DOTA_TEAM_NOTEAM, center, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, targetType, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
 
	local modifierKnockback =
	{
		center_x = center.x,
		center_y = center.y,
		center_z = center.z,
		duration = knockback_duration,
		knockback_duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_height,
	}

	for _,unit in pairs(knockBackUnits) do
--		print( "knock back unit: " .. unit:GetName() )
		unit:AddNewModifier( unit, nil, "modifier_knockback", modifierKnockback );
	end
end


function CSniperWarsGameMode:TreasureDrop( treasureCourier )
	--Create the death effect for the courier
	local spawnPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	spawnPoint.z = 400
	local fxPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	fxPoint.z = 400
	local deathEffects = ParticleManager:CreateParticle( "particles/treasure_courier_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( deathEffects, 0, fxPoint )
	ParticleManager:SetParticleControlOrientation( deathEffects, 0, treasureCourier:GetForwardVector(), treasureCourier:GetRightVector(), treasureCourier:GetUpVector() )
	EmitGlobalSound( "lockjaw_Courier.Impact" )
	EmitGlobalSound( "lockjaw_Courier.gold_big" )

	--Spawn the treasure chest at the selected item spawn location
	local newItem = CreateItem( "item_treasure_chest", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	drop:SetForwardVector( treasureCourier:GetRightVector() ) -- oriented differently
	newItem:LaunchLootInitialHeight( false, 0, 50, 0.25, spawnPoint )

	--Stop the particle effect
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "stopplayendcap", "0", 0, self, self )

	--Knock people back from the treasure
	self:KnockBackFromTreasure( spawnPoint, 375, 0.25, 400, 100 )
		
	--Destroy the courier
	UTIL_Remove( treasureCourier )
end
