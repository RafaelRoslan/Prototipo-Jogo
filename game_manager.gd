extends Node

signal game_over

var player:Player
var player_position:Vector2
var is_over:bool = false

var time_elapsed:float = 0
var time_elapsed_str:String
var meat_counter: int = 0
var enemies_count:int = 0

func _process(delta):
	time_elapsed += delta
	
	var time_elapse_seconds: int = floori(time_elapsed)
	var seconds:int = time_elapse_seconds % 60
	var minutes:int = time_elapse_seconds / 60
	
	time_elapsed_str = "%02d:%02d" % [minutes, seconds]

func end_game():
	if is_over:return
	
	is_over = true
	game_over.emit()
	

func reset_game():
	player = null
	player_position = Vector2.ZERO
	is_over = false
	time_elapsed = 0
	time_elapsed_str = ""
	meat_counter = 0
	enemies_count = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
