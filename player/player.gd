class_name Player extends CharacterBody2D

@export_category("Movement")
@export var speed = 3

@export_category("Sword")
@export var sword_damage = 2

@export_category("Spell")
@export var spell_damage: int = 4
@export var spell_prefab: PackedScene
@export var spell_interval: float = 15.0

@export_category("Life")
@export var health = 100
@export var death_prefab: PackedScene
@export var max_health: int = 100

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damageArea: Area2D = $damageArea
@onready var hitboxArea: Area2D = $hitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0, 0)
var is_running = false
var was_running = false
var is_attacking = false
var attack_cooldown:float = 0.0
var hitbox_cooldown:float = 0.0
var spell_cooldown: float = 0.0

signal meat_collected(value: int)

func _ready():
	GameManager.player = self
	meat_collected.connect(func(): GameManager.meat_counter += 1)

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	read_input()	
	update_attack_cooldown(delta)

	if Input.is_action_just_pressed("attack"):
		attack()

	play_idle_running_animation()
	rotate_sprite()
	update_hitbox_detection(delta)
	cast_spell(delta)
	update_healt_bar()
	

func update_healt_bar() -> void:
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health	
	
func _physics_process(_delta: float) -> void:
	
	# updates velocity
	var target_velocity = input_vector * speed * 100.0
	if is_attacking: target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown -= delta
	
	if hitbox_cooldown > 0: return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitboxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			damage(enemy.enemy_damage)

func play_idle_running_animation() -> void:
	# updates is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	# switches animation
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("running")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	if is_attacking: return
	
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func attack() -> void:
	if is_attacking:
		return
		
	animation_player.play("attack_side_a")
	attack_cooldown = 0.6
	is_attacking = true
	
func read_input() -> void:
	if is_attacking: return
	# gets input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# delete deadzone
	var deadzone = 0.15
	if (abs(input_vector.x) < deadzone):
		input_vector.x = 0.0
	if (abs(input_vector.y) < deadzone):
		input_vector.y = 0.0
		
func deal_damage_to_enemies() -> void:
	var bodies = damageArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"): 
			var enemy :Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction = Vector2()
			
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product > 0.3:
				enemy.damage(sword_damage)
	
func damage(amount: int):
	if health <= 0: return
	
	health -= amount
	
	modulate = Color.DEEP_PINK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj);
		
	queue_free()
	
func cast_spell(delta: float) -> void:
	spell_cooldown -= delta
	
	if spell_cooldown > 0: return
	spell_cooldown = spell_interval
	var spell = spell_prefab.instantiate()
	add_child(spell)

