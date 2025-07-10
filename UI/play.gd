extends Control

@onready var spawner = get_tree().get_first_node_in_group("enemy_spawner")
@onready var main = get_tree().get_first_node_in_group("main")

func _on_button_pressed() -> void:
	print("▶️ Play pressed")
	main.get_tree().paused = false
	visible = false

	await get_tree().process_frame  # Wait 1 frame after unpausing
	await get_tree().create_timer(1.5).timeout  # Now this will work correctly

	if spawner:
		spawner.spawn_enemies_in_view()
	else:
		print("❌ Spawner not found in group 'enemy_spawner'")
