extends TileMap

const INITIAL_X = -13
const ITEM_SPACING = 9
const STACK_SIZE = [64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 1, 8, 64, 64, 64, 64, 64, 64, 64, 1, 1, 1]
const BLOCK_LAYER = [1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 2, 2]
const BLOCK_FRAME = ["grass", "dirt", "sand", "gravel", "stone", "coal_ore", "iron_ore", "diamond_ore", "leaves", "log", "stripped_log", "planks", "crafting_table", "barrel", "post", "glass"]
const BLOCK_DROPS = {"grass": ["dirt"], "gravel": ["gravel", "gravel", "flint"], "coal_ore": ["coal"], "diamond_ore": ["diamond"], "leaves": [ "apple", "sapling", "sapling", "air", "air", "air", "air"], "glass": ["air"]}
const PLACEABLE_ITEMS = ["grass", "dirt", "sand", "gravel", "stone", "coal_ore", "iron_ore", "diamond_ore", "leaves", "log", "stripped_log", "planks", "crafting_table", "barrel", "post", "glass"]
const DROPPED_ITEM = preload("res://scenes/dropped_item.tscn")
const BREAK_DURATION = [.5, .5, .5, .5, 1.5, 1.5, 2, 2.5, .4, .8, .8, .8, .8, .8, .8, .3]
const LAYERS = 3
const BLOCK_SPACING = 12.0

var cursorObstructions = 0
var miningStart = 0
var breakTime = 0
var breakTimeGoal = 0
var mining = false
var target = Vector2i(0, 0)
var slot = 0
var move

@onready var inventory = get_node("../Player").inventory

func _process(delta):
	
	move = get_node("../Player").move
	
	_update_slot()
	
	if target != local_to_map(get_local_mouse_position()):
		
		target = local_to_map(get_local_mouse_position())
		miningStart = Time.get_ticks_msec()
		
	_update_player_sight()
	
	if move:
	
		if Input.is_action_just_pressed("right_click") and cursorObstructions == 0:
			mining = false
			var topLayer = 0
			
			for layer in range(LAYERS):
				
				if get_cell_tile_data(layer * -1 + LAYERS - 1, target) != null:
					topLayer = layer * -1 + LAYERS - 1
					break
			
			var targetAtlas = get_cell_atlas_coords(topLayer, target)
			
			if targetAtlas == Vector2i(-1, -1) and PLACEABLE_ITEMS.has(inventory[0][slot][0]):
				inventory[0][slot][1] = inventory[0][slot][1] - 1
				
				var atlasY = floor(BLOCK_FRAME.find(inventory[0][slot][0]) / 8)
				var atlasX = BLOCK_FRAME.find(inventory[0][slot][0]) - 8 * floor(BLOCK_FRAME.find(inventory[0][slot][0]) / 8)
				var atlasCoords = Vector2i(atlasX, atlasY)
				
				set_cell(BLOCK_LAYER[BLOCK_FRAME.find(inventory[0][slot][0])], target, 1, atlasCoords)
				
				if inventory[0][slot][1] == 0:
					inventory[0][slot][0] = "air"
		
		if Input.is_action_just_pressed("click"):
			miningStart = Time.get_ticks_msec()
			mining = true
		
		if Input.is_action_just_released("click"):
			mining = false
			
		if mining:
			var topLayer = 0
			for layer in range(LAYERS):
				
				if get_cell_tile_data(layer * -1 + LAYERS - 1, target) != null:
					topLayer = layer * -1 + LAYERS - 1
					break
			
			var targetAtlas = get_cell_atlas_coords(topLayer, target)
			breakTime = Time.get_ticks_msec() - miningStart
			breakTimeGoal = BREAK_DURATION[targetAtlas.x + targetAtlas.y * 8] * 1000
			
			if get_cell_atlas_coords(topLayer, target) == Vector2i(-1, -1):
				miningStart = Time.get_ticks_msec()
			
			if breakTime > breakTimeGoal:
				
				set_cell(topLayer, target, -1)
				miningStart = Time.get_ticks_msec()
				
				var item = DROPPED_ITEM.instantiate()
				item.item = BLOCK_FRAME[targetAtlas.x + targetAtlas.y * 8]

				if BLOCK_DROPS.keys().has(item.item):
					item.item = BLOCK_DROPS[item.item].pick_random()
				
				item.position = target * BLOCK_SPACING
				
				if item.item != "air":
					add_child(item)
			

func _update_player_sight():
	$PlayerCursor.position = round(get_local_mouse_position() / BLOCK_SPACING - Vector2(.5, .5)) * BLOCK_SPACING + Vector2(BLOCK_SPACING / 2, BLOCK_SPACING / 2)
	
	if mining:
		$PlayerCursor.frame = floor(breakTime * 8/ breakTimeGoal) + 1
	
	else:
		$PlayerCursor.frame = 0

func _update_slot():
	
	if Input.is_action_just_pressed("one"):
		slot = 0
		
	elif Input.is_action_just_pressed("two"):
		slot = 1
		
	elif Input.is_action_just_pressed("three"):
		slot = 2
		
	elif Input.is_action_just_pressed("four"):
		slot = 3
	
	get_node("../Player/HotBar/SelectedSlot").position.x = INITIAL_X + ITEM_SPACING * slot


func _on_mob_detecter_body_entered(body):
	cursorObstructions += 1

func _on_mob_detecter_body_exited(body):
	cursorObstructions -= 1
