extends Node2D

@export var regeneration_amount: int = 10

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
		
func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		var player: Player = body
		heal(player)
		queue_free()
		
func heal(player: Player) -> void:
	var new_helth = player.health + regeneration_amount
	if new_helth > player.max_health:
		player.health = player.max_health
	else:
		player.health = new_helth
	player.meat_collected.emit()
	print(player.health, "/", player.max_health)
