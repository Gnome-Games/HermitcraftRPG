extends Node2D

const BITS = ["shaft", "tip", "funnel", "barrel", "handle", "glass", "lever_l", "lever_t", "lever_r", "lever_b"]

var row # -1 for mouse
var index # -1 for sidebar
var bit

var touchingMouse = false

@onready var tileMap = get_node("../../")

func _ready():
	
	position.y = index * get_parent().SPACING + get_parent().INITIAL_Y
	position.x = row * get_parent().SPACING + get_parent().INITIAL_X
	
	if row == -1:
		position = get_parent().get_local_mouse_position()
		
	elif index < 0:
		pass
		
	$ItemSprite.frame = BITS.find(bit)

func _process(delta):
	
	_crafting_menu_stuff()
	
	if row == -1:
		z_index = 1
		position = get_parent().get_local_mouse_position()
	
	else:
		z_index = 0
		position.y = index * get_parent().SPACING + get_parent().INITIAL_Y
		position.x = row * get_parent().SPACING + get_parent().INITIAL_X

func _crafting_menu_stuff():
	
	position.y = index * get_parent().SPACING + get_parent().INITIAL_Y
	position.x = row * get_parent().SPACING + get_parent().INITIAL_X

func _on_mouse_detecter_mouse_entered():
	touchingMouse = true

func _on_mouse_detecter_mouse_exited():
	touchingMouse = false
