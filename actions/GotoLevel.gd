class_name GotoLevel
extends Action


static func attempt(actor:GameEntity, params:Dictionary):
	var world_view = params.get('world_view')
	if world_view == null or !actor.is_player:
		return
	for entity in actor.get_tree().get_nodes_in_group(CharacterBuilder.ENEMIES_GROUP):
		entity.queue_free()
	var level = actor.mind.level + 1
	actor.mind.level = level
	var level_type = _get_level_type(level)
	start_acting(actor)
	var map = _build_map(level, level_type)
	world_view.set_map(map)
	MoveAction.teleport(actor, map.start, map)
	TurnManager.clear()
	TurnManager.add(actor)
	_populate(world_view, map, level, level_type)
	done_acting(actor)


static func _build_encounter(map, level, level_type) -> Array:
	var res = []
	if level == 1:
		for i in range(1 + randi() % 2):
			res.append(CharacterBuilder.new().from_template(GameEntity.Type.SCIENTIST).build())
	elif level < 4:
		for i in range(1 + randi() % 2):
			res.append(CharacterBuilder.new().from_template(
				GameEntity.Type.MILITARY if randi() % 3 == 0 else GameEntity.Type.SCIENTIST
				).build())
	else:
		for i in range(1 + randi() % 2):
			res.append(CharacterBuilder.new().from_template(GameEntity.Type.MILITARY).build())
	return res


static func _build_map(level, level_type:int) -> LevelMap:
	var builder = LevelBuilder.new().with_type(level_type)
	return builder.build()


static func _get_empty_position(map:LevelMap, room:Rect2) -> Vector2:
	var res = Vector2(
		room.position.x + 1 + randi() % int(room.size.x),
		room.position.y + 1 + randi() % int(room.size.y))
	while map.get_tile(res) != LevelMap.TileTypes.FLOOR:
		res = Vector2(
			room.position.x + 1 + randi() % int(room.size.x),
			room.position.y + 1 + randi() % int(room.size.y))
	return res


static func _get_level_type(level:int) -> int:
	match level:
		1, 2, 3: return LevelBuilder.LevelTypes.LAB
		4: return LevelBuilder.LevelTypes.EXCAVATION
		_: return LevelBuilder.LevelTypes.CAVE


static func _populate(world_view, map:LevelMap, level:int, level_type:int) -> void:
	for i in range(len(map.rooms)):
		if i == 0:
			continue
		var room = map.rooms[i]
		for entity in _build_encounter(map, level, level_type):
			MoveAction.teleport(entity, _get_empty_position(map, room), map)
			TurnManager.add(entity)
			world_view.add_child(entity)
