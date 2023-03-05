class_name GameEntity
extends KinematicBody2D


signal dead(entity)
signal turn_completed(entity, action_points_used)


enum UnitType {
	PLAYER,
	SCIENTIST,
	MILITARY
}


enum Status {
	ALIVE,
	ACTING,
	DEAD,
	DRAINED
}

enum Weapon {
	UNHARMED,
	CLAWS,
	GUN,
	RIFLE
}


export var armor := 0
export var attack := 0
export var health := 1
export var initiative := 0
export var stealth := 0


var blood := 0
var character setget set_character, get_character
var grid_position:Vector2
var is_engaged := false
var is_hiding := false
var is_player := false
var mind setget set_mind # Mind
var model:Sprite setget set_model, get_model
var player_in_cone := false
var status:int = Status.ALIVE setget set_status, get_status
var target = null
var unit_type = UnitType.SCIENTIST
var weapon = Weapon.UNHARMED

onready var move_tween:Tween = $MoveTween
onready var view_box := $ViewBox
onready var view_ray:RayCast2D = $ViewRay


func get_character():
	return character


func get_model() -> Sprite:
	return model


func get_status():
	return status


func is_actor() -> bool:
	return character != null


func set_character(char_sheet) -> void:
	character = char_sheet


func set_mind(value) -> void:
	mind = value
	mind.owner = self


func set_model(value:Sprite) -> void:
	if model:
		remove_child(model)
	if $Model:
		remove_child($Model)
	model = value
	add_child(model)


func set_status(value:int) -> void:
	if value == status:
		return
	status = value
	if status == Status.DEAD:
		z_index = 0.2
		modulate = Color.red
		emit_signal("dead", self)


func _on_ViewCone_body_entered(body):
	if body != self and 'is_player' in body and body.is_player:
		player_in_cone = true
		target = body
		is_engaged = true
		print('player in view of %s' % self)
#		view_ray.cast_to = body.position - position
#		print('casting %s to %s = %s' % [position, body.position, (body.position - position)])
#		view_ray.force_raycast_update()
#		if view_ray.is_colliding():
#			var collider = view_ray.get_collider()
#			if collider == body:
#				player_in_cone = true
#				print('player in view of %s' % self)


func _on_ViewCone_body_exited(body):
	if body != self and 'is_player' in body and body.is_player:
		player_in_cone = false
		print('no longer in view of %s' % self)

