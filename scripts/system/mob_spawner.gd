class_name MobSpawner
extends Node2D

@onready var path_follow:PathFollow2D = %PathFollow2D

@export var enemies:Array[PackedScene]
var frequency:float = 60.0

var spawn_cooldown:float = 0

func _process(delta):
	if GameManager.is_over: return
	
	#temporizador
	spawn_cooldown -= delta
	if spawn_cooldown > 0: return
	
	#frequencia:monstro por minuto
	var interval = 60.0/ frequency
	spawn_cooldown = interval
	
	#checar se é valido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result:Array = world_state.intersect_point(parameters, 1)
	
	if not result.is_empty():return
	
	#intanciar inimigo
	# - pegar criatura aleatoria
	var index = randi_range(0,enemies.size()-1)
	var enemy_scene = enemies[index]
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = point
	get_parent().add_child(enemy)
	# - Pegar ponto aleatório
	# - instanciar cena
	# - Colocar na posicao
	
	pass


func  get_point():
	path_follow.progress_ratio = randf()
	return path_follow.global_position
