extends Node2D

@onready var enemy_container = $Containers/Enemy
@onready var you_win = $YouWin
@onready var player = $Player
@onready var play = $CanvasLayer/Play

func _ready() -> void:
	you_win.visible = false
	get_tree().paused = true

func _physics_process(delta: float) -> void:
	if enemy_container.get_children().size() <= 0:
		you_win.visible = true
		if !player:
			return
		else :
			player.queue_free()
	


func _on_button_pressed() -> void:
	get_tree().paused = false
	play.visible = false
