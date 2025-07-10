extends Node2D

signal enemies_spawned

@export var enemy_scene: PackedScene
@export var spawn_count: int = 5
@export var edge_padding: int = 64
@export var min_distance_from_player: float = 150.0
@export var shop_width: int = 500

func spawn_enemies_in_view() -> void:
	if not enemy_scene:
		print("❌ enemy_scene not assigned.")
		return

	await get_tree().process_frame  # 🔁 Ensure scene tree is ready

	var player := get_tree().get_first_node_in_group("player") as CharacterBody2D
	if not player:
		print("❌ Player not found in group 'player'")
		return

	var screen_size = get_viewport().get_visible_rect().size
	var screen_pos = player.global_position - screen_size / 2

	var spawned := 0
	var attempts := 0
	var max_attempts := spawn_count * 10

	while spawned < spawn_count and attempts < max_attempts:
		attempts += 1

		var x = randf_range(
			screen_pos.x + shop_width + edge_padding,
			screen_pos.x + screen_size.x - edge_padding
		)
		var y = randf_range(
			screen_pos.y + edge_padding,
			screen_pos.y + screen_size.y - edge_padding
		)
		var spawn_pos = Vector2(x, y)

		if spawn_pos.distance_to(player.global_position) < min_distance_from_player:
			continue

		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_pos
		get_tree().current_scene.call_deferred("add_child", enemy)
		spawned += 1

	print("✅ Spawned", spawned, "enemies.")
	emit_signal("enemies_spawned")
