extends KinematicBody2D

var normal_walk = 200
var dash = 800
var walk = normal_walk
var run = 400
var speed = Vector2.ZERO
var walk_jump = -500
var gravity = 18
var soul = 0
var hurting = false
var health_max = 200
var health = 200

onready var sprite = $AnimatedSprite

signal soul_update(value)
signal hero_update_health(value)
signal hero_death
signal hero_win

#action
func _physics_process(delta):
	speed.y = speed.y + gravity
	
	if(not hurting and Input.is_action_pressed("move_right")):
		speed.x = walk
	if(not hurting and Input.is_action_pressed("move_left")):
		speed.x = -walk
	
	if(not hurting and Input.is_action_pressed("move_jump") and is_on_floor()):
		speed.y = walk_jump
	
	if(not hurting and Input.is_action_just_pressed("dash")):
		dash()
	if(not hurting and Input.is_action_pressed("run")):
		run()
	
	speed.x = lerp(speed.x, 0, 0.2)
	speed = move_and_slide(speed, Vector2.UP)
	
	if not hurting:
		update_animation()

#animate action
func update_animation():
	if is_on_floor():
		if speed.x < (walk * 0.5) and speed.x > (-walk * 0.5):
			sprite.play("idle")
		else:
			if walk == normal_walk:
				sprite.play("walk")
			elif walk == dash:
				sprite.play("dash")
			elif walk == run:
				sprite.play("run")
	else:
		if speed.y > 0:
			#fall
			sprite.play("fall")
		else:
			#jump
			sprite.play("jump")
	
	sprite.flip_h = false
	if speed.x < 0:
		sprite.flip_h = true

#Dash
func dash():
	walk = dash
	$Timer.start()
func _on_Timer_timeout():
	walk = normal_walk

#run 
func run():
	speed.x = run
	if(Input.is_action_pressed("move_left")):
		speed.x = -run

#get item
func get_soul():
	soul = soul + 1
#	print("Soul: ", soul)
	emit_signal("soul_update", soul)
	#check soul number
	var soul_group = get_tree().get_nodes_in_group("lvsoul")
	var soul_amount = soul_group.size()
#	print("GROUP soul: ", soul_group)
#	print("amoun soul: ", soul_amount)
	if soul_amount == 0:
		emit_signal("hero_win")
		

func hurt():
	hurting = true
	
	health -= 15
	emit_signal("hero_update_health", (float(health)/float(health_max )) * 100)
	
	if speed.x > 0:
		speed.x = -1000
	else:
		speed.x = 1000
	
	sprite.play("takehit")
	yield(get_tree().create_timer(0.5), "timeout")
	
	if health <= 0:
		dead()
	else:	
		hurting = false

func dead():
	sprite.play("death")
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(2, false)
	set_collision_mask_bit(3, false)
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("hero_death")
	
