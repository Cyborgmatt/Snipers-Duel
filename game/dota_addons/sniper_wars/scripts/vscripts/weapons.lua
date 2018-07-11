-- WEAPONS
bDEBUGDRAW = false

function Rifle_Shoot( args )
        local caster = args.caster

        local projectile = {
          EffectName = "particles/sniper_bullet.vpcf",
          vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
          fDistance = args.FixedDistance,
          fStartRadius = args.StartRadius,
          fEndRadius = args.EndRadius,
          Source = caster,
          vVelocity = caster:GetForwardVector() * args.MoveSpeed,
          UnitBehavior = PROJECTILES_DESTROY,
          bMultipleHits = false,
          bIgnoreSource = true,
          TreeBehavior = PROJECTILES_DESTROY,
          bCutTrees = true,
          WallBehavior = PROJECTILES_NOTHING,
          GroundBehavior = PROJECTILES_NOTHING,
          fGroundOffset = 80,
          nChangeMax = 1,
          bRecreateOnChange = true,
          bZCheck = false,
          bGroundLock = true,
          draw = bDEBUGDRAW,
          bProvidesVision = true,
          iVisionRadius = args.VisionRadius,
          UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() or unit:GetUnitName() == "npc_sniper_barricade" end,
          OnUnitHit = function(self, unit)
                local totalDamage = args.Damage
                local target = unit
                local damageTable = {
                                victim = target,
                                attacker = caster,
                                damage = totalDamage,
                                damage_type = DAMAGE_TYPE_PHYSICAL,
                        }
                ApplyDamage(damageTable)

                if unit:GetUnitName() == "npc_dota_hero_sniper" then
                        ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                        ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                elseif unit:GetUnitName() == "npc_sniper_barricade" then
                        ParticleManager:CreateParticle("particles/newplayer_fx/npx_wood_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                        unit:EmitSound("Item_Sniper.WoodBreak")
                end
          end
        }

        Projectiles:CreateProjectile(projectile)
end

function Machinegun_Shoot( args )
        local caster = args.caster

        local projectile = {
          EffectName = "particles/sniper_bullet_mg.vpcf",
          vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
          fDistance = args.FixedDistance,
          fStartRadius = args.StartRadius,
          fEndRadius = args.EndRadius,
          Source = caster,
          vVelocity = caster:GetForwardVector() * args.MoveSpeed,
          UnitBehavior = PROJECTILES_DESTROY,
          bMultipleHits = false,
          bIgnoreSource = true,
          TreeBehavior = PROJECTILES_DESTROY,
          bCutTrees = true,
          WallBehavior = PROJECTILES_NOTHING,
          GroundBehavior = PROJECTILES_NOTHING,
          fGroundOffset = 80,
          nChangeMax = 1,
          bRecreateOnChange = true,
          bZCheck = false,
          bGroundLock = true,
          draw = bDEBUGDRAW,
          bProvidesVision = true,
          iVisionRadius = args.VisionRadius,
          UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() or unit:GetUnitName() == "npc_sniper_barricade" end,
          OnUnitHit = function(self, unit)
                local totalDamage = args.Damage
                local target = unit
                local damageTable = {
                                victim = target,
                                attacker = caster,
                                damage = totalDamage,
                                damage_type = DAMAGE_TYPE_PHYSICAL,
                        }
                ApplyDamage(damageTable)

                if unit:GetUnitName() == "npc_dota_hero_sniper" then
                        ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                elseif unit:GetUnitName() == "npc_sniper_barricade" then
                        ParticleManager:CreateParticle("particles/newplayer_fx/npx_wood_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                        unit:EmitSound("Item_Sniper.WoodBreak")
                end
          end
        }

        local random = math.random(-30,30)

        projectile.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,random,0), caster:GetForwardVector()) * args.MoveSpeed
        Projectiles:CreateProjectile(projectile)
end

