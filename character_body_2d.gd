extends CharacterBody2D

@export var speed: float = 150.0
@export var max_health: int = 100
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.8

var health: int = max_health
var facing := Vector2.RIGHT
var invulnerable := false
var shoot_timer := 0.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Disparo automático
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		shoot_timer = fire_rate
		shoot()

	# Movimiento WASD
	var input_dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	input_dir = input_dir.normalized()

	velocity = input_dir * speed

	# Animación
	if input_dir != Vector2.ZERO:
		facing = input_dir
		$Sprite2D.flip_h = input_dir.x < 0
		$Sprite2D.play("walk")
	else:
		$Sprite2D.stop()
		$Sprite2D.frame = 0

	move_and_slide()

func shoot() -> void:
	if bullet_scene == null:
		return
	var target := _nearest_enemy()
	if target == null:
		return
	var b := bullet_scene.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position
	b.dir = global_position.direction_to(target.global_position)

func _nearest_enemy() -> Node2D:
	var best: Node2D = null
	var best_d := INF
	for e in get_tree().get_nodes_in_group("enemies"):
		var d := global_position.distance_squared_to(e.global_position)
		if d < best_d:
			best_d = d
			best = e
	return best

func take_damage(amount: int) -> void:
	if invulnerable:
		return
	health -= amount
	if health <= 0:
		get_tree().get_first_node_in_group("ui").game_over()
		return
	invulnerable = true
	modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE
	invulnerable = false
