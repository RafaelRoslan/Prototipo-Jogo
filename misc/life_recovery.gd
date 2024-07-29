extends Node2D

@export var life_recovery:int = 3


func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	pass
	
func on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var player:Player = body
		player.heal(life_recovery)
		player.meat_collect.emit(life_recovery)
		queue_free()
	pass
