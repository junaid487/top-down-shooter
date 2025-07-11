extends Area2D

@export var speed = 1000

@onready var player = get_tree().get_first_node_in_group("player")

var dir : Vector2
@export var dmg: int = 10

func _ready() -> void:
	Global.bullet_dmg = dmg
	#dir = Vector2.RIGHT.rotated(player.rotation)
	
func _physics_process(delta: float) -> void:
	position += dir * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(Global.bullet_dmg)
	queue_free()

func _on_bulldt_free_timer_timeout() -> void:
	queue_free()
