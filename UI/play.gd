extends Control

@onready var play_button: Button = $PlayButton
@onready var spawner: Node = get_tree().get_first_node_in_group("enemy_spawner")
@onready var waves: Node = get_tree().get_first_node_in_group("wave")

func _ready() -> void:
	pass
	#	play_button.pressed.connect(_on_play_pressed)
		


func _on_play_button_pressed() -> void:
	hide()
	get_tree().paused = false
	spawner.game_started = true
	waves.start_waves()
