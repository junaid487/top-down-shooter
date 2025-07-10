extends CharacterBody2D

@export var speed: float = 200
@export var max_hp: int = 100

var current_hp: int

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	current_hp = max_hp
	add_to_group("enemy")  # ✅ Required for win detection

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(amount: int) -> void:
	current_hp -= amount
	if current_hp <= 0:
		queue_free()
