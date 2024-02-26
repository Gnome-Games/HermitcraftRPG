extends CharacterBody2D

const MAX_SPEED = 80.0
const ACCELERATION = 300.0
const JUMP_VELOCITY = -100.0
const GRAVITY = 300.0
const DECELERATION = 300

var direction = 0
var inventory = [["air", 0], ["air", 0], ["air", 0], ["air", 0]]

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_pressed("shift"):
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
		
	else:
		set_collision_layer_value(3, true)
		set_collision_mask_value(3, true)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("right"):
		direction = 1
		$PlayerAnimation.play("WalkRight")
		velocity.x += ACCELERATION * delta
		
		if velocity.x > MAX_SPEED:
			velocity.x = MAX_SPEED
		
	elif Input.is_action_pressed("left"):
		direction = -1
		$PlayerAnimation.play("WalkLeft")
		velocity.x -= ACCELERATION * delta
		
		if velocity.x < -MAX_SPEED:
			velocity.x = -MAX_SPEED
		
	else:
		$PlayerAnimation.play("RESET")
		
		velocity.x -= DECELERATION * direction * delta
		
		if velocity.x * direction < 0:
			velocity.x = 0
		
	move_and_slide()
