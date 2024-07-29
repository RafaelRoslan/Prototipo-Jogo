class_name Enemy
extends Node2D


@export var hp:int = 1
@export var dead_prefab:PackedScene
var damage_digit_prefab:PackedScene

@export var drop_chance:float = .1
@export var drop_itens: Array[PackedScene]
@export var drop_chance_array:Array[float]

@onready var damage_marker = $DamageMark

func  _ready():
	damage_digit_prefab = preload("res://DamageDigit.tscn")
	pass


func damage(amount:int):
	hp -= amount
	print("Inimigo recebeu ", amount, " de dano")
	
	#piscar node
	modulate = Color.RED
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate",Color.WHITE,0.3)
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_marker:
		damage_digit.global_position = damage_marker.global_position
	else:
		damage_digit.global_position = global_position
	
	get_parent().add_child(damage_digit)
	
	
	if hp <= 0:
		die()

func die():
	if dead_prefab:
		var death_obj = dead_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
		
	#drop
	if randf() <= drop_chance:
		drop_item()
	
	GameManager.enemies_count +=1
	queue_free()
	

func drop_item():
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_drop_item():
	if drop_itens.size() == 0:
		return drop_chance_array[0]
	var max_chance:float = 0.0
	for drop_chance in drop_chance_array:
		max_chance += drop_chance
		
	# jogar dado
	var random_value = randf() * max_chance
	
	#girar roleta
	var needle: float = 0
	for i in drop_itens.size():
		var drop_item = drop_itens[i]
		var drop_chance_item = drop_chance_array[i] if i < drop_chance_array.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	return drop_chance_array[0]
	
	pass
