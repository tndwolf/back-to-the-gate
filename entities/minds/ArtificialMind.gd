extends Mind


func turn(world):
#	print(owner.name + ' turn')
	match owner.unit_type:
		GameEntity.Type.MILITARY: _military_turn(world)
		GameEntity.Type.SCIENTIST: _scientist_turn(world)
		_: owner.emit_signal("turn_completed", owner, 100)


func _military_turn(world):
	if owner.is_engaged and owner.target:
		var distance = owner.grid_position.distance_to(owner.target.grid_position)
		if distance < 1.8:
			MeleeAction.attempt(owner, {'target': owner.target, 'map': world})
			owner.emit_signal("turn_completed", owner, 100)
		elif distance < 6:
			var dir = owner.grid_position.direction_to(owner.target.grid_position)
			ShotAction.attempt(owner, {'target': owner.target, 'map': world})
			owner.emit_signal("turn_completed", owner, 100)
		else:
			var dir = owner.grid_position.direction_to(owner.target.grid_position)
			MoveAction.attempt(owner, {'delta': dir.round(), 'map': world})
		return
	elif owner.is_engaged:
		var dir = owner.grid_position.direction_to(owner.target.grid_position)
		MoveAction.attempt(owner, {'delta': dir.round(), 'map': world})
	else:
		# TODO patrol
		owner.emit_signal("turn_completed", owner, 100)


func _scientist_turn(world):
	owner.status = GameEntity.Status.ALIVE
	if owner.is_engaged and owner.target:
		var distance = owner.grid_position.distance_to(owner.target.grid_position)
		if distance < 1.8:
			MeleeAction.attempt(owner, {'target': owner.target, 'map': world})
			owner.emit_signal("turn_completed", owner, 100)
		else:
			var dir = owner.grid_position.direction_to(owner.target.grid_position)
			MoveAction.attempt(owner, {'delta': -dir.round(), 'map': world})
	elif randi() % 4 == 0:
		MoveAction.attempt(owner, {'delta': Vector2(randi() % 3 - 1, randi() % 3 - 1), 'map': world})
	else:
		owner.emit_signal("turn_completed", owner, 100)
