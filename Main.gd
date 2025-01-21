extends Node2D

var players
var selected: int
var carlist = []
var active = true

signal camera
signal cameraMain

var bluecar = Sprite2D.new()
var yellowcar = Sprite2D.new()
var lightgreencar = Sprite2D.new()
var darkgreencar = Sprite2D.new()
var orangecar = Sprite2D.new()
var pinkcar = Sprite2D.new()
var redcar = Sprite2D.new()
var blackcar = Sprite2D.new()

var rng1 = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()

var radius: float = 5200 # Radius of the circle
var center: Vector2 = Vector2(7000, 0) # Center of the circle
var angle: float = -9 
var current_position: int = 23

func _ready():
	pass
func _process(delta):
	if players and active:
		camera.emit()
	if selected == players and carlist.size() == selected and active:
		active = false
		cameraMain.emit()
		car()
func _on_button_button_up():
	players = 2

func _on_button_2_button_up():
	players = 3

func _on_button_3_button_up():
	players = 4

func _on_button_4_button_up():
	players = 5

func car():
	var startpos =  Vector2(5699,4660)
	for i in carlist:
		match i:
			"bluecar":
				bluecar.texture = preload("res://Svart-Bil – Kopi/Lyseblå-Bil.png")
				add_child(bluecar)
				bluecar.scale = Vector2(0.3,0.3)
				bluecar.rotation_degrees = 9
				bluecar.position = startpos
			"yellowcar":
				yellowcar.texture = preload("res://Svart-Bil – Kopi/Gul-Bil.png")
				add_child(yellowcar)
				yellowcar.scale = Vector2(0.3,0.3)
				yellowcar.rotation_degrees = 9
				yellowcar.position = startpos
			"lightgreencar":
				lightgreencar.texture = preload("res://Svart-Bil – Kopi/Lysegrønn-Bil.png")
				add_child(lightgreencar)
				lightgreencar.scale = Vector2(0.3,0.3)
				lightgreencar.rotation_degrees = 9
				lightgreencar.position = startpos
			"darkgreencar":
				darkgreencar.texture = preload("res://Svart-Bil – Kopi/Mørkegrønn-Bil.png")
				add_child(darkgreencar)
				darkgreencar.scale = Vector2(0.3,0.3)
				darkgreencar.rotation_degrees = 9
				darkgreencar.position = startpos
			"orangecar":
				orangecar.texture = preload("res://Svart-Bil – Kopi/Oransje-Bil.png")
				add_child(orangecar)
				orangecar.scale = Vector2(0.3,0.3)
				orangecar.rotation_degrees = 9
				orangecar.position = startpos
			"pinkcar":
				pinkcar.texture = preload("res://Svart-Bil – Kopi/Rosa-Bil.png")
				add_child(pinkcar)
				pinkcar.scale = Vector2(0.3,0.3)
				pinkcar.rotation_degrees = 9
				pinkcar.position = startpos
			"redcar":
				redcar.texture = preload("res://Svart-Bil – Kopi/Rød-Bil.png")
				add_child(redcar)
				redcar.scale = Vector2(0.3,0.3)
				redcar.rotation_degrees = 9
				redcar.position = startpos
			"blackcar":
				blackcar.texture = preload("res://Svart-Bil – Kopi/Svart-Bil.png")
				add_child(blackcar)
				blackcar.scale = Vector2(0.3,0.3)
				blackcar.rotation_degrees = 9
				blackcar.position = startpos
		startpos -= Vector2(-80, 190)

func moveCar(car, result):
	current_position = (current_position + result) % 40
	if current_position < 0:
		current_position += 40
	print("current", current_position)
	var angle = (current_position) * (9)
	var rad_angle = deg_to_rad(angle)
	# Calculate new position
	var x = center.x + radius * cos(rad_angle+4.5)
	var y = center.y + radius * sin(rad_angle+4.5)
	# Update the position of the node
	car.position = Vector2(x, y)
	car.rotation_degrees = angle - angle*2
	print(angle)
	print(angle - angle*2)
	
func _bluecar():
	if !selected == players:
		if !carlist.has("bluecar"):
			carlist.append("bluecar")
			selected += 1
func _yellowcar():
	if !selected == players:	
		if !carlist.has("yellowcar"):
			carlist.append("yellowcar")
			selected += 1
func _lightgreencar():
	if !selected == players:
		if !carlist.has("lightgreencar"):
			carlist.append("lightgreencar")
			selected += 1
func _darkgreencar():
	if !selected == players:
		if !carlist.has("darkgreencar"):
			carlist.append("darkgreencar")
			selected += 1
func _orangecar():
	if !selected == players:
		if !carlist.has("orangecar"):
			carlist.append("orangecar")
			selected += 1
func _pinkcar():
	if !selected == players:
		if !carlist.has("pinkcar"):
			carlist.append("pinkcar")
			selected += 1
func _redcar():
	if !selected == players:
		if !carlist.has("redcar"):
			carlist.append("redcar")
			selected += 1
func _blackcar():
	if !selected == players:
		if !carlist.has("blackcar"):
			carlist.append("blackcar")
			selected += 1
			


func _on_roll_dice_button_up():
	var die1 = rng1.randi_range(1,6)
	var die2 = rng2.randi_range(1,6)
	var result = die1+die2
	print(die1," ", die2)
	print(result)
	moveCar(bluecar, result)
