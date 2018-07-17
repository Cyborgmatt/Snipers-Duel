item_sniper_boots_force_backwards = class ({})
LinkLuaModifier( "modifier_item_sniper_boots_force_backwards", "modifiers/modifier_item_sniper_boots_force_backwards", LUA_MODIFIER_MOTION_NONE )

function item_sniper_boots_force_backwards:GetIntrinsicModifierName()
	return "modifier_item_sniper_boots_force_backwards"
end

function item_sniper_boots_force_backwards:OnSpellStart()
    local hTarget = self:GetCaster()
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { push_length = -800 } )
    EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
end