extends Area2D

@export var initial_speed: float = -150.0
@export var acceleration: float = 300.0
@export var max_speed: float = 1000.0

var target: CharacterBody2D
var speed: float = 0.0
var moving: bool = false

func _ready() -> void:
	speed = initial_speed
	# 🔁 Connect signal using Callable (modern Godot 4.x s	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		print("✅ Player entered range:", body.name)
		target = body
		moving = true
		#speed = initial_speed

func _physics_process(delta: float) -> void:
	if moving and is_instance_valid(target):
		speed = min(speed + acceleration * delta, max_speed)
		position = position.move_toward(target.global_position, speed * delta)

		if position.distance_to(target.global_position) < 50.0:
			queue_free()
