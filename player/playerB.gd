extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed = 3
@export var sword_damage = 2

var input_vector: Vector2 = Vector2(0, 0)
var is_running = false
var was_running = false
var is_attacking = false
var attack_cooldown:float = 0.0

func _process(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		
	if attack_cooldown <= 0.0:
		is_attacking = false	
		
	read_input()	
	play_iddle_running_animation()
	
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(_delta: float) -> void:
	GameManager.player_position = position
	# updates velocity
	var target_velocity = input_vector * speed * 100.0
	if is_attacking: input_vector *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
func play_iddle_running_animation() -> void:
	# updates is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	# swiches animation
	if was_running != is_running:
		if is_running:
			sprite.play("running")
		else:
			sprite.play("idle")
			
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true

func attack() -> void:
	if is_attacking:
		return
		
	sprite.play("attack_side_a")
	attack_cooldown = 0.6
	is_attacking = true
	
func read_input() -> void:
	# gets input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# delete deadzone
	var deadzone = 0.15
	if (abs(input_vector.x) < deadzone):
		input_vector.x = 0.0
	if (abs(input_vector.y) < deadzone):
		input_vector.y = 0.0
		
func deal_damage_to_enemy() -> void:
	var enemies = get_tree().get_first_node_in_group("enemies")
	for enemy in enemies:
		enemy.damage(sword_damage)	
