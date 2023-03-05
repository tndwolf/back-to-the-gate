class_name FeedAction
extends Action


const FeedFx = preload("res://fx/FeedFx.tscn")


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
		return
	var map = params.get('map')
	if map == null:
		return
	start_acting(actor)
	var targets = map.entities_at(actor.grid_position)
	for t in targets:
		if t is GameEntity and t.status == GameEntity.Status.DEAD:
			map.remove_entity(t, t.grid_position)
			_drain(actor, t)
			return
	free_actor(actor)


static func _drain(actor:GameEntity, target:GameEntity):
	target.status = GameEntity.Status.DRAINED
	actor.blood += 1
	actor.health = 10
	var fx = FeedFx.instance()
	fx.one_shot = true
	actor.add_child(fx)
	yield(actor.get_tree().create_timer(3), "timeout")
	actor.remove_child(fx)
	done_acting(actor)
