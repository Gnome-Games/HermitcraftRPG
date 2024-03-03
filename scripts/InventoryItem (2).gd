extends Sprite2D

const NUMBER = preload("res://scenes/big_number.tscn")
const NUMBER_Y = 4
const NUMBER_X_INT = 5
const NUMBER_SPACING = -4
const ITEM_Y_INT = 51
const ITEM_Y_SPACING = -18
const ITEM_X_INT = -27
const ITEM_X_SPACING = 18
const ITEMS = ["grass", "dirt", "sand", "gravel", "stone", "coal_ore", "iron_ore", "diamond_ore", "leaves", "log", "stripped_log", "plank", "crafting_table", "barrel", "post", "glass", "flint", "coal", "diamond", "apple", "sapling", "stone_sword", "iron_sword", "diamond_sword"]

var touchingMouse = false

var origin
var item
var count
var row # -1 for mouse
var index
var swap = false

@onready var player = get_node("../../../../")

func _ready():
	_update_count()
	frame = ITEMS.find(item)

func _process(delta):
	
	if row == -1:
		z_index = 1
		position = get_parent().get_local_mouse_position()
		
	else:
		z_index = 0
		position = Vector2(ITEM_X_INT + ITEM_X_SPACING * index, ITEM_Y_INT + ITEM_Y_SPACING * row)

func _update_count():
	
	for child in get_children():
		
		if child.name != "CursorDetector":
			child.queue_free()
	
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
