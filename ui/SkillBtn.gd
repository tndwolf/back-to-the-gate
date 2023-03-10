extends TextureButton


export var skill:Resource


# Called when the node enters the scene tree for the first time.
func _ready():
	hint_tooltip = skill.name
	if skill.available_texture:
		texture_normal = skill.available_texture
		texture_hover = skill.available_texture
		texture_disabled = skill.available_texture
		texture_focused = skill.available_texture
	if skill.selected_texture:
		texture_pressed = skill.selected_texture
