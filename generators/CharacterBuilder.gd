class_name CharacterBuilder
extends Node


const OBJECTS_GROUP := 'objects'
const ENEMIES_GROUP := 'enemies'
const PLAYER_GROUP := 'player'


const ArtifactModel = preload("res://entities/ArtifactModel.tscn")
const HumanModel = preload("res://entities/HumanModel.tscn")
const MilitaryModel = preload("res://entities/MilitaryModel.tscn")
const PlayerModel = preload("res://entities/PlayerModel.tscn")
const PackedEntity = preload("res://entities/GameEntity.tscn")


var _model:Sprite
var _is_player := false
var _type = GameEntity.Type.SCIENTIST


func build() -> GameEntity:
	var res = PackedEntity.instance()
	if _is_player:
		res.is_player = true
		res.mind = load("res://entities/minds/PlayerMind.gd").new()
		res.add_to_group(PLAYER_GROUP)
		var camera = Camera2D.new()
		camera.current = true
		res.add_child(camera)
		var view_cone = res.find_node('ViewCone') as Area2D
		view_cone.monitorable = false
		view_cone.monitoring = false
		res.weapon = GameEntity.Weapon.CLAWS
		res.health = 10
		res.name = 'Player'
	else:
		res.find_node('Light').queue_free()
		res.unit_type = _type
		match _type:
			GameEntity.Type.MILITARY, GameEntity.Type.SCIENTIST:
				res.mind = load("res://entities/minds/ArtificialMind.gd").new()
				res.add_to_group(ENEMIES_GROUP)
			_:
				res.add_to_group(OBJECTS_GROUP)
	if _model:
		res.model = _model
	return res as GameEntity


func from_template(type:int) -> CharacterBuilder:
	_type = type
	match type:
		GameEntity.Type.ARTIFACT:
			var model = ArtifactModel.instance()
			model.frame += randi() % 4
			with_model(model)
		GameEntity.Type.MILITARY: with_model(MilitaryModel.instance())
		GameEntity.Type.SCIENTIST: with_model(HumanModel.instance())
	return self


func is_player() -> CharacterBuilder:
	_is_player = true
	with_model(PlayerModel.instance())
	return self


func with_model(model:Sprite) -> CharacterBuilder:
	_model = model
	return self
