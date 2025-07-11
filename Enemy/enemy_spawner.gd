extends Node2D

signal enemies_spawned
signal wave_finished

@export var enemy_scene: PackedScene
@export var screen_padding: int = 64
@export var shop_zone_width: int = 500
@export var min_distance_from_player: float = 150

var waves := [3, 5, 7]  # Enemy count for each wave
var current_wave: int = 0
var game_started := false

var player: CharacterBody2D
var spawned_enemies := []

func _ready() -> void:
	add_to_group("enemy_spawner")
	player = get_tree().get_first_node_in_group("player")

func start_waves() -> void:
	game_started = true
	current_wave = 0
	spawn_wave()

func spawn_wave() -> void:
	if current_wave >= waves.size():
		print("✅ All waves completed.")
		emit_signal("wave_finished")
		return

	var count = waves[current_wave]
	current_wave += 1
	await spawn_enemies_delayed(count)

	emit_signal("enemies_spawned")
	print("✅ Spawned wave:", current_wave)

func spawn_enemies_delayed(count: int) -> void:
	for i in range(count):
		await get_tree().create_timer(0.5).timeout
		spawn_single_enemy()

func spawn_single_enemy() -> void:
	if not game_started or enemy_scene == null or player == null:
		return

	var vp_rect: Rect2 = get_viewport().get_visible_rect()
	var spawn_rect = Rect2(
		vp_rect.position + Vector2(shop_zone_width + screen_padding, screen_padding),
		vp_rect.size - Vector2(shop_zone_width + screen_padding * 2, screen_padding * 2)
	)

	var tries = 0
	while tries < 10:
		var pos = Vector2(
			randf_range(spawn_rect.position.x, spawn_rect.position.x + spawn_rect.size.x),
			randf_range(spawn_rect.position.y, spawn_rect.position.y + spawn_rect.size.y)
		)

		if pos.distance_to(player.global_position) >= min_distance_from_player:
			var enemy = enemy_scene.instantiate()
			enemy.global_position = pos
			get_tree().current_scene.call_deferred("add_child", enemy)
			spawned_enemies.append(enemy)
			return
		tries += 1
