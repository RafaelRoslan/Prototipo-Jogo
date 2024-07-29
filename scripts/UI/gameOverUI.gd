class_name GameOverUI
extends CanvasLayer

@onready var time_label:Label = %timelabel
@onready var monster_label:Label = %monsterLabel

@export var restart_delay: float = 5.0
var restart_cooldown:float

func _ready():
	time_label.text = GameManager.time_elapsed_str
	monster_label.text =str(GameManager.enemies_count)
	restart_cooldown = restart_delay
	
func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
	

func restart_game():
	#reseta o GameMnager
	GameManager.reset_game()
	#recarregar a cena
	get_tree().reload_current_scene()
	pass


