extends Node2D

const ITEM = preload("res://scenes/inventory_item.tscn")
const BLOCK_FRAME = ["grass", "dirt", "sand", "gravel", "stone", "coal_ore", "iron_ore", "diamond_ore", "leaves", "log", "stripped log", "planks", "crafting table", "barrel", "rod", "glass"]

var mouseInInventory = false

@onready var inventory = get_node("../../").inventory

func _hide_inventory():
	hide()
	
	for item in $Inventory.get_children():
		item.queue_free()
		
func _display_inventory():
	show()
	
	for row in range(inventory.size()):
		
		for index in range(inventory[row].size()):
			var slot_data = inventory[row][index]
			
			if slot_data[0] != "air":
				var item = ITEM.instantiate()
				
				var itemFrame = BLOCK_FRAME.find(slot_data[0])
				var frameY = floor(itemFrame / 8)
				var frameX = itemFrame - 8 * frameY
				item.frame = frameX * 2 + frameY * 30
				item.slotRow = row
				item.slotIndex = index
				item.item = slot_data[0]
				item.count = slot_data[1]
				
				$Inventory.add_child(item)
				


func _on_mouse_detecter_mouse_entered():
	mouseInInventory = true

func _on_mouse_detecter_mouse_exited():
	mouseInInventory = false
