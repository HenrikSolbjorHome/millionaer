extends Node2D

var players
var playerList = []
var selected = 0
var carlist = []
var active = true
var currentPlayer = 0
var playerPos = []
var pressed: int
var street = []

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
var current_position: int = 0


###################### Classes ######################


class player:
	var money = 150000
	var skipturns: int
	var playerPos: int
	var freePark: bool
	var cards = []
	var car
	
	func jail():
		playerPos = 11
		skipturns = 3
		
	
	
	#TODO: move function here or in card class
	
class streets:
	var streetNumber: int
	var owner: int
	
	func getStreetNumber():
		return streetNumber

class streetRow extends streets:
	var row: int
	var rowNumbers = []
	var houses: int
	var price: int
	var rent: int
	var house1: int
	var house2: int
	var house3: int
	var house4: int
	var house5: int
	var pledged: bool
	
	func _init(_owner, _streetNumber, _row, _rowNumbers, _rent, _house1, _house2, _house3, _house4, _house5, _pledged, _price):
		owner = _owner
		streetNumber = _streetNumber
		row = row
		rowNumbers = _rowNumbers
		rent = _rent
		house1 = _house1 
		house2 = _house2
		house3 = _house3
		house4 = _house4
		house5 = _house5
		pledged = _pledged
		price = _price
	func onEnter(currentPlayer, money):
		if currentPlayer != owner:
			if money >= rent:
				match houses:
					0:
						money = money-rent
					1:
						money = money-house1
					2:
						money = money-house2
					3:
						money = money-house3
					4:
						money = money-house4
					5:
						money = money-house5
		elif !owner:
			pass #TODO: try to allow for bying of streets
class streetSpecial extends streets:
	var rowNumbers = []
	var price: int
	var one: int
	var two: int
	var three: int
	var four: int
	var pledged: bool
	
	func _init(_owner, _streetNumber, _rowNumbers, _one, _two, _three, _four, _pledged, _price):
		owner = _owner
		streetNumber = _streetNumber
		rowNumbers = _rowNumbers
		one = _one
		two = _two
		three = _three
		four = _four
		pledged = _pledged
		price = _price
	
	func onEnter():
		pass #TODO: pay or buy
	
class streetAirport extends streets:
	var rowNumbers = []
	var price: int
	var one: int
	var two: int
	var pledged: bool
	
	func _init(_owner, _streetNumber, _rowNumbers, _one, _two, _pledged, _price):
		owner = _owner
		streetNumber = _streetNumber
		rowNumbers = _rowNumbers
		one = _one
		two = _two
		pledged = _pledged
		price = _price
	
	func onEnter():
		pass #TODO: draw card

class streetLuck extends streets:
	
	func onEnter():
		pass #TODO: draw card






func _ready():
	#				owner, street number, row, rownumbers, rent, house1, house2, house3, house4, house5, pledged
	street = [
		streetRow.new(false, 2, 1, [2,3], 200, 1000, 3000, 9000, 16000, 25000, false, 6000),
		streetRow.new(false, 3, 1, [2,3], 400, 2000, 6000, 18000, 32000, 45000, false, 6000),
		streetSpecial.new(false, 6, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000),
		streetRow.new(false, 7, 2, [7,9,10], 600, 3000, 9000, 27000, 40000, 55000, false, 10000),
		streetRow.new(false, 9, 2, [7,9,10], 600, 3000, 9000, 27000, 40000, 55000, false, 10000),
		streetRow.new(false, 10, 2, [7,9,10],800, 4000, 10000, 30000, 45000, 60000, false, 12000),
		streetRow.new(false, 12, 3, [12, 14, 15], 1000, 5000, 15000, 45000, 62000, 75000, false, 14000),
		streetAirport.new(false, 13, [13, 29], 400, 1000, false, 15000),
		streetRow.new(false, 14, 3, [12, 14, 15], 1000, 5000, 15000, 45000, 62000, 75000, false, 14000),
		streetRow.new(false, 15, 3, [12, 14, 15], 1200, 6000, 18000, 50000, 70000, 90000, false, 16000),
		streetSpecial.new(false, 16, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000),
		streetRow.new(false, 17, 4, [17, 19, 20], 1400, 7000, 20000, 55000, 75000, 95000, false, 18000),
		streetRow.new(false, 19, 4, [17, 19, 20], 1400, 7000, 20000, 55000, 75000, 95000, false, 18000),
		streetRow.new(false, 20, 4, [17, 19, 20], 1600, 8000, 22000, 60000, 80000, 100000, false, 20000),
		streetRow.new(false, 22, 5, [22, 24, 25], 1800, 9000, 25000, 70000, 87500, 105000, false, 22000),
		streetRow.new(false, 24, 5, [22, 24, 25], 1800, 9000, 25000, 70000, 87500, 105000, false, 22000),
		streetRow.new(false, 25, 5, [22, 24, 25], 2000, 10000, 30000, 75000, 92500, 110000, false, 24000),
		streetSpecial.new(false, 26, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000),
		streetRow.new(false, 27, 6, [27, 28, 30], 2200, 11000, 33000, 80000, 97500, 115000, false, 26000),
		streetRow.new(false, 28, 6, [27, 28, 30], 2200, 11000, 33000, 80000, 97500, 115000, false, 26000),
		streetAirport.new(false, 29, [13, 29], 400, 1000, false, 15000),
		streetRow.new(false, 30, 6, [27, 28, 30], 2400, 12000, 36000, 85000, 102000, 120000, false, 28000),
		streetRow.new(false, 32, 7, [32, 33, 35], 2600, 13000, 39000, 90000, 110000, 127500, false, 30000),
		streetRow.new(false, 33, 7, [32, 33, 35], 2600, 13000, 39000, 90000, 110000, 127500, false, 30000),
		streetRow.new(false, 35, 7, [32, 33, 35], 2800, 15000, 45000, 100000, 120000, 140000, false, 32000),
		streetSpecial.new(false, 36, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000),
		streetRow.new(false, 38, 8, [38, 40], 3500, 17500, 50000, 110000, 130000, 150000, false, 35000),
		streetRow.new(false, 40, 8, [38, 40], 5000, 20000, 60000, 140000, 170000, 200000, false, 40000)
	]
	
