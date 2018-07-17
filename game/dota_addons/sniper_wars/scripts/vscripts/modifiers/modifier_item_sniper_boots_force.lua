modifier_item_sniper_boots_force = class({})

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force:OnCreated( kv )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end
