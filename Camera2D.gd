extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	position = Vector2(-8717, 1459.656)
	set_zoom(Vector2(0.2, 0.2))

func _on_node_2d_camera():
	position = Vector2(-16736, 1459.656)
	set_zoom(Vector2(0.2, 0.2))

func _on_node_2d_camera_main():
	position = Vector2(7000, 0)
	set_zoom(Vector2(0.09, 0.09))
