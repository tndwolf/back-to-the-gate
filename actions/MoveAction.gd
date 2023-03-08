class_name MoveAction
extends Action


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
#		print('Move: no can act ' + actor.name)
		return
#	print('Move: ' + actor.name)
	var map = params.get('map') as LevelMap
	var delta = params.get('delta') as Vector2
	if map == null or delta == null:
		return
	start_acting(actor)
#	print('Try move by %s' % delta)
	if try_move(actor, delta, map) == false:
		if try_move(actor, Vector2(delta.x, 0), map) == false:
			if !try_move(actor, Vector2(0, delta.y), map):
				free_actor(actor)
	if !actor.is_player:
		done_acting(actor)


static func _is_to_animate(actor:GameEntity, map:LevelMap) -> bool:
	return true
	return actor.is_player


static func step(actor:GameEntity, delta:Vector2, map:LevelMap) -> void:
	var end_position = actor.grid_position + delta
	var start_position = actor.position
	actor.rotation = actor.grid_position.angle_to_point(end_position) + PI
	map.remove_entity(actor, actor.grid_position)
	actor.grid_position = end_position
	map.place_entity(actor, actor.grid_position)
	var final_position = end_position * LevelBuilder.CELLS_SIZE + 0.5 * LevelBuilder.CELLS_SIZE
	if _is_to_animate(actor, map):
		actor.move_tween.interpolate_property(actor, 'position', start_position, final_position, 0.3)
		actor.move_tween.start()
		yield(actor.move_tween, "tween_all_completed")
	else:
		actor.position = final_position
	done_acting(actor)


static func teleport(actor:GameEntity, coords:Vector2, map:LevelMap) -> void:
	actor.position = coords * LevelBuilder.CELLS_SIZE + 0.5 * LevelBuilder.CELLS_SIZE
	map.remove_entity(actor, actor.grid_position)
	actor.grid_position = coords
	map.place_entity(actor, actor.grid_position)


static func open_door(actor:GameEntity, end_position:Vector2, map:LevelMap):
	var up_tile = map.get_tile(end_position + Vector2.DOWN)
	map.set_tile(LevelMap.TileTypes.OPEN_DOOR, end_position)
	var new_door = actor.get_parent().convert_tile(LevelMap.TileTypes.OPEN_DOOR, up_tile)
	actor.get_parent().world_tiles.set_cellv(end_position, new_door)
	yield(actor.get_tree().create_timer(0.2), "timeout")
	done_acting(actor)


static func try_move(actor:GameEntity, delta:Vector2, map:LevelMap) -> bool:
	if delta == Vector2.ZERO:
		done_acting(actor)
		return true
	var end_position = actor.grid_position + delta
	var end_tile = map.get_tile(end_position)
	if end_tile == LevelMap.TileTypes.DOOR:
		open_door(actor, end_position, map)
		return true
	if end_tile in [LevelMap.TileTypes.WALL, LevelMap.TileTypes.INVALID]:
		return false
	step(actor, delta, map)
	return true
