extends CanvasLayer

@onready var time_label:Label = %timerLabel
@onready var gold_label:Label = %goldlabel
@onready var meat_label:Label = %meatLabel


func _process(delta):
	time_label.text = GameManager.time_elapsed_str
	meat_label.text = str(GameManager.meat_counter)



