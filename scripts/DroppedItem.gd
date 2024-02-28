extends CharacterBody2D

const LOOP_TIME = 3000.0
const LOOP_DISTANCE = 10.0
const GRAVITY = 300.0

var itemFrame
var startTime

func _ready():
	
	startTime = Time.get_ticks_msec()
	$ItemSprite.frame = itemFrame

func _process(delta):
	_move_sprite()
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		velocity.y = 0
		
	move_and_slide()

func _move_sprite():
	$ItemSprite.position.y = _ease_in_out_sin(fmod(Time.get_ticks_msec() - startTime, LOOP_TIME) / LOOP_TIME - .5) * LOOP_DISTANCE - LOOP_DISTANCE / 1.9

func _ease_in_out_sin(progress):
	return( -(cos(PI * progress) - 1) / 2)

func _on_item_pickup_body_entered(body):
	
	var atlas_y = floor(itemFrame / 30)
	var atlas_x = (itemFrame - atlas_y * 30) / 2
	var blockFrame = atlas_x + atlas_y * 8
	
	for slotIndex in range(body.inventory.size()):
		var slot = body.inventory[0][slotIndex]
		
		if slot[0] == get_parent().BLOCK_FRAME[blockFrame] and slot[1] < get_parent().STACK_SIZE[blockFrame]:
			body.inventory[0][slotIndex][1] += 1
			queue_free()
			break
			
		elif slot[0] == "air":
			
			body.inventory[0][slotIndex] = [get_parent().BLOCK_FRAME[blockFrame], 1]
			get_node("../../Player")._update_hotbar()
			queue_free()
			break
