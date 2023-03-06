class_name GotoLevel
extends Action


static func attempt(actor:GameEntity, params:Dictionary):
#	if !can_act(actor):
#		return
	var world_view = params.get('world_view')
	if world_view == null or !actor.is_player:
		return
	start_acting(actor)
	var map = LevelBuilder.new().set_type(LevelBuilder.LevelTypes.LAB).build()
	world_view.set_map(map)
	MoveAction.teleport(actor, map.start, map)
	TurnManager.clear()
	TurnManager.add(actor)
	done_acting(actor)
