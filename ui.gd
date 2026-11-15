extends CanvasLayer

@onready var bar: ProgressBar = $HealthBar
@onready var label: Label = $GameOverLabel
var player: Node
var dead := false

func _ready() -> void:
	add_to_group("ui")
	label.hide()
	player = get_tree().get_first_node_in_group("player")
	bar.max_value = player.max_health

func _process(_delta: float) -> void:
	if player and not dead:
		bar.value = player.health
	if dead and Input.is_key_pressed(KEY_R):
		get_tree().paused = false
		get_tree().reload_current_scene()

func game_over() -> void:
	dead = true
	bar.value = 0
	label.show()
	get_tree().paused = true
