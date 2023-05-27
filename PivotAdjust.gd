tool
extends HBoxContainer


var frame_number = 0
var pivot_position = Vector2.ZERO
var pivot_rot = 0
var pivot_hide = false
var texture = null
var pivot_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = String(frame_number) + ":"
	$X_Value.connect("value_changed",self,"x_changed")
	$Y_Value.connect("value_changed",self,"y_changed")
	$Rot_Value.connect("value_changed",self,"rot_changed")
	$X_Value.value = pivot_position.x
	$Y_Value.value = pivot_position.y
	$Rot_Value.value = pivot_rot
	$Hide.pressed = pivot_hide
	

func _process(delta):
	pivot_hide = $Hide.pressed

func x_changed(value):
	pivot_position.x = value

func y_changed(value):
	pivot_position.y = value

func rot_changed(value):
	pivot_rot = value


	


