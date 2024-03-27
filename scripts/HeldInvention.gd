extends Node2D

const TB = preload("res://scenes/large_tid_bit.tscn")
const TB_TO_FRAME = ["barrel", "funnel", "glass_sole", "glass_top", "glass_center", "glass_bottom", "air", "tip", "handle", "shaft_sole", "shaft_left", "shaft_center", "shaft_right", "air", "lever_right_off", "lever_right_on", "lever_down_off", "lever_down_on", "lever_up_off", "lever_up_on", "lever_left_on", "lever_left_off"]
const TB_INIT = Vector2(8, -2.5)
const TB_SPACING = 3

var handlePos

var blueprint = [
	[null, null, null, null], 
	[null, null, null, null], 
	[null, null, null, null], 
	[null, null, null, null]]

func _update():
	
	for child in get_children():
		child.queue_free()
	
	for row in range(blueprint.size()):
		
		for index in range(blueprint[row].size()):
			
			if blueprint[row][index] == "handle":
				handlePos = Vector2(row, index) * TB_SPACING
				
			if blueprint[row][index] != null:
				var tidBit = TB.instantiate()
				
				if blueprint[row][index] == "shaft":
					
					if blueprint[row - 1][index] != "shaft" and blueprint[row + 1][index] != "shaft":
						tidBit.frame = TB_TO_FRAME.find("shaft_sole")
					
					elif blueprint[row - 1][index] != "shaft":
						tidBit.frame = TB_TO_FRAME.find("shaft_left")
						
					elif blueprint[row + 1][index] != "shaft":
						tidBit.frame = TB_TO_FRAME.find("shaft_right")
					
					else:
						tidBit.frame = TB_TO_FRAME.find("shaft_center")
					
				else:
					tidBit.frame = TB_TO_FRAME.find(blueprint[row][index])
				
				tidBit.position = TB_INIT + Vector2(row * TB_SPACING, index * TB_SPACING)
				add_child(tidBit)
	
	position = -handlePos
