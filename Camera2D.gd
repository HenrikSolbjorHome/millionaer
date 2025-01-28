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

func _on_node_2d_camera():   # bil
	position = Vector2(-42267, -12983.656)
	set_zoom(Vector2(0.22, 0.22))

func _on_node_2d_camera_main():
	position = Vector2(0, 0)
	set_zoom(Vector2(0.08, 0.08))

func _on_play_button_up(): #play
	position = Vector2(10034.001, -42777)
	set_zoom(Vector2(0.14, 0.14))
