class_name Action
extends Node


static func attempt(actor:GameEntity, params:Dictionary):
	pass


static func can_act(actor:GameEntity) -> bool:
	return actor.status == GameEntity.Status.ALIVE


static func done_acting(actor:GameEntity, action_points_used:int=100):
	if actor.status == GameEntity.Status.ACTING:
#		print('Done acting %s' % actor)
		actor.status = GameEntity.Status.ALIVE
	actor.emit_signal("turn_completed", actor, action_points_used)


static func free_actor(actor:GameEntity):
	if actor.status == GameEntity.Status.ACTING:
#		print('Free to act %s' % actor)
		actor.status = GameEntity.Status.ALIVE


static func start_acting(actor:GameEntity):
	if actor.status == GameEntity.Status.ALIVE:
#		print('Starting to act %s' % actor)
		actor.status = GameEntity.Status.ACTING
