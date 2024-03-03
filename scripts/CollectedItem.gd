extends Node2D

const INITIAL_X = -13
const ITEM_SPACING = 9
const NUMBER = preload("res://scenes/number.tscn")
const NUMBER_Y = 2
const INITIAL_NUMBER_X = 2
const NUMBER_SPACING = -3
const ITEMS = ["grass", "dirt", "sand", "gravel", "stone", "coal_ore", "iron_ore", "diamond_ore", "leaves", "log", "stripped_log", "plank", "crafting_table", "barrel", "post", "glass", "flint", "coal", "diamond", "apple", "sapling", "stone_sword", "iron_sword", "diamond_sword"]
var slot
var count

@onready var tileMap = get_node("../../../TileMap")

func _ready():
	position.x = slot * ITEM_SPACING + INITIAL_X
	$ItemSprite.frame = ITEMS.find(tileMap.inventory[0][slot][0])

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
