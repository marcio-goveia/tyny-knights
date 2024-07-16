class_name GameOverUI
extends CanvasLayer

@onready var time_survived_label: Label = %TimeSurvivedLValue
@onready var enemies_defeated_label: Label = %EnemiesDefeatedValue

@export var restart_delay: float = 5.0
var restart_cooldown: float

func _ready():
	time_survived_label.text = GameManager.time_elapsed_str
	enemies_defeated_label.text = str(GameManager.enemies_defeated)
	
	restart_cooldown = restart_delay
	
func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
		
func restart_game() -> void:
	print("Restarting game...")
	GameManager.reset()
	get_tree().reload_current_scene()
