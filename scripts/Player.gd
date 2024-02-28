extends CharacterBody2D

const COLLECTED_ITEM = preload("res://scenes/collected_item.tscn")
const ARM_FRAME_OFFSETS = [Vector2(-2, 1), Vector2(-1, 1), Vector2(.5, 2), Vector2(1.5, 1.5), Vector2(3, .5)]
const MAX_SPEED = 80.0
const ACCELERATION = 300.0
const JUMP_VELOCITY = -100.0
const GRAVITY = 300.0
const DECELERATION = 300
const HOTBAR_SLOTS = 4

var cursorItemOrigin = [0, 0]
var direction = 1
var cursor = ["air", 0]
var inventory = [[["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0]],
	[["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0]],
	[["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0]],
	[["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0], ["air", 0]]]
var move = true

func _physics_process(delta):
		
	if move:
		_update_move(delta)
		
	if Input.is_action_just_pressed("inventory"):
		
		if move:
			move = false
			$Camera/Menu._display_inventory()
			
		else:
			move = true
			$Camera/Menu._hide_inventory()
			cursor = ["air", 0]

func _update_move(delta):
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_pressed("shift"):
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
		
	else:
		set_collision_layer_value(3, true)
		set_collision_mask_value(3, true)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("right"):
		
		if direction == -1:
			$ArmsAnimation.play("RESET")
		
		direction = 1
		$LegsAnimation.play("WalkRight")
		velocity.x += ACCELERATION * delta
		
		if velocity.x > MAX_SPEED:
			velocity.x = MAX_SPEED
		
	elif Input.is_action_pressed("left"):
		
		if direction == 1:
			$ArmsAnimation.play("RESET")
			
		direction = -1
		$LegsAnimation.play("WalkLeft")
		velocity.x -= ACCELERATION * delta
		
		if velocity.x < -MAX_SPEED:
			velocity.x = -MAX_SPEED
		
	else:
		$LegsAnimation.play("RESET")
		
		velocity.x -= DECELERATION * direction * delta
		
		if velocity.x * direction < 0:
			velocity.x = 0
		
	if Input.is_action_pressed("click"):
		
		if direction == 1:
			$ArmsAnimation.play("ActionRight")
			
		else:
			
			if Input.is_action_pressed("left"):
				
				$ArmsAnimation.play("ActionLeftMove")
				$ArmsAnimation.seek($LegsAnimation.get_current_animation_position())
				
			else:
				$ArmsAnimation.play("ActionLeftStill")
		
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		$ArmsAnimation.play("Walk")
		$ArmsAnimation.seek($LegsAnimation.get_current_animation_position())
		
	else:
		$ArmsAnimation.play("RESET")
	
	move_and_slide()

func _update_hotbar():
	
	for child in $HotBar.get_children():
		
		if child.name != "SelectedSlot":
			
			child.queue_free()
	
	for index in range(HOTBAR_SLOTS):
		
		if inventory[0][index] != ["air", 0]:
			var item = COLLECTED_ITEM.instantiate()
			item.slot = index
			$HotBar.add_child(item)
