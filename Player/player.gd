extends CharacterBody2D

@export var speed: float = 400
@onready var joystick = $UI/JoyStick
@onready var bullet_scene = preload("res://Bullets/bullet.tscn")

func _physics_process(delta: float) -> void:
	var dir = joystick.get_direction()
	velocity = dir * speed
	move_and_slide()

func _on_fire_rate_timeout() -> void:
	var target = get_nearest_enemy()
	if target:
		spawn_bullet_towards(target)

func get_nearest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest: CharacterBody2D = null
	var nearest_dist := INF

	for enemy in enemies:
		if not enemy is CharacterBody2D:
			continue
		var dist = global_position.distance_squared_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy

	return nearest

func spawn_bullet_towards(target: CharacterBody2D) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.dir = (target.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bullet)
