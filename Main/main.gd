extends Node2D

@onready var you_win = $UI/YouWin
@onready var player = $Player
@onready var play = $UI/Play
@onready var spawner = $EnemySpawner

var has_enemies_spawned := false
var check_timer_running := false

func _ready() -> void:
	you_win.visible = false
	get_tree().paused = true  # Game starts paused
	spawner.enemies_spawned.connect(_on_enemies_spawned)

func _physics_process(delta: float) -> void:
	if has_enemies_spawned and not check_timer_running:
		if get_tree().get_nodes_in_group("enemy").is_empty():
			check_timer_running = true
			await_delay_then_check()

func _on_enemies_spawned() -> void:
	print("✅ Enemies spawned")
	has_enemies_spawned = true
	check_timer_running = false

func await_delay_then_check() -> void:
	await get_tree().create_timer(1.0).timeout  # Delay before win
	if get_tree().get_nodes_in_group("enemy").is_empty():
		print("🏆 YOU WIN!")
		you_win.visible = true
		player.set_process(false)
	check_timer_running = false
