extends CharacterBody2D

@export var speed: float = 200
@export var max_hp: int = 100

var current_hp: int

@onready var coin_scene = preload("res://coin.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $AnimationPlayer
@onready var coin_container = get_tree().get_first_node_in_group("coin_container")

func _ready() -> void:
	current_hp = max_hp
	add_to_group("enemy")  # ✅ Required for win detection

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(amount: int) -> void:
	anim.play("scale")
	flash()
	current_hp -= amount
	if current_hp <= 0:
		spawn_coin()
		queue_free()
		
func flash():
	var temp = $Sprite2D.self_modulate
	$Sprite2D.self_modulate = Color.WHITE
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.self_modulate = temp

func spawn_coin():
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	coin_container.call_deferred("add_child",coin)
