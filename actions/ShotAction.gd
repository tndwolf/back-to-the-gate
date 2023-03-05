class_name ShotAction
extends Action


const BleedFx = preload("res://fx/BleedFx.tscn")


static func _add_bleed_fx(target:GameEntity):
	var fx = BleedFx.instance()
	fx.one_shot = true
	target.add_child(fx)
	yield(target.get_tree().create_timer(0.4), "timeout")
	target.remove_child(fx)


static func _attack(actor:GameEntity, target:GameEntity):
	actor.rotation = actor.position.angle_to_point(target.position) + PI
	_add_bleed_fx(target)
	yield(actor.get_tree().create_timer(0.5), "timeout")
	target.health -= _calc_damage(actor, target)
	if target.health <= 0:
		target.status = GameEntity.Status.DEAD
	done_acting(actor)


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
		return
	var map = params.get('map') as LevelMap
	var target = params.get('target') as GameEntity
	if map == null or target == null:
		return
	start_acting(actor)
	_attack(actor, target)


static func _calc_damage(actor:GameEntity, target:GameEntity) -> int :
	return 1
