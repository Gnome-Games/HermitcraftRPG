extends Node2D

const INITIAL_X = -13
const ITEM_SPACING = 9
const NUMBER = preload("res://scenes/number.tscn")
const NUMBER_Y = 2
const INITIAL_NUMBER_X = 2
const NUMBER_SPACING = -3

var slot
var count

@onready var tileMap = get_node("../../../TileMap")

func _ready():
	position.x = slot * ITEM_SPACING + INITIAL_X
	var itemFrame = tileMap.BLOCK_FRAME.find(tileMap.inventory[0][slot][0])
	var atlas_y = floor( itemFrame / 8)
	var atlas_x = itemFrame - atlas_y * 8
	$ItemSprite.frame = atlas_y * 30 + atlas_x * 2

func _process(delta):
	count = tileMap.inventory[0][slot][1]
	
	if count == 0:
		queue_free()
		
	_update_count()

func _update_count():
	
	for child in get_children():
		
		if child.name != "ItemSprite":
			
			child.queue_free()
	
	for character_index in range(str(count).length()):
		var character = str(count).reverse()[character_index]
		var number = NUMBER.instantiate()
		number.frame = int(character)
		number.position = Vector2(INITIAL_NUMBER_X + NUMBER_SPACING * character_index, NUMBER_Y)
		add_child(number)
