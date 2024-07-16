class_name MobSpawnner

extends Node2D

var mob_per_minute: float = 60.0
@export var creatures: Array[PackedScene]
@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var spawn_cooldown: float = 0.0


func _process(delta) -> void:
	if GameManager.is_game_over: return
	
	spawn_cooldown -= delta
	
	if spawn_cooldown > 0: return
	
	var interval = 60.0 / mob_per_minute
	spawn_cooldown = interval
	spawn_random_creature()
	
	
func spawn_random_creature() -> void:
	var creature = creatures.pick_random().instantiate()
	var point  = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return 
	
	creature.global_position = point
	get_parent().add_child(creature)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
