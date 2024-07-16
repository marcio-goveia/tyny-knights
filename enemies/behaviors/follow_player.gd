extends Node

var enemy: Enemy
var sprite: AnimatedSprite2D
var input_vector = Vector2(0, 0)

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _process(_delta) -> void:
	if GameManager.is_game_over: return
	
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func _physics_process(_delta: float) -> void:
	if GameManager.is_game_over: return
	
	var player_position = GameManager.player_position
	input_vector = (player_position - enemy.position).normalized()
	enemy.velocity = input_vector * enemy.speed * 100
	enemy.move_and_slide()
