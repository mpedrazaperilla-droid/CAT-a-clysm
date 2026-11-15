extends Area2D

@export var speed: float = 300.0
@export var damage: int = 10
@export var bounces: int = 2

var dir := Vector2.RIGHT
var hit: Array = []
var life := 3.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += dir * speed * delta
	life -= delta
	if life <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body in hit or not body.is_in_group("enemies"):
		return
	hit.append(body)
	body.take_damage(damage, global_position, 250.0)
	if bounces <= 0:
		queue_free()
		return
	bounces -= 1
	var target := _nearest_enemy()
	if target == null:
		queue_free()
		return
	dir = global_position.direction_to(target.global_position)

func _nearest_enemy() -> Node2D:
	var best: Node2D = null
	var best_d := INF
	for e in get_tree().get_nodes_in_group("enemies"):
		if e in hit or e.is_queued_for_deletion():
			continue
		var d := global_position.distance_squared_to(e.global_position)
		if d < best_d:
			best_d = d
			best = e
	return best
