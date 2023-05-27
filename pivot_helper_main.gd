extends EditorInspectorPlugin


var _pivot: Pivot

func can_handle(object):
	return object is Pivot


func parse_begin(object):
	_pivot = object


func parse_end():
	var control_instance = preload("res://addons/pivot_helper/PivotHelperPanel.tscn").instance()
	control_instance.set("pivot_node", _pivot)
	var ep = EditorProperty.new()
	ep.add_child(control_instance)
	ep.set_bottom_editor(control_instance)
	add_custom_control(ep)
