extends Node2D

@onready var brett = $Polygon2D



# Called when the node enters the scene tree for the first time.
func _ready():
	var radius = 100  # Radius på sirkelen
	var segments = 64  # Antall segmenter (jo flere, desto jevnere sirkel)
	var points = []
	
	# Generer punktene for sirkelen
	for i in range(segments):
		var angle = (PI * 2 / segments) * i
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))

	# Definer polygonens punkter
	brett = points
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
