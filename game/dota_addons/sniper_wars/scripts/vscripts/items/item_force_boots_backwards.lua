if item_sniper_boots_force_backwards == nil then
    item_sniper_boots_force_backwards = class ({})
end

function item_sniper_boots_force_backwards:OnSpellStart()
    local hTarget = self:GetCaster()
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { push_length = -800 } )
    EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
end