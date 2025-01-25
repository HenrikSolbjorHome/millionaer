extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#-42498
#-13478
#0.1

#-23936
#-13675
#0.14

#-24085
#-13675
#0.22

func _on_node_2d_camera():
	position = Vector2(-24095.5, 1500)
	set_zoom(Vector2(0.22, 0.22))

func _on_node_2d_camera_main():
	position = Vector2(0, 0)
	set_zoom(Vector2(0.08, 0.08))

func _on_play_button_up():
	position = Vector2(-23936, -13675)
	set_zoom(Vector2(0.14, 0.14))
