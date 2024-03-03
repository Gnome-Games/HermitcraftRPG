extends Node2D

const ITEM = preload("res://scenes/inventory_item.tscn")
const ITEM_Y_INT = 51
const ITEM_Y_SPACING = -18
const ITEM_X_INT = -27
const ITEM_X_SPACING = 18

var mouseInInventory = false
var inventory = []
var mouseItem = null

func _physics_process(delta):
	
	if Input.is_action_just_pressed("right_click") and mouseInInventory and visible:
		
		var row = round((get_local_mouse_position().y - ITEM_Y_INT) / ITEM_Y_SPACING)
		var index = round((get_local_mouse_position().x - ITEM_X_INT) / ITEM_X_SPACING)
		
		if mouseItem == null and inventory[row][index] != null:
			var newItem = ITEM.instantiate()
			newItem.item = inventory[row][index].item
			newItem.count = floor(inventory[row][index].count / 2)
			newItem.row = -1
			newItem.index = 0
			mouseItem = newItem
			$Inventory.add_child(newItem)
			inventory[row][index].count = ceil(float(inventory[row][index].count) / 2)
			inventory[row][index]._update_count()
			get_node("../../").inventory[row][index][1] = ceil(inventory[row][index].count)
			get_node("../../")._update_hotbar()
		
		elif mouseItem == null:
			pass
			
		elif inventory[row][index] == null:
			mouseItem.count -= 1
			mouseItem._update_count()
			
			var newItem = ITEM.instantiate()
			newItem.item = mouseItem.item
			newItem.count = 1
			newItem.row = row
			newItem.index = index
			inventory[row][index] = newItem
			$Inventory.add_child(newItem)
			
			get_node("../../").inventory[row][index] = [mouseItem.item, 1]
			get_node("../../").inventory[mouseItem.row][mouseItem.index][1] -= 1
			get_node("../../")._update_hotbar()
			
			if mouseItem.count == 0:
				mouseItem.queue_free()
				mouseItem = null
			
		elif mouseItem.item == inventory[row][index].item:
			mouseItem.count -= 1
			inventory[row][index].count += 1
			mouseItem._update_count()
			inventory[row][index]._update_count()
			get_node("../../").inventory[row][index][1] += 1
			get_node("../../").inventory[mouseItem.row][mouseItem.index][1] -= 1
			get_node("../../")._update_hotbar()
			
			if mouseItem.count == 0:
				mouseItem.queue_free()
				mouseItem = null
	
	if Input.is_action_just_pressed("click") and mouseInInventory and visible:
		
		var row = round((get_local_mouse_position().y - ITEM_Y_INT) / ITEM_Y_SPACING)
		var index = round((get_local_mouse_position().x - ITEM_X_INT) / ITEM_X_SPACING)
		
		if inventory[row][index] == null:
			
			if mouseItem != null:
				get_node("../../").inventory[row][index] = [mouseItem.item, mouseItem.count]
				inventory[row][index] = mouseItem
				mouseItem.row = row
				mouseItem.index = index
				mouseItem = null
				get_node("../../")._update_hotbar()
			
		else:
			
			var transitioningItem = inventory[row][index]
			get_node("../../").inventory[row][index] = ["air", 0]
			
			if mouseItem != null:
				
				if transitioningItem.item == mouseItem.item:
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
					
				get_node("../../").inventory[row][index] = [mouseItem.item, mouseItem.count]
				mouseItem.row = row
				mouseItem.index = index
			
			inventory[row][index] = mouseItem
			mouseItem = transitioningItem
			
			if transitioningItem != null:
				mouseItem.row = -1
			
			get_node("../../")._update_hotbar()

func _hide_inventory():
	hide()
	inventory = []
	
	for item in $Inventory.get_children():
		
		if item.name != "MouseDetecter":
			item.queue_free()

func _display_inventory():
	show()
	
	for row in range(get_node("../../").inventory.size()):
		inventory.append([])
		
		for index in range(get_node("../../").inventory[row].size()):
			var slot_data = get_node("../../").inventory[row][index]
			
			if slot_data[0] != "air":
				var item = ITEM.instantiate()
				item.row = row
				item.index = index
				item.item = slot_data[0]
				item.count = slot_data[1]
				inventory[row].append(item)
				
				$Inventory.add_child(item)
			
			else:
				inventory[row].append(null)

func _on_mouse_detecter_mouse_entered():
	mouseInInventory = true

func _on_mouse_detecter_mouse_exited():
	mouseInInventory = false