function Shotgun_Shoot( args )
        local caster = args.caster

        local projectile = {
          EffectName = "particles/sniper_bullet_mg.vpcf",
          vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
          fDistance = args.FixedDistance,
          fStartRadius = 30,
          fEndRadius = 40,
          Source = caster,
          fExpireTime = 8.0,
          vVelocity = caster:GetForwardVector() * args.MoveSpeed, -- RandomVector(1000),
          UnitBehavior = PROJECTILES_DESTROY,
          bMultipleHits = false,
          bIgnoreSource = true,
          TreeBehavior = PROJECTILES_DESTROY,
          bCutTrees = true,
          WallBehavior = PROJECTILES_NOTHING,
          GroundBehavior = PROJECTILES_NOTHING,
          fGroundOffset = 80,
          nChangeMax = 1,
          bRecreateOnChange = true,
          bZCheck = false,
          bGroundLock = true,
          draw = bDEBUGDRAW,
          bProvidesVision = true,
          iVisionRadius = args.VisionRadius,
          UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() or unit:GetUnitName() == "npc_sniper_barricade" end,
          OnUnitHit = function(self, unit)
                local totalDamage = args.Damage
                local target = unit
                local damageTable = {
                                victim = target,
                                attacker = caster,
                                damage = totalDamage,
                                damage_type = DAMAGE_TYPE_PHYSICAL,
                        }
                ApplyDamage(damageTable)

                if unit:GetUnitName() == "npc_dota_hero_sniper" then
                        ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                elseif unit:GetUnitName() == "npc_sniper_barricade" then
                        ParticleManager:CreateParticle("particles/newplayer_fx/npx_wood_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                        unit:EmitSound("Item_Sniper.WoodBreak")            
                end
          end
        }

        for i=-25,25,10 do
                local shotgun = shallowcopy(projectile)
                shotgun.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * args.MoveSpeed
                Projectiles:CreateProjectile(shotgun)
        end
end

-- ITEMS

function Grappling_Hook( keys )
    local casterUnit = keys.caster
    local targetPoint = keys.target_points[1]
    casterUnit:AddAbility("sniper_grappling_wars")
    local abil = casterUnit:FindAbilityByName("sniper_grappling_wars")
    abil:SetLevel(1)

        Timers:CreateTimer(2.5, function()
      casterUnit:RemoveAbility("sniper_grappling_wars")
    end)

    if targetPoint ~= null then
        local order =
        {
            UnitIndex = casterUnit:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
            Position = targetPoint,
            AbilityIndex = abil:entindex()
        }
        ExecuteOrderFromTable(order)
    end
end

function Create_Barrier( keys )
    local point = keys.target_points[1]
    local caster = keys.caster
    CreateUnitByName( "npc_sniper_barricade", point, false, caster, caster, caster:GetTeam() )
end

function Force_Boots( keys )
    local caster = keys.caster
    caster:AddNewModifier(caster, nil, 'modifier_item_forcestaff_active', {push_length = 800})
    EmitSoundOn('DOTA_Item.ForceStaff.Activate', caster)
end

function Throw_Grenade( args )
        local caster = args.caster
        local target = args.target
        local target_location = target:GetAbsOrigin()

        local projectile = {
          EffectName = "particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf",
          vSpawnOrigin = caster:GetAbsOrigin(),
          --vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
          fDistance = args.FixedDistance,
          fStartRadius = args.StartRadius,
          fEndRadius = args.EndRadius,
          Source = caster,
          vVelocity = caster:GetForwardVector() * args.MoveSpeed,
          UnitBehavior = PROJECTILES_NOTHING,
          bMultipleHits = false,
          bIgnoreSource = true,
          TreeBehavior = PROJECTILES_NOTHING,
          bCutTrees = true,
          WallBehavior = PROJECTILES_NOTHING,
          GroundBehavior = PROJECTILES_NOTHING,
          fGroundOffset = 80,
          nChangeMax = 1,
          bRecreateOnChange = true,
          bZCheck = false,
          bGroundLock = false,
          draw = bDEBUGDRAW,
          bProvidesVision = true,
          iVisionRadius = args.VisionRadius,
          UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() or unit:GetUnitName() == "npc_sniper_barricade" end,
          OnUnitHit = function(self, unit)
          end,
          OnFinish = function(self, pos)
                local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf", PATTACH_ABSORIGIN, target)
                ParticleManager:SetParticleControl(particle, 0, pos)
                EmitSoundOn('Item_Sniper.GrenadeFuse', target)
                -- Timer to kill particle
                Timers:CreateTimer(args.Duration, function()
                        StopSoundOn('Item_Sniper.GrenadeFuse', target)
                        ParticleManager:DestroyParticle(particle, true)
                        local explosion = ParticleManager:CreateParticle("particles/sniper_grenade_explosion.vpcf", PATTACH_ABSORIGIN, target)
                        ParticleManager:SetParticleControl(explosion, 0, pos)
                        EmitSoundOn('Item_Sniper.GrenadeExplosion', target)
                        GridNav:DestroyTreesAroundPoint( pos, args.ExplosionRadius, true )
                        -- Find and damage units in radius
                        local found_targets = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, args.ExplosionRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                        -- Initialize the damage table
                        local totalDamage = args.Damage
                        local damageTable = {
                                        attacker = caster,
                                        damage = totalDamage,
                                        damage_type = DAMAGE_TYPE_PHYSICAL,
                                }

                        -- Deal damage to each found hero
                        for _,hero in pairs(found_targets) do
                                damageTable.victim = hero
                                ApplyDamage(damageTable)
                        end
                    end)
          end
        }

        Projectiles:CreateProjectile(projectile)
end