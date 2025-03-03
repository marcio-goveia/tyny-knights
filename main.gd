extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui: PackedScene

func _ready():
	print(GameManager.game_over)
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	var game_over_ui: GameOverUI = game_over_ui.instantiate()
	add_child(game_over_ui)
