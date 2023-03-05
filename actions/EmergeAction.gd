class_name EmergeAction
extends Action


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
		return
	var map = params.get('map') as LevelMap
	if map == null:
		return
	start_acting(actor)
	actor.is_hiding = false
	actor.view_box.disabled = false
	actor.modulate.a = 1.0
	done_acting(actor)
