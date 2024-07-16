extends Node

@export var mob_spawnner: MobSpawnner
@export var initial_spanw_rate: float = 60.0
@export var spawn_rate_per_minute: float = 30.0
@export var wave_duration: float = 20
@export var breack_intensity: float = 0.5

var time: float = 0.0

func _process(delta):
	if GameManager.is_game_over: return
	
	time += delta
	
	var span_rate = initial_spanw_rate + spawn_rate_per_minute * (time / 60)
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, breack_intensity, 1)
	span_rate *= wave_factor
	
	mob_spawnner.mob_per_minute = span_rate
