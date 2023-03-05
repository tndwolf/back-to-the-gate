class_name DiveAction
extends Action


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
		return
	var map = params.get('map') as LevelMap
	if map == null:
		return
	start_acting(actor)
	actor.is_hiding = true
	actor.view_box.disabled = true
	actor.modulate.a = 0.5
	done_acting(actor)
