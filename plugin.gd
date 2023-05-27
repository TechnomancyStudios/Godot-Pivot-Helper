tool
extends EditorPlugin

var plugin: EditorInspectorPlugin

func _enter_tree() -> void:
	plugin = preload("res://addons/pivot_helper/pivot_helper_main.gd").new() 
	add_inspector_plugin(plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(plugin)
