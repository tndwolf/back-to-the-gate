extends Control


onready var description_label = $Panel/VBoxContainer/DescriptionLabel


func _on_StalkerBtn_pressed():
	description_label.text = find_node('StalkerBtn').skill.description


func _on_CamouflageBtn_pressed():
	description_label.text = find_node('CamouflageBtn').skill.description


func _on_BlinkBtn_pressed():
	description_label.text = find_node('BlinkBtn').skill.description
