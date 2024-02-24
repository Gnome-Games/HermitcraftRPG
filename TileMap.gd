extends TileMap

const BREAK_DURATION = [.5, .5, .5, .5, 1.5, 1.5, 2, 2.5, .4, .8, .8, .8, .8, .8, .8, .3]
const LAYERS = 3
const BLOCK_PIXELS = 12

var miningStart = 0
var breakTime = 0
var breakTimeGoal = 0
var mining = false

func _process(delta):
	_update_player_sight()
	
	if Input.is_action_just_pressed("click"):
		miningStart = Time.get_ticks_msec()
		mining = true
		
	if Input.is_action_just_released("click"):
		mining = false
		
	if mining:
		var topLayer = 0
		for layer in range(LAYERS):
			
			if get_cell_tile_data(layer * -1 + LAYERS - 1, local_to_map(get_local_mouse_position())) != null:
				topLayer = layer * -1 + LAYERS - 1
				break
		
		var targetAtlas = get_cell_atlas_coords(topLayer, local_to_map(get_local_mouse_position()))
		breakTime = Time.get_ticks_msec() - miningStart
		breakTimeGoal = BREAK_DURATION[targetAtlas.x + targetAtlas.y * 8] * 1000
		
		if get_cell_atlas_coords(topLayer, local_to_map(get_local_mouse_position())) == Vector2i(-1, -1):
			miningStart = Time.get_ticks_msec()
		
		if breakTime > breakTimeGoal:
			
			set_cell(topLayer, local_to_map(get_local_mouse_position()), -1)
			miningStart = Time.get_ticks_msec()
		

func _update_player_sight():
	$PlayerCursor.position = round(get_local_mouse_position() / BLOCK_PIXELS - Vector2(.5, .5)) * BLOCK_PIXELS + Vector2(BLOCK_PIXELS / 2, BLOCK_PIXELS / 2)
	
	if mining:
		$PlayerCursor.frame = floor(breakTime * 8/ breakTimeGoal) + 1
	
	else:
		$PlayerCursor.frame = 0
