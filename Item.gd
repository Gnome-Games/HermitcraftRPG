extends CharacterBody2D

const LOOP_TIME = 3000.0
const LOOP_DISTANCE = 10.0
const GRAVITY = 300.0

func _process(delta):
	_move_sprite()
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		velocity.y = 0
		
	move_and_slide()

func _move_sprite():
	$ItemSprite.position.y = _ease_in_out_sin(fmod(Time.get_ticks_msec(), LOOP_TIME) / LOOP_TIME - .5) * LOOP_DISTANCE - LOOP_DISTANCE / 1.9

func _ease_in_out_sin(progress):
	return( -(cos(PI * progress) - 1) / 2)
