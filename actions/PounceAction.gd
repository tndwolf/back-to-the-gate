class_name PounceAction
extends Action


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
		return
	var map = params.get('map') as LevelMap
	var target = params.get('target') as GameEntity
	if map == null or target == null:
		return
	start_acting(actor)
	step(actor, target.grid_position, map)
	target.status = GameEntity.Status.DEAD
	done_acting(actor)


static func step(actor:GameEntity, end_position:Vector2, map:LevelMap) -> void:
#	var end_position = actor.grid_position + delta
#	actor.rotation = actor.grid_position.angle_to_point(end_position) + PI
#	actor.position = end_position * LevelBuilder.CELLS_SIZE + 0.5 * LevelBuilder.CELLS_SIZE
#	map.remove_entity(actor, actor.grid_position)
#	actor.grid_position = end_position
#	map.place_entity(actor, actor.grid_position)
	var start_position = actor.position
	actor.rotation = actor.grid_position.angle_to_point(end_position) + PI
	map.remove_entity(actor, actor.grid_position)
	actor.grid_position = end_position
	map.place_entity(actor, actor.grid_position)
	var final_position = end_position * LevelBuilder.CELLS_SIZE + 0.5 * LevelBuilder.CELLS_SIZE
	actor.move_tween.interpolate_property(actor, 'position', start_position, final_position, 0.3)
	actor.move_tween.start()
	yield(actor.move_tween, "tween_all_completed")
