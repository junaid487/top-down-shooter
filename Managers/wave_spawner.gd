extends Node

@export var wave_counts: Array[int] = [3, 5, 7]
@export var spawn_delay: float = 0.5
@export var first_wave_delay: float = 1.5
@export var next_wave_delay: float = 2.0

var current_wave: int = 0
@onready var spawner: Node = $"../EnemySpawner"

func start_waves() -> void:
		# Delay before first wave
		await get_tree().create_timer(first_wave_delay).timeout
		_run_next_wave()

func _run_next_wave() -> void:
		if current_wave >= wave_counts.size():
				return
		var count = wave_counts[current_wave]
		# Spawn one by one
		for i in count:
				spawner.call("spawn_single_enemy")
				await get_tree().create_timer(spawn_delay).timeout
		# Wait until all enemies cleared
		while get_tree().get_nodes_in_group("enemy").size() > 0:
				await get_tree().create_timer(0.5).timeout
		current_wave += 1
		# Delay before next wave
		await get_tree().create_timer(next_wave_delay).timeout
		_run_next_wave()
	
