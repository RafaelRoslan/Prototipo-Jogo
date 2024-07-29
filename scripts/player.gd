class_name Player

extends CharacterBody2D
@export_category("Movement")
@export var speed:float = 3
@export_category("Damage")
@export var sword_damage:float = 1
@export_category("Life Player")
@export var maxHp:int = 20
@export var hp:int = 20
@export var dead_prefab:PackedScene
@export_category("Ability")
@export var ability_damage:int = 2
@export var ability_interval:float = 15
@export var ability_scene:PackedScene 




@onready var sprite:Sprite2D = $Sprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sword_area:Area2D = $SwordArea
@onready var hitbox_area:Area2D = $HitBox
@onready var hp_progress_bar:ProgressBar = $ProgressBar

var input_vector:Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking:bool = false
var attack_cooldown:float = 0.0
var hitbox_cooldown:float = 0.0
var magic_cooldown:float = 15

signal meat_collect(value:int)

func _ready():
	GameManager.player = self
	meat_collect.connect(func(value:int):GameManager.meat_counter+=1)

#equivalente ao Update
func _process(delta: float):
	GameManager.player_position = position
	read_input()
	update_attack_cooldown(delta)
	play_animation_idle_run()
	if not is_attacking:
		flip_sprite()
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	#processar dano
	update_hitbox(delta)
	
	#magia
	update_magic(delta)
	
	#atualizar progress bar
	hp_progress_bar.max_value = maxHp
	hp_progress_bar.value = hp
	
	
	pass

#Funcao similar ao FixedUpdate
func _physics_process(delta:float):
		#modfica a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.1
	velocity = lerp(velocity,target_velocity,0.5)
	#executa a movimentacao
	move_and_slide()
	
	pass

#ler o input
func read_input():
	#recebe o input(o ultimo valor é o deadline que define no joystick o valor minimo que ele deve ignorar
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	
	#apagar o deadzone
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	
	#atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	pass

func update_attack_cooldown(delta:float):
	#atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
	pass

func play_animation_idle_run():
	#tocar animacao
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	pass

func flip_sprite():
	#girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
	
	pass

#funcao attack
func attack():
	if is_attacking:
		return
	
	#tomar animacao
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	
	is_attacking = true
	pass

func deal_damage():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction:Vector2
			
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction =  Vector2.RIGHT
			
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product > 0.3:
				enemy.damage(sword_damage)

	pass


func damage(amount:int):
	if hp <=0: return
	
	hp -= amount
	print("Jogador recebeu ", amount, " de dano.HP:",hp,"/",maxHp)
	
	#piscar node
	modulate = Color.RED
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate",Color.WHITE,0.3)
	
	if hp <= 0:
		die()

func die():
	GameManager.end_game()
	if dead_prefab:
		var death_obj = dead_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
		
	queue_free()
	

func update_hitbox(delta):
	#temporizador
	hitbox_cooldown -=delta
	if hitbox_cooldown > 0 : return
	
	#frequencia
	hitbox_cooldown = 0.5
	
	#detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy = body
			var damage_amount = 1
			damage(damage_amount)
	pass

func heal(amount:int):
	hp += amount
	if(hp > maxHp):
		hp = maxHp
		
	print("Jogador  curou ", amount, " de vida.HP:",hp,"/",maxHp)
	return hp
	

func update_magic(delta):
	magic_cooldown -=delta
	if magic_cooldown > 0: return
	
	magic_cooldown = ability_interval
	
	var magic = ability_scene.instantiate()
	magic.damage_amount = ability_damage
	add_child(magic)
	
	
	
	pass

