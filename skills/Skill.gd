class_name Skill
extends Resource


## The name of the Skill
export var name:String
## The full Skill description
export(String, MULTILINE) var description:String
## Skill button texture - available
export var available_texture:Texture
## Skill button texture - selected
export var selected_texture:Texture


func add_to(actor:GameEntity):
	pass
