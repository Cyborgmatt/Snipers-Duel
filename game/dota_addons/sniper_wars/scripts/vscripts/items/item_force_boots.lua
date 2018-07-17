item_sniper_boots_force = class ({})
LinkLuaModifier( "modifier_item_sniper_boots_force", "modifiers/modifier_item_sniper_boots_force", LUA_MODIFIER_MOTION_NONE )

function item_sniper_boots_force:GetIntrinsicModifierName()
	return "modifier_item_sniper_boots_force"
end

function item_sniper_boots_force:OnSpellStart()
    local hTarget = self:GetCaster()
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { push_length = 800 } )
    EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
end