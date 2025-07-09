extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

@export var speed: float = 250
@export var enemy_hp: int = 100

func _ready() -> void:
	enemy_hp = Global.enemy_hp
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(dmg: int) -> void:
	enemy_flash()
	anim.play("scale")
	
	enemy_hp -= dmg
	if enemy_hp <= 0:
		print("Enemy died")
		queue_free()
	else:
		print("Enemy HP:", enemy_hp)

func enemy_flash():
	var temp = sprite.self_modulate
	sprite.self_modulate = Color.WHITE
	await get_tree().create_timer(0.2).timeout
	sprite.self_modulate = temp
