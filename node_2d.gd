extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 300.0

var player: Node2D

func _ready() -> void:
	player = get_parent()
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if player == null:
		return
	var enemy := enemy_scene.instantiate()
	var angle := randf() * TAU
	enemy.global_position = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_radius
	add_child(enemy)
