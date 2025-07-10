extends CharacterBody2D

@export var speed: float = 400
@export var fire_rate: float = 1.0  # 🔫 Shots per second

@onready var joystick = $UIPlayer/JoyStick
@onready var bullet_scene = preload("res://Bullets/bullet.tscn")
@onready var fire_rate_timer: Timer = $FireRate
@onready var fire_rate_label = $UI/FireRateLabel  # Optional, only if using label

func _ready() -> void:
	update_fire_rate()
	fire_rate_timer.start()

	#_on_fire_rate_timeout()  # 🔫 Fire immediately

	print("Player ready. Timer started:", not fire_rate_timer.is_stopped())

func _physics_process(delta: float) -> void:
	var dir = joystick.get_direction()
	velocity = dir * speed
	move_and_slide()

func _on_fire_rate_timeout() -> void:
	print("FireRate timeout triggered")
	var target = get_nearest_enemy()
	if target:
		print("Nearest enemy found, spawning bullet")
		spawn_bullet_towards(target)
	else:
		print("No enemies found")

func get_nearest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	print("Enemies in group:", enemies.size())

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
	get_tree().current_scene.call_deferred("add_child", bullet)
	print("Bullet spawned at:", bullet.global_position)

func update_fire_rate() -> void:
	fire_rate = max(fire_rate, 0.1)
	fire_rate_timer.wait_time = 1.0 / fire_rate
	if fire_rate_label:
		fire_rate_label.text = "Fire Rate: %.1f shots/sec" % fire_rate
	print("Updated fire rate to:", fire_rate, "→ Timer wait time:", fire_rate_timer.wait_time)

func upgrade_fire_rate():
	fire_rate += 0.1
	update_fire_rate()
	print("Fire rate upgraded. New rate:", fire_rate)

func spawn_bullet():
	var bullet2 = bullet_scene.instantiate()
	bullet2.global_position = global_position
	bullet2.dir = Vector2.LEFT
	get_parent().add_child(bullet2)
