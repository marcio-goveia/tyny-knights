extends Node

signal game_over

var player_position: Vector2
#var play_has_died = false
var player: Player
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_str: String
var meat_counter: int = 0
var enemies_defeated: int


func _process(delta) -> void:
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	time_elapsed_str = "%02d:%02d" % [minutes, seconds]

func end_game():
	if is_game_over: return 
	
	is_game_over = true
	game_over.emit()
	
func reset() -> void:
	is_game_over = false
	player = null
	player_position = Vector2.ZERO
	
	time_elapsed = 0.0
	time_elapsed_str = "00:00"
	meat_counter = 0
	enemies_defeated = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
