class_name Enemy
extends Node2D

@export var speed: float
@export_category("Life")
@export var health = 10
@export var death_prefab: PackedScene
@export var enemy_damage = 1
var damage_digit_prefab: PackedScene

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var damage_digit_marker: Marker2D = $Marker2D

func damage(amount: int):
	# load damage digit scenne
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")
	health -= amount
	
	modulate = Color.DEEP_PINK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	if health <= 0:
		die()

func die() -> void:
	GameManager.enemies_defeated += 1
	if death_prefab:
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj);
		
	if randf() <= drop_chance:
		drop_item()
		
	queue_free() 
	
func drop_item() -> void:
	var drop = get_randon_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	
func get_randon_drop_item() -> PackedScene:
	if drop_items.size() == 1: 
		return drop_items[0]
	
	var max_chances: float = 0.0
	for drop_chance in drop_chances:
		max_chances += drop_chance
		
	var random_value = randf() * max_chances
	
	var needle: float = 0.0
	
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
		
	return drop_items[0]
	
