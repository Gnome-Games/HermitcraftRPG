extends Sprite2D

const NUMBER = preload("res://scenes/big_number.tscn")
const NUMBER_Y = 4
const NUMBER_X_INT = 5
const NUMBER_SPACING = -4
const ITEM_Y_INT = 51
const ITEM_Y_SPACING = -18
const ITEM_X_INT = -27
const ITEM_X_SPACING = 18

var touchingMouse = false

var origin
var item
var count
var slotRow # -1 for mouse
var slotIndex
var swap = false

@onready var player = get_node("../../../../")

func _ready():
	_load_count()

func _process(delta):
		
	if slotRow == -1:
		z_index = 1
		position = get_parent().get_local_mouse_position()
		
	else:
		z_index = 0
		position = Vector2(ITEM_X_INT + ITEM_X_SPACING * slotIndex, ITEM_Y_INT + ITEM_Y_SPACING * slotRow)
	
	if swap:
		slotIndex = round((position.x - ITEM_X_INT) / ITEM_X_SPACING)
		slotRow = round((position.y - ITEM_Y_INT) / ITEM_Y_SPACING)
		player.inventory[slotRow][slotIndex] = [item, count]
		swap = false
		get_node("../../../../")._update_hotbar()
	
	if Input.is_action_just_pressed("click") and get_node("../../").mouseInInventory:
		
		if touchingMouse and slotRow != -1:
			origin = [slotRow, slotIndex]
			player.cursorItemOrigin = origin
			
			if player.cursor == ["air", 0]:
				player.inventory[slotRow][slotIndex] = player.cursor

			
			slotRow = -1
			player.cursor = [item, count]
			
		elif slotRow == -1:
			swap = true
			
		

func _load_count():
	
	for characterIndex in range(str(count).length()):
		
		var character = str(count).reverse()[characterIndex]
		var number = NUMBER.instantiate()
		
		number.position = Vector2(NUMBER_X_INT + characterIndex * NUMBER_SPACING, NUMBER_Y)
		number.frame = int(character)
		add_child(number)


func _on_cursor_detector_mouse_entered():
	touchingMouse = true

func _on_cursor_detector_mouse_exited():
	touchingMouse = false
