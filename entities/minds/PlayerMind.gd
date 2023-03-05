class_name PlayerMind
extends Mind


func turn(world:LevelMap):
	if Input.is_action_just_pressed("ui_select"):
		FeedAction.attempt(owner, {'map': world})
		return
	if Input.is_action_just_pressed("ui_accept"):
		if owner.is_hiding:
			EmergeAction.attempt(owner, {'map': world})
		else:
			DiveAction.attempt(owner, {'map': world})
		return
	var dx = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var dy = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if dx != 0 or dy != 0:
		var delta = Vector2(dx, dy)
		var targets = world.entities_at(owner.grid_position + delta)
		if !targets.empty():
			for target in targets:
				if target.status in [GameEntity.Status.DEAD, GameEntity.Status.DRAINED]:
					continue
				if target.is_engaged:
					MeleeAction.attempt(owner, {'target': target, 'map': world})
					return
				else:
					PounceAction.attempt(owner, {'target': target, 'map': world})
					return
		MoveAction.attempt(owner, {'delta': delta, 'map': world})
