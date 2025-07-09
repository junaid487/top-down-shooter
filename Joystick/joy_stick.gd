extends Control

@export var joystick_radius: float = 150.0
@export var outer_circle_path: NodePath
@export var inner_circle_path: NodePath

var start_pos := Vector2.ZERO
var current_touch_pos := Vector2.ZERO
var dragging := false

@onready var outer: Sprite2D = get_node(outer_circle_path)
@onready var inner: Sprite2D = get_node(inner_circle_path)

func _ready():
	visible = false
	# Ensure the nodes were correctly assigned
	if not is_instance_valid(outer) or not is_instance_valid(inner):
		print("ERROR: Joystick circles not assigned correctly! Check NodePaths in Inspector.")
		set_process(false) # Stop processing if nodes aren't found
		return
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			
			start_pos = event.position
			current_touch_pos = start_pos
			global_position = start_pos # Position the joystick's center at the touch point
			visible = true
			dragging = true
			get_viewport().set_input_as_handled() # Consume the event
		elif dragging: # Only release if currently dragging
			dragging = false
			visible = false
			inner.position = Vector2.ZERO # Reset inner circle position
			get_viewport().set_input_as_handled() # Consume the event
	elif event is InputEventScreenDrag and dragging:
		current_touch_pos = event.position
		get_viewport().set_input_as_handled() # Consume the event
		
func _process(delta):
	if dragging:
		var delta_vec = current_touch_pos - start_pos
		if delta_vec.length() > joystick_radius:
			delta_vec = delta_vec.normalized() * joystick_radius
		inner.position = delta_vec
	else:
		inner.position = Vector2.ZERO # Ensure inner circle resets when not dragging

func get_direction() -> Vector2:
	if dragging:
		var dir = current_touch_pos - start_pos
		
		if dir.length() > joystick_radius:
			dir = dir.normalized()
		else:
			dir /= joystick_radius
		return dir
	return Vector2.ZERO