func _process(delta):
	if players and active:
		camera.emit()
	if selected == players and carlist.size() == selected and active:
		active = false
		cameraMain.emit()
		for i in players:
			playerPos.insert(i, 0)
		car()
		
func _on_button_button_up():
	playerList.append(player.new())
	playerList.append(player.new())
	players = 2
func _on_button_2_button_up():
	playerList.append(player.new())
	playerList.append(player.new())
	playerList.append(player.new())
	players = 3
	
func _on_button_3_button_up():
	playerList.append(player.new())
	playerList.append(player.new())
	playerList.append(player.new())
	playerList.append(player.new())
	players = 4

func _on_button_4_button_up():
	playerList.append(player.new())
	playerList.append(player.new())
	playerList.append(player.new())
	playerList.append(player.new())
	playerList.append(player.new())
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
	current_position = playerList[currentPlayer].playerPos
	current_position = (current_position + result) % 40
	if current_position < 0:
		current_position += 40
	print("current", current_position)
	var angle = (current_position+23) * (9)
	var rad_angle = deg_to_rad(angle)
	# Calculate new position
	var x = center.x + radius * cos(rad_angle+4.5)
	var y = center.y + radius * sin(rad_angle+4.5)
	# Update the position of the node
	car.position = Vector2(x, y)
	
	car.rotation_degrees = angle - angle*2
	print(angle)
	print(angle - angle*2)
	playerList[currentPlayer-1].playerPos = current_position
	

func _bluecar():
	if !selected == players:
		if !carlist.has("bluecar"):
			carlist.append("bluecar")
			selected += 1
			playerList[selected-1].car = "bluecar"
func _yellowcar():
	if !selected == players:
		if !carlist.has("yellowcar"):
			carlist.append("yellowcar")
			selected += 1
			playerList[selected-1].car = "yellowcar"
func _lightgreencar():
	if !selected == players:
		if !carlist.has("lightgreencar"):
			carlist.append("lightgreencar")
			selected += 1
			playerList[selected-1].car = "lightgreencar"
func _darkgreencar():
	if !selected == players:
		if !carlist.has("darkgreencar"):
			carlist.append("darkgreencar")
			selected += 1
			playerList[selected-1].car = "darkgreencar"
func _orangecar():
	if !selected == players:
		if !carlist.has("orangecar"):
			carlist.append("orangecar")
			selected += 1
			playerList[selected-1].car = "orangecar"
func _pinkcar():
	if !selected == players:
		if !carlist.has("pinkcar"):
			carlist.append("pinkcar")
			selected += 1
			playerList[selected-1].car = "pinkcar"
func _redcar():
	if !selected == players:
		if !carlist.has("redcar"):
			carlist.append("redcar")
			selected += 1
			playerList[selected-1].car = "redcar"
func _blackcar():
	if !selected == players:
		if !carlist.has("blackcar"):
			carlist.append("blackcar")
			selected += 1
			playerList[selected-1].car = "blackcar"


func _on_roll_dice_button_up():
	var die1 = rng1.randi_range(1,6)
	var die2 = rng2.randi_range(1,6)
	var result = die1+die2
	print(die1," ", die2)
	print(result)
	match playerList[currentPlayer].car:
		"bluecar":
			moveCar(bluecar, result)
			currentPlayer += 1
			checkStreet()
		"yellowcar":
			moveCar(yellowcar, result)
			currentPlayer += 1
			checkStreet()
		"lightgreencar":
			moveCar(lightgreencar, result)
			currentPlayer += 1
			checkStreet()
		"darkgreencar":
			moveCar(darkgreencar, result)
			currentPlayer += 1
			checkStreet()
		"orangecar":
			moveCar(orangecar, result)
			currentPlayer += 1
			checkStreet()
		"pinkcar":
			moveCar(pinkcar, result)
			currentPlayer += 1
			checkStreet()
		"redcar":
			moveCar(redcar, result)
			currentPlayer += 1
			checkStreet()
		"blackcar":
			moveCar(blackcar, result)
			currentPlayer += 1
			checkStreet()
	print("currentplayer",currentPlayer)
	if currentPlayer >= players:
		currentPlayer = 0
	
	
func checkStreet():
	current_position = playerList[currentPlayer-1].playerPos
	print(current_position)
	var current_street = street[current_position].streetNumber
	print("currentstreet", current_street)
func _buy():
	pressed = 1
