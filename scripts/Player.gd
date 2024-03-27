extends CharacterBody2D

const COLLECTED_ITEM = preload("res://scenes/collected_item.tscn")
const ARM_FRAME_OFFSETS = [Vector2(-2, 1), Vector2(-1, 1), Vector2(.5, 2), Vector2(1.5, 1.5), Vector2(3, .5)]
const MAX_SPEED = 80.0
const ACCELERATION = 300.0
const JUMP_VELOCITY = -100.0
const GRAVITY = 300.0
const DECELERATION = 300
const HOTBAR_SLOTS = 4
const SWORDS = ["stone_sword", "iron_sword", "diamond_sword"]

var slot = 0
var swordCooldown = 0.0
var cursorItemOrigin = [0, 0]
var direction = 1
var cursor = ["air", 0]
var inventory = [
	[["air", 0], ["air", 0], ["air", 0], ["air", 0]],
	[["air", 0], ["air", 0], ["air", 0], ["air", 0]]]

var crafting = false

func _physics_process(delta):
		
	_update_slot()
	
	_move(delta)
	
	_animate_arms(delta)

func _update_hotbar():
	
	$HotBar.inventory = [[null, null, null, null, ],[null, null, null, null, ]]
	
	for child in $HotBar.get_children():
		
		if child.name != "SelectedSlot" and child.name != "MouseDetecter":
			
			if child.row != -1:
				child.queue_free()
	
	for row in range(inventory.size()):
		
		for index in range(inventory[row].size()):
			
			if inventory[row][index] != ["air", 0]:
				var item = COLLECTED_ITEM.instantiate()
				item.index = index
				item.row = row
				item.item = inventory[row][index][0]
				$HotBar.inventory[row][index] = item
				$HotBar.add_child(item)

func _update_slot():
	
	if Input.is_action_just_pressed("one"):
		slot = 0
		
	elif Input.is_action_just_pressed("two"):
		slot = 1
		
	elif Input.is_action_just_pressed("three"):
		slot = 2
		
	elif Input.is_action_just_pressed("four"):
		slot = 3

func _animate_arms(delta):   
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		$BackArmAnimation.play("Walk")
		$BackArmAnimation.seek($LegsAnimation.current_animation_position)
	
	else:
		$BackArmAnimation.play("RESET")
	
	if SWORDS.has(inventory[0][slot][0]):
		
		if swordCooldown > 0:
			$FrontArmAnimation.play("SwordCooldown")
			swordCooldown -= delta
			
			if swordCooldown < 0:
				swordCooldown = 0.0
			
	elif Input.is_action_pressed("click") and !$HotBar.mouseInInventory and !crafting:
		$FrontArmAnimation.play("Action")
		
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		$FrontArmAnimation.play("Walk")
		$FrontArmAnimation.seek($LegsAnimation.current_animation_position)
		
	else:
		$FrontArmAnimation.play("RESET")
	
	if inventory[0][slot][0] == "invention":
		$Torso/FrontArm/HeldInvention.blueprint = $HotBar.inventory[0][slot].blueprint
		$Torso/FrontArm/HeldInvention._update()
		$Torso/FrontArm/HeldInvention.show()
		$FrontArmAnimation.play("Holding")
		$Torso/FrontArm.flip_h = false
		
	
	else:
		$Torso/FrontArm.flip_h = true
		$Torso/FrontArm/HeldInvention.hide()

func _move(delta):
	
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
			$LegsAnimation.play("RESET")
			$FrontArmAnimation.play("RESET")
			$BackArmAnimation.play("RESET")
			$Torso.scale.x = 1
		
		direction = 1
		$LegsAnimation.play("Walk")
		velocity.x += ACCELERATION * delta
		
		if velocity.x > MAX_SPEED:
			velocity.x = MAX_SPEED
		
	elif Input.is_action_pressed("left"):
		
		if direction == 1:
			$LegsAnimation.play("RESET")
			$BackArmAnimation.play("RESET")
			$FrontArmAnimation.play("RESET")
			$Torso.scale.x = -1
			
		direction = -1
		$LegsAnimation.play("Walk")
		velocity.x -= ACCELERATION * delta
		
		if velocity.x < -MAX_SPEED:
			velocity.x = -MAX_SPEED
		
	else:
		$LegsAnimation.play("RESET")
		velocity.x -= DECELERATION * direction * delta
		
		if velocity.x * direction < 0:
			velocity.x = 0
	
	move_and_slide()
