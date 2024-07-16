extends CanvasLayer

@onready var timer_label: Label = %TimeLabel
@onready var meat_label: Label = %MeatLabel
#
#func _ready() -> void:
	#if GameManager.player:
		#GameManager.player.meat_collected.connect(on_meat_collected)
	#GameManager.meat_counter = 0

func _process(delta) -> void:
	timer_label.text = GameManager.time_elapsed_str
	meat_label.text = str(GameManager.meat_counter)
	
#func on_meat_collected() -> void:
	#GameManager.meat_counter += 1
	#meat_label.text = str(GameManager.meat_counter)
