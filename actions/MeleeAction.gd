class_name MeleeAction
extends Action


const BleedFx = preload("res://fx/BleedFx.tscn")


static func _add_bleed_fx(target:GameEntity):
	var fx = BleedFx.instance()
	fx.one_shot = true
	target.add_child(fx)
	yield(target.get_tree().create_timer(0.4), "timeout")
	target.remove_child(fx)


static func _attack(actor:GameEntity, target:GameEntity):
#	actor.rotation = actor.position.angle_to_point(target.position) + PI
	actor.set_look_direction(actor.position.angle_to_point(target.position))
	var from_position = actor.position
	var to_position = lerp(actor.position, target.position, 0.5)
	var ani = actor.model.get_node('AnimationPlayer')
	if ani:
		ani.play('Attack')
	actor.move_tween.interpolate_property(actor, 'position', from_position, to_position, 0.1)
	actor.move_tween.interpolate_property(actor, 'position', to_position, from_position, 0.1, 0, 0, 0.1)
	actor.move_tween.start()
	_add_bleed_fx(target)
	yield(actor.move_tween, "tween_all_completed")
#	yield(actor.get_tree().create_timer(0.5), "timeout")
	target.health -= _calc_damage(actor, target)
	if target.health <= 0:
		target.status = GameEntity.Status.DEAD
		ani = target.model.get_node('AnimationPlayer')
		if ani:
			ani.play('Attack')
	print('Done attacking')
	done_acting(actor)


static func attempt(actor:GameEntity, params:Dictionary):
	if !can_act(actor):
		return
	var map = params.get('map') as LevelMap
	var target = params.get('target') as GameEntity
	if map == null or target == null:
		return
	print('Start attacking')
	start_acting(actor)
	_attack(actor, target)
	print('Exit attacking')


static func _calc_damage(actor:GameEntity, target:GameEntity) -> int :
	return 1
