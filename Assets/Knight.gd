extends KinematicBody2D


var speed = Vector2.ZERO
var run = 100
var gravity = 18
export var direction = 1

var hurting = false

onready var pivot = $Pivot
onready var raycast = $Pivot/RayCast2D

export var health = 4

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	speed.y += gravity
	
	if is_on_wall() or not raycast.is_colliding():
		direction = direction * -1
		pivot.scale.x = pivot.scale.x * -1
	
	speed.x = run * direction
	
	if not hurting:
		speed = move_and_slide(speed, Vector2.UP)
	
	if not hurting:
		_update_animation()

func _update_animation():
	if is_on_floor():
		$AnimatedSprite.play("run")
#	else:
	#	$AnimatedSprite.play("teleport")
	$AnimatedSprite.flip_h = true
	if direction == 1:
		$AnimatedSprite.flip_h = false


func _on_hitbox_body_entered(body):
	if body.name == 'Player':
		body.hurt()


func _on_hurtbox_body_entered(body):
	if body.name == 'Player' and not hurting and health > 0:
		body.speed.y = -500
		enemy_hurt()

func enemy_hurt():
	health -= 1
	hurting = true
	$AnimatedSprite.play('hurt')
	yield(get_tree().create_timer(0.5), "timeout")
	if health <=0:
		dead()
	else:
		hurting = false

func dead():
	$AnimatedSprite.play("dead")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	$hitbox.set_collision_layer_bit(2, false)
	$hitbox.set_collision_mask_bit(0, false)
	$hurtbox.set_collision_layer_bit(2, false)
	$hurtbox.set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("disappear")

func delete():
	queue_free()
