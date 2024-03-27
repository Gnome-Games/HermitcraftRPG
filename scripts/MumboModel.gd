extends Node3D

const WINDOW_OFFSET =  Vector2(26.5, 4)
const EYES_OFFSET = Vector3(0, -60, 0)
var head

func _ready():
	translate(Vector3(0, 1, 0))
	$Node.translate(Vector3(0, -1, 0))
	head = $Node/Head2

func _process(delta):
	var mousePos = get_node("../../../").get_local_mouse_position() +WINDOW_OFFSET
	look_at(Vector3(mousePos.x, -mousePos.y, 600.75))
	head.look_at(Vector3(mousePos.x, -mousePos.y, 50.75) + EYES_OFFSET)
