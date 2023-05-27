tool

class_name Pivot
extends Node2D

export(Resource) var pivot_resource
export(NodePath) var animated_sprite_path

onready var animated_sprite = get_node(animated_sprite_path)


func _process(delta):
	if animated_sprite != null:
		modulate.a = animated_sprite.modulate.a
		if animated_sprite.playing:
			update_position()
	else:
		animated_sprite = get_node(animated_sprite_path)
		

func update_position():
	if pivot_resource.pivot_points.has(animated_sprite.animation):
		var pivot_list = pivot_resource.pivot_points[animated_sprite.animation]
		show()
		if pivot_list != null:
			position = pivot_list[animated_sprite.frame].position
	else:
		hide()
