modifier_item_sniper_boots_force_backwards = class({})

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force_backwards:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force_backwards:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force_backwards:OnCreated( kv )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force_backwards:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_sniper_boots_force_backwards:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end