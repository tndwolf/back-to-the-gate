extends Node


var _actors = []


func add(actor:GameEntity):
	if actor in _actors:
		return
	actor.connect("dead", self, "_on_dead")
	actor.connect("turn_completed", self, "_on_turn_completed")
	actor.initiative = 0 if _actors.empty() else _actors.back().initiative + 1
	_actors.append(actor)
	_refresh()


func clear():
	_actors.clear()


func current() -> GameEntity:
	if _actors.empty():
		return null
	var actor = _actors[0]
	if actor.status in [GameEntity.Status.DEAD, GameEntity.Status.DRAINED]:
		_refresh()
		return current()
	return actor


func _on_dead(entity:GameEntity):
#	print(entity.name + ' dead')
	_actors.erase(entity)
	return


func _on_turn_completed(entity:GameEntity, action_points_used:int):
	entity.initiative += action_points_used
#	print(entity.name + ' over')
	_refresh()


func _refresh():
	for actor in _actors:
		if actor.status in [GameEntity.Status.DEAD, GameEntity.Status.DRAINED]:
			_actors.erase(actor)
	_actors.sort_custom(self, "_sort")


func _sort(a, b) -> bool:
	 return a.initiative < b.initiative
