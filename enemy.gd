extends CharacterBody2D

@export var max_health: int = 30
@export var speed: float = 60.0
@export var damage: int = 10
@export_range(0.0, 1.0) var knockback_resistance: float = 0.0

var health: int
var player: Node2D
var knockback := Vector2.ZERO

func _ready() -> void:
	health = max_health
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var dir := global_position.direction_to(player.global_position)
	velocity = dir * speed + knockback
	knockback = knockback.move_toward(Vector2.ZERO, 600.0 * delta)
	$Sprite2D.flip_h = dir.x < 0
	move_and_slide()

	for body in $Hitbox.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage)

func take_damage(amount: int, from_pos: Vector2 = Vector2.ZERO, force: float = 0.0) -> void:
	health -= amount
	if force > 0.0:
		knockback = from_pos.direction_to(global_position) * force * (1.0 - knockback_resistance)
	if health <= 0:
		die()
		return
	var t := create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 0.15).from(Color(1, 0.5, 0.5))

func die() -> void:
	queue_free()
