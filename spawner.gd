extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_radius: float = 300.0

var elapsed := 0.0

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	elapsed += delta

func _on_timer_timeout() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null or enemy_scenes.is_empty():
		return
	$Timer.wait_time = max(0.2, 1.0 - elapsed * 0.01)
	var unlocked := mini(enemy_scenes.size(), 1 + int(elapsed / 30.0))
	var enemy := enemy_scenes[randi() % unlocked].instantiate()
	add_child(enemy)
	var angle := randf() * TAU
	enemy.global_position = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_radius
