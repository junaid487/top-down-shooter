extends Control

func _on_restart_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Main/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
