function Jump(event)
	local hero = event.caster

	hero:SetPhysicsVelocity(Vector(0,0,900))
	hero:PreventDI(true)
	hero.onground = true
	hero.forwardSpeed = event.Speed
	hero:StartGesture(ACT_DOTA_TELEPORT)
	hero:FollowNavMesh(false)
	hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end