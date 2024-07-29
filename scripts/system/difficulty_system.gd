extends Node

@export var mob_spawner:MobSpawner
@export var initial_spawn_rate:float = 60
@export var mob_increase:float = 30
@export var wave_duration:float = 60.0
@export var break_intensity:float = 0.5

var time:float = 0.0

func _process(delta):
	if GameManager.is_over: return
	
	
	time+= delta
	
	var spawn_rate = initial_spawn_rate + mob_increase * (time/60)
	
	var sin_wave = sin((time * TAU) /  wave_duration)
	var wave_factor  = remap(sin_wave,-1.0,1.0,break_intensity,1)
	
	
	spawn_rate *= wave_factor
	
	mob_spawner.frequency = spawn_rate
	
	
	
