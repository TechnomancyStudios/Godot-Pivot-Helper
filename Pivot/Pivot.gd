tool

class_name Pivot
extends Node2D

export(Resource) var pivot_resource
export(NodePath) var animated_sprite_path

onready var animated_sprite = get_node(animated_sprite_path) as AnimatedSprite
var flipped = 1

func _process(delta):
	if animated_sprite != null:
		modulate.a = animated_sprite.modulate.a
		
		if animated_sprite.flip_h:
			flipped = -1
		else:
			flipped = 1
		
		if animated_sprite.playing:
			update_position()
	else:
		animated_sprite = get_node(animated_sprite_path)
		

func update_position():
	if pivot_resource.pivot_points.has(animated_sprite.animation):
		var pivot_list = pivot_resource.pivot_points[animated_sprite.animation]
		show()
		if pivot_list != null:
			if animated_sprite.frame < pivot_list.size():
				position = pivot_list[animated_sprite.frame].position * Vector2(flipped, 1)
				rotation_degrees = pivot_list[animated_sprite.frame].rotation * flipped
	else:
		hide()
