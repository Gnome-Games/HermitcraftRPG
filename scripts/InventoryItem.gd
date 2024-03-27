extends Node2D

const ITEM = preload("res://scenes/collected_item.tscn")
const INITIAL_Y = 0
const ITEM_Y_SPACING = -9
const INITIAL_X = -13
const ITEM_X_SPACING = 9

var mouseInInventory = false
var inventory = [[null, null, null, null, ],[null, null, null, null, ]]
var mouseItem = null

func _physics_process(delta):
	
	if Input.is_action_just_pressed("right_click") and mouseInInventory:
		
		var row = round((get_local_mouse_position().y - INITIAL_Y) / ITEM_Y_SPACING)
		var index = round((get_local_mouse_position().x - INITIAL_X) / ITEM_X_SPACING)
		
		
		if mouseItem == null and inventory[row][index] != null:
			
			if inventory[row][index].item != "invention":
				var newItem = ITEM.instantiate()
				newItem.item = inventory[row][index].item
				newItem.count = floor(inventory[row][index].count / 2)
				newItem.row = -1
				newItem.index = 0
				mouseItem = newItem
				inventory[row][index].count = ceil(float(inventory[row][index].count) / 2)
				inventory[row][index]._update_count()
				get_node("../").inventory[row][index][1] = ceil(inventory[row][index].count)
				add_child(newItem)

		
		elif mouseItem == null:
			pass
			
		elif inventory[row][index] == null:
			
			if mouseItem.item != "invention":
				mouseItem.count -= 1
				mouseItem._update_count()
				
				var newItem = ITEM.instantiate()
				newItem.item = mouseItem.item
				newItem.count = 1
				newItem.row = row
				newItem.index = index
				inventory[row][index] = newItem
				get_node("../").inventory[row][index] = [mouseItem.item, 1]
				add_child(newItem)
				
				if mouseItem.count == 0:
					mouseItem.queue_free()
					mouseItem = null
			
		elif mouseItem.item != "invention":
			
			if mouseItem.item == inventory[row][index].item and inventory[row][index].count < 64:
				mouseItem.count -= 1
				inventory[row][index].count += 1
				mouseItem._update_count()
				inventory[row][index]._update_count()
				get_node("../").inventory[row][index][1] += 1
			
				if mouseItem.count == 0:
					mouseItem.queue_free()
					mouseItem = null

	if Input.is_action_just_pressed("click") and mouseInInventory:
		
		var row = round((get_local_mouse_position().y - INITIAL_Y) / ITEM_Y_SPACING)
		var index = round((get_local_mouse_position().x - INITIAL_X) / ITEM_X_SPACING)
		
		if inventory[row][index] == null:
			
			if mouseItem != null:
				get_node("../").inventory[row][index] = [mouseItem.item, mouseItem.count]
				inventory[row][index] = mouseItem
				mouseItem.row = row
				mouseItem.index = index
				mouseItem = null
			
		else:
			
			var transitioningItem = inventory[row][index]
			get_node("../").inventory[row][index] = ["air", 0]
			
			if mouseItem != null:
				
				if transitioningItem.item == mouseItem.item and mouseItem.item != "invention":
					var total = transitioningItem.count + mouseItem.count
					
					if total <  64:
						mouseItem.count = total
						transitioningItem.queue_free()
						transitioningItem = null
						mouseItem._update_count()
						
					else:
						mouseItem.count = 64
						transitioningItem.count = total - 64
						mouseItem._update_count()
						transitioningItem._update_count()
					
				get_node("../").inventory[row][index] = [mouseItem.item, mouseItem.count]
				mouseItem.row = row
				mouseItem.index = index
			
			inventory[row][index] = mouseItem
			mouseItem = transitioningItem
			
			if transitioningItem != null:
				mouseItem.row = -1
			

func _on_mouse_detecter_mouse_entered():
	mouseInInventory = true

func _on_mouse_detecter_mouse_exited():
	mouseInInventory = false
