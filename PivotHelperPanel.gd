tool
extends PanelContainer

onready var option_button = $VBoxContainer/OptionButton as OptionButton
onready var apply_button = $VBoxContainer/Apply
onready var frames = $VBoxContainer/HBoxContainer2/ScrollContainer/Frames as VBoxContainer
onready var animation_create = $VBoxContainer/AnimationControls/Create as Button
onready var animation_reset = $VBoxContainer/AnimationControls/Reset as Button
onready var sprite_play = $VBoxContainer/SpriteControls/Play as Button
onready var sprite_stop = $VBoxContainer/SpriteControls/Stop as Button
onready var sprite_back = $VBoxContainer/SpriteControls2/Back as Button
onready var sprite_next = $VBoxContainer/SpriteControls2/Next as Button
onready var sprite_current_frame = $VBoxContainer/SpriteControls2/CurrentFrame as SpinBox
onready var sprite_set_position = $VBoxContainer/SetPosition as Button
var pivot_points:PivotResource
var pivot_node:Pivot
var pivot_sprite:AnimatedSprite
var current_animation = "default"
var current_index = 0
var frame_rate = 24

var current_frame_num = 0
var time_passed = 0
var frame_count_changed = false

func _ready():
	if not pivot_node:
		return
	
	option_button.connect("item_selected", self, "item_selected")
	apply_button.connect("pressed",self,"apply")
	
	animation_create.connect("pressed",self,"animation_create")
	animation_reset.connect("pressed",self,"animation_reset")
	sprite_play.connect("pressed",self,"sprite_play_animation")
	sprite_stop.connect("pressed",self,"sprite_stop_animation")
	sprite_back.connect("pressed",self,"sprite_last_frame")
	sprite_next.connect("pressed",self,"sprite_next_frame")
	sprite_current_frame.connect("value_changed",self,"current_frame_changed")
	sprite_set_position.connect("pressed",self,"sprite_update_position")
	
	pivot_points = pivot_node.pivot_resource
	pivot_sprite = pivot_node.animated_sprite
	
	refresh_options()
	for o in range(option_button.get_item_count()):
		if option_button.get_item_text(o) == pivot_sprite.animation:
			option_button.select(o)
	sprite_current_frame.value = pivot_sprite.frame
	refresh_frames()

func _process(delta):
	if pivot_sprite != null:
		if pivot_sprite.playing:
			sprite_current_frame.value = pivot_sprite.frame

func refresh_options():
	for an in pivot_sprite.frames.get_animation_names():
		option_button.add_item(an)
	current_animation = option_button.get_item_text(option_button.selected)

func refresh_frames():
	var test = pivot_points.pivot_points[option_button.get_item_text(option_button.selected)] as Array
	
	for c in frames.get_children():
		c.queue_free()
	
	var count = 0
	for p in test:
		var pa = preload("res://addons/pivot_helper/PivotAdjust.tscn").instance()
		pa.frame_number = count
		pa.set("pivot_position", p.position)
		pa.set("pivot_hide", p.hide)
		pa.set("pivot_node", pivot_node)
		frames.add_child(pa)
		count += 1

func item_selected(idx):
	pivot_sprite.animation = option_button.get_item_text(idx)
	update_current_frame(0)
	refresh_frames()

func animation_create():
	pivot_points.pivot_points.clear()
	
	for an in pivot_sprite.frames.get_animation_names():
		var frame_count = pivot_sprite.frames.get_frame_count(an)
		for f in range(frame_count):
			if pivot_points.pivot_points.has(an):
				pivot_points.pivot_points[an].append(PivotPointResource.new())
			else:
				pivot_points.pivot_points[an] = [PivotPointResource.new()]
	refresh_frames()

func animation_reset():
	var test = {}
	
	pivot_points.pivot_points.erase(option_button.get_item_text(option_button.selected))
	refresh_options()

func sprite_play_animation():
	if pivot_sprite != null:
		pivot_sprite.play()
	else:
		print("Sprite does not exist.")

func sprite_stop_animation():
	if pivot_sprite != null:
		pivot_sprite.stop()
	else:
		print("Sprite does not exist.")

func sprite_next_frame(update_pos=true):
	var frame_count = pivot_sprite.frames.get_frame_count(option_button.get_item_text(option_button.selected))
	if pivot_sprite != null:
		if pivot_sprite.frame < frame_count-1:
			update_current_frame(pivot_sprite.frame + 1, update_pos)
		else:
			update_current_frame(0, update_pos)
	else:
		print("Sprite does not exist.")

func sprite_last_frame(update_pos=true):
	var frame_count = pivot_sprite.frames.get_frame_count(option_button.get_item_text(option_button.selected))
	if pivot_sprite != null:
		if pivot_sprite.frame > 0:
			update_current_frame(pivot_sprite.frame - 1, update_pos)
		else:
			update_current_frame(frame_count - 1, update_pos)
	else:
		print("Sprite does not exist.")

func sprite_update_position():
	var pos_list = pivot_points.pivot_points[option_button.get_item_text(option_button.selected)]
	frame_count_changed = true
	pos_list[sprite_current_frame.value].position = pivot_node.position
	sprite_next_frame(false)
	refresh_frames()
	

func update_current_frame(frame, update_pos=true):
	sprite_current_frame.value = frame
	pivot_sprite.frame = frame
	if update_pos:
		pivot_node.update_position()

func apply():
	var test = pivot_points.pivot_points[option_button.get_item_text(option_button.selected)] as Array
	var count = 0
	for pa in frames.get_children():
		test[count].position = pa.pivot_position
		test[count].hide = pa.pivot_hide
		count += 1

func current_frame_changed(value):
	if !frame_count_changed:
		update_current_frame(value)
	else:
		frame_count_changed = false
