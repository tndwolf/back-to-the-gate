class_name CharacterBuilder
extends Node


const HumanModel = preload("res://entities/HumanModel.tscn")
const PackedEntity = preload("res://entities/GameEntity.tscn")


var _model:Sprite
var _is_player := false


func build() -> GameEntity:
	var res = PackedEntity.instance()
	if _is_player:
		res.is_player = true
		res.mind = load("res://entities/minds/PlayerMind.gd").new()
		res.add_to_group('player')
		var camera = Camera2D.new()
		camera.current = true
		res.add_child(camera)
		var view_cone = res.find_node('ViewCone') as Area2D
		view_cone.monitorable = false
		view_cone.monitoring = false
		res.weapon = GameEntity.Weapon.CLAWS
		res.health = 10
	else:
		res.find_node('Light').queue_free()
		res.mind = load("res://entities/minds/ArtificialMind.gd").new()
		res.add_to_group('enemies')
	if _model:
		res.model = _model
	return res as GameEntity


func model(model:Sprite) -> CharacterBuilder:
	_model = model
	return self


func is_player() -> CharacterBuilder:
	_is_player = true
	return self
