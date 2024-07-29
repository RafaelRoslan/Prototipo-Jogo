extends Node

@export var speed:float =  1

var enemy : Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	pass

var player_position:Vector2 = Vector2(0,0)

func _physics_process(delta):
	if GameManager.is_over: return
	
	player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	flip_sprite(player_position)
	
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	pass
	
func flip_sprite(player_position:Vector2):
	if enemy.position.x > player_position.x:
		sprite.flip_h = true
	elif enemy.position.x < player_position.x:
		sprite.flip_h = false
	pass
	
