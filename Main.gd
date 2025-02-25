extends Node2D

@onready var buyButton = $Buy
@onready var rollDiceButton = $rollDice
@onready var auctionButton = $Auction
@onready var doneButton = $Done
@onready var bidInput = $bid/bidinput
@onready var bid = $bid
@onready var passButton = $bid/passButton
@onready var dice1 = $Die/Dice1
@onready var dice2 = $Die/Dice2
@onready var action = $Action
@onready var winner = $Win
@onready var winnerLabel = $Win/winnerText


var players
var playerList = []
var playerlist = []
var cardList = []
var usedCardList = []
var propertyCards = []
var propertyCardsOwned = []
var playerData = []
var dice = []
var cardHolders = {}
var street = []
var carlist = []
var selected = 0
var currentPlayer = 0
var active = true
var pressed: int
var streetCards
var boatsOwned: int
var airportsOwned: int
var streetsOwned: int
var result: int
var currentBid: int = 0
var currPlayer: int = 1
var passedPlayers: int = 0
var offset_x:int = 0
var offset_y:int = 1200
var row_count:int = 0
var displayed_cards = {}
var player_offsets = {}
var clicked = 0
var activeCard
var house

signal camera
signal cameraMain

var player1
var player2
var player3
var player4
var player5

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
var rngCard = RandomNumberGenerator.new()

var radius: float = 5200 # Radius of the circle
var center: Vector2 = Vector2(0, 0) # Center of the circle
var angle: float = -9
var current_position: int = 0


###################### Classes ######################


class player:
	var playerID: int
	var money: int = 150_000
	var skipTurns: int
	var playerPos: int = 1
	var lastPos: int
	var freePark: bool
	var cards = []
	var car
	var inJail: bool = false
	
	func _init(_playerID):
		playerID = _playerID
	
class streets:
	var streetNumber: int
	var owner: int
	var card
	var pledgedCard
	
	func getStreetNumber():
		return streetNumber



class streetRow extends streets:
	var row: int
	var rowNumbers = []
	var houses: int = 0
	var price: int
	var rent: int
	var house1: int
	var house2: int
	var house3: int
	var house4: int
	var house5: int
	var pledged: bool
	var type = "Street"
	var housePrice: int
	var houseTexture
	
	func _init(_owner, _streetNumber, _row, _rowNumbers, _rent, _house1, _house2, _house3, _house4, _house5, _pledged, _price, _housePrice, _card, _pledgedCard):
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
		housePrice = _housePrice
		card = _card
		pledgedCard = _pledgedCard
		
class streetSpecial extends streets:
	var rowNumbers = []
	var price: int
	var one: int
	var two: int
	var three: int
	var four: int
	var pledged: bool
	var type = "boat"
	
	func _init(_owner, _streetNumber, _rowNumbers, _one, _two, _three, _four, _pledged, _price, _card, _pledgedCard):
		owner = _owner
		streetNumber = _streetNumber
		rowNumbers = _rowNumbers
		one = _one
		two = _two
		three = _three
		four = _four
		pledged = _pledged
		price = _price
		card = _card
		pledgedCard = _pledgedCard
	

	
class streetAirport extends streets:
	var rowNumbers = []
	var price: int
	var one: int
	var two: int
	var pledged: bool
	var type = "airport"
	
	func _init(_owner, _streetNumber, _rowNumbers, _one, _two, _pledged, _price, _card, _pledgedCard):
		owner = _owner
		streetNumber = _streetNumber
		rowNumbers = _rowNumbers
		one = _one
		two = _two
		pledged = _pledged
		price = _price
		card = _card
		pledgedCard = _pledgedCard
	


class streetLuck extends streets:
	var type = "luck"
	func _init(_streetNumber):
		streetNumber = _streetNumber


class misc extends streets:
	var type
	func _init(_streetNumber, _type):
		streetNumber = _streetNumber
		type = _type

class cards:
	var type
	var amount
	var message
	func _init(_type, _amount, _message):
		type = _type
		amount = _amount
		message = _message
		

func _ready():
	#				owner, street number, row, rownumbers, rent, house1, house2, house3, house4, house5, pledged
	street = [
			misc.new(1, "start"),
			streetRow.new(false, 2, 1, [2,3], 200, 1000, 3000, 9000, 16000, 25000, false, 6000, 5000, "res://Kort/GateKort/Omsundet-Kort.png", "res://Kort/pantsattKort/Omsundet-Pantsatt.png"),
			streetLuck.new(3),
			streetRow.new(false, 4, 1, [2,3], 400, 2000, 6000, 18000, 32000, 45000, false, 6000, 5000, "res://Kort/GateKort/Rensvik-Kort.png", "res://Kort/pantsattKort/Rensvik-Pantsatt.png"),
			misc.new(5, "tax10"),
			streetSpecial.new(false, 6, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000, "res://Kort/GateKort/Sundbåten-Kort.png", "res://Kort/pantsattKort/Sundbåten-Pantsatt.png"),
			streetRow.new(false, 7, 2, [7,9,10], 600, 3000, 9000, 27000, 40000, 55000, false, 10000, 5000, "res://Kort/GateKort/Gomalandet-Kort.png", "res://Kort/pantsattKort/Gomalandet-Pantsatt.png"),
			streetRow.new(false, 8, 2, [7,9,10], 600, 3000, 9000, 27000, 40000, 55000, false, 10000, 5000, "res://Kort/GateKort/Byskogen-Kort.png", "res://Kort/pantsattKort/Byskogen-Pantsatt.png"),
			streetLuck.new(9),
			streetRow.new(false, 10, 2, [7,9,10],800, 4000, 10000, 30000, 45000, 60000, false, 12000, 5000, "res://Kort/GateKort/Dale-Kort.png", "res://Kort/pantsattKort/Dale-Pantsatt.png"),
			misc.new(11, "jail"),
			streetRow.new(false, 12, 3, [12, 14, 15], 1000, 5000, 15000, 45000, 62000, 75000, false, 14000, 10000, "res://Kort/GateKort/Storskarven-Kort.png", "res://Kort/pantsattKort/Storskarven-Pantsatt.png"),
			streetRow.new(false, 13, 3, [12, 14, 15], 1000, 5000, 15000, 45000, 62000, 75000, false, 14000, 10000, "res://Kort/GateKort/Innlandet-Kort.png", "res://Kort/pantsattKort/Innlandet-Pantsatt.png"),
			streetAirport.new(false, 14, [13, 29], 400, 1000, false, 15000, "res://Kort/GateKort/Flyplass1-Kort.png", "res://Kort/pantsattKort/Flyplass1-Pantsatt.png"),
			streetRow.new(false, 15, 3, [12, 14, 15], 1200, 6000, 18000, 50000, 70000, 90000, false, 16000, 10000, "res://Kort/GateKort/Nordlandet-Kort.png", "res://Kort/pantsattKort/Nordlandet-Pantsatt.png"),
			streetSpecial.new(false, 16, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000, "res://Kort/GateKort/Kulturfabrikken-Kort.png", "res://Kort/pantsattKort/Kulturfabrikken-Pantsatt.png"),
			streetRow.new(false, 17, 4, [17, 19, 20], 1400, 7000, 20000, 55000, 75000, 95000, false, 18000, 10000, "res://Kort/GateKort/Atlanten-Kort.png", "res://Kort/pantsattKort/Atlanten-Pantsatt.png"),
			streetRow.new(false, 18, 4, [17, 19, 20], 1400, 7000, 20000, 55000, 75000, 95000, false, 18000, 10000, "res://Kort/GateKort/St.Hanshaugen-Kort.png", "res://Kort/pantsattKort/St-Pantsatt-Kort.png"),
			streetLuck.new(19),
			streetRow.new(false, 20, 4, [17, 19, 20], 1600, 8000, 22000, 60000, 80000, 100000, false, 20000, 10000, "res://Kort/GateKort/Campus-Kort.png", "res://Kort/pantsattKort/Campus-Pantsatt.png"),
			misc.new(21, "traficlight"),
			streetRow.new(false, 22, 5, [22, 24, 25], 1800, 9000, 25000, 70000, 87500, 105000, false, 22000, 15000, "res://Kort/GateKort/Ivar Aasens Gate-Kort.png", "res://Kort/pantsattKort/Ivar-Pantsatt Gate-Kort.png"),
			streetRow.new(false, 23, 5, [22, 24, 25], 1800, 9000, 25000, 70000, 87500, 105000, false, 22000, 15000, "res://Kort/GateKort/Kaibakken-Kort.png", "res://Kort/pantsattKort/Kaibakken-Pantsatt.png"),
			streetLuck.new(24),
			streetRow.new(false, 25, 5, [22, 24, 25], 2000, 10000, 30000, 75000, 92500, 110000, false, 24000, 15000, "res://Kort/GateKort/Røsseren-Kort.png", "res://Kort/pantsattKort/Røsseren-Pantsatt.png"),
			streetSpecial.new(false, 26, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000, "res://Kort/GateKort/Nordmøre Stadion-Kort.png", "res://Kort/pantsattKort/Nordmøre-Pantsatt-Kort.png"),
			streetRow.new(false, 27, 6, [27, 28, 30], 2200, 11000, 33000, 80000, 97500, 115000, false, 26000, 15000, "res://Kort/GateKort/Løkkemyra-Kort.png", "res://Kort/pantsattKort/Løkkemyra-Pantsatt.png"),
			streetRow.new(false, 28, 6, [27, 28, 30], 2200, 11000, 33000, 80000, 97500, 115000, false, 26000, 15000, "res://Kort/GateKort/Storkaia-Kort.png", "res://Kort/pantsattKort/Storkaia-Pantsatt.png"),
			streetAirport.new(false, 29, [13, 29], 400, 1000, false, 15000, "res://Kort/GateKort/Flyplass2-Kort.png", "res://Kort/pantsattKort/Flyplass2-Pantsatt.png"),
			streetRow.new(false, 30, 6, [27, 28, 30], 2400, 12000, 36000, 85000, 102000, 120000, false, 28000, 15000, "res://Kort/GateKort/Futura-Kort.png", "res://Kort/pantsattKort/Futura-Pantsatt.png"),
			streetLuck.new(31),
			streetRow.new(false, 32, 7, [32, 33, 35], 2600, 13000, 39000, 90000, 110000, 127500, false, 30000, 20000, "res://Kort/GateKort/Rådhusplassen-Kort.png", "res://Kort/pantsattKort/Rådhusplassen-Pantsatt.png"),
			streetRow.new(false, 33, 7, [32, 33, 35], 2600, 13000, 39000, 90000, 110000, 127500, false, 30000, 20000, "res://Kort/GateKort/GrautByen-Kort.png", "res://Kort/pantsattKort/GrautByen-Pantsatt.png"),
			streetLuck.new(34),
			streetRow.new(false, 35, 7, [32, 33, 35], 2800, 15000, 45000, 100000, 120000, 140000, false, 32000, 20000, "res://Kort/GateKort/Bryggekanten-Kort.png", "res://Kort/pantsattKort/Bryggekanten-Pantsatt.png"),
			streetSpecial.new(false, 36, [6, 16, 26, 36], 2500, 5000, 10000, 20000, false, 20000, "res://Kort/GateKort/Atlanterhavsbadet-Kort.png", "res://Kort/pantsattKort/Atlanterhavsbadet-Pantsatt.png"),
			streetLuck.new(37),
			streetRow.new(false, 38, 8, [38, 40], 3500, 17500, 50000, 110000, 130000, 150000, false, 35000, 20000, "res://Kort/GateKort/Olav v's Gate-Kort.png", "res://Kort/pantsattKort/Olav-Pantsatt's Gate-Kort.png"),
			misc.new(39, "tax"),
			streetRow.new(false, 40, 8, [38, 40], 5000, 20000, 60000, 140000, 170000, 200000, false, 40000, 20000, "res://Kort/GateKort/Kongens Gate-Kort.png", "res://Kort/pantsattKort/Kongens-Pantsatt-Kort.png"),
	]

	propertyCards = [
		2, 4, 6, 7, 8, 10, 12, 13, 14, 15, 16, 17, 18, 20, 22, 23, 25, 26, 27, 28, 29, 30, 32, 33, 35, 36, 38, 40
	]
	
	cardList = [
		cards.new("get", 30_000, "Du får Damm-prisen for landets mest lovende Millionær-aspirant Motta kr. 30.000"),
		cards.new("get", 15_000, "Du selger aksjer og mottar kr. 15.000."),
		cards.new("get", 10_000, "Motta fra onkel i Amerika kr. 10.000."),
		cards.new("get", 10_000, "Du har 5 rette I Lotto og får utbetalt kr. 10.000."),
		cards.new("get", 10_000, "Etter tante Olga på Toten har du arvet 4 katter, en grønn papegøye, 16 juletrær på rot (uten pynt) og kr. 10.000 som utbetales av banken."),
		cards.new("get", 10_000, "Du har vunnet I Pengelotteriet. Motta kr. 10.000"),
		cards.new("get", 10_000, "Din premieobligasjon er blitt trukket ut. Motta kr. 10.000"),
		cards.new("get", 5_000, "Du har en 11'er og fire 10'ere I tipping og har utbetalt kr. 5.000."),
		cards.new("get", 5_000, "Du har kjøpt et maleri på loppemarked, og selger det videre med kr. 5.000 I fortjenste som utbetales av banken."),
		cards.new("get", 5_000, "I anledning av bankens 100 års jubileum, utbetales kr. 5.000 I ekstra bonus."),
		cards.new("get", 2_500, "Ligninen er lagt ut, og du får kr. 2.500 igjen på skatten."),
		cards.new("get", 2_000, "Du får julegratiale med kr. 2.000."),
		cards.new("get", 500, "Du har vunnet kr. 500 på travbanen."),
		
		cards.new("pay", 7_500, "Ligninen er lagt ut. Betal restskatt med kr. 7.500"),
		cards.new("pay", 2_000, "Betal eiendomskatt og avgifter med kr. 2.000."),
		cards.new("pay", 1_000, "Du er tatt I radarkontroll og må betale kr. 1.000 I bot for fartsoverskridelsen."),
	]
	
	dice = [
		"res://Dice/Dice1.png",
		"res://Dice/Dice2.png",
		"res://Dice/Dice3.png",
		"res://Dice/Dice4.png",
		"res://Dice/Dice5.png",
		"res://Dice/Dice6.png"
		]
	
func _process(_delta):
	if players and active:
		camera.emit()
	if selected == players and carlist.size() == selected and active:
		active = false
		cameraMain.emit()
		car()
		addPlayers()


func _on_button_button_up():
	playerList.append(player.new(1))
	playerList.append(player.new(2))
	players = 2
func _on_button_2_button_up():
	playerList.append(player.new(1))
	playerList.append(player.new(2))
	playerList.append(player.new(3))
	players = 3
func _on_button_3_button_up():
	playerList.append(player.new(1))
	playerList.append(player.new(2))
	playerList.append(player.new(3))
	playerList.append(player.new(4))
	players = 4

func _bluecar():
	if !selected == players:
		if !carlist.has("bluecar"):
			carlist.append("bluecar")
			selected += 1
			playerList[selected-1].car = bluecar
func _yellowcar():
	if !selected == players:
		if !carlist.has("yellowcar"):
			carlist.append("yellowcar")
			selected += 1
			playerList[selected-1].car = yellowcar
func _lightgreencar():
	if !selected == players:
		if !carlist.has("lightgreencar"):
			carlist.append("lightgreencar")
			selected += 1
			playerList[selected-1].car = lightgreencar
func _darkgreencar():
	if !selected == players:
		if !carlist.has("darkgreencar"):
			carlist.append("darkgreencar")
			selected += 1
			playerList[selected-1].car = darkgreencar
func _orangecar():
	if !selected == players:
		if !carlist.has("orangecar"):
			carlist.append("orangecar")
			selected += 1
			playerList[selected-1].car = orangecar
func _pinkcar():
	if !selected == players:
		if !carlist.has("pinkcar"):
			carlist.append("pinkcar")
			selected += 1
			playerList[selected-1].car = pinkcar
func _redcar():
	if !selected == players:
		if !carlist.has("redcar"):
			carlist.append("redcar")
			selected += 1
			playerList[selected-1].car = redcar
func _blackcar():
	if !selected == players:
		if !carlist.has("blackcar"):
			carlist.append("blackcar")
			selected += 1
			playerList[selected-1].car = blackcar


func addPlayers():
	playerlist = [player1,
					player2,
					player3,
					player4]

	playerData = [Vector2i(-11200, -6200), 
					Vector2i(7500, -6200), 
					Vector2i(-11200, 1000), 
					Vector2i(7500, 1000),]
	
	for i in players:
		playerlist[i] = Label.new()
		add_child(playerlist[i])
		playerlist[i].position = playerData[i]
		playerlist[i].text = "Player %s \n%s \nMoney: %s" % [i+1, carlist[i], playerList[i].money]
		playerlist[i].add_theme_font_size_override("font_size", 300)
		
func removePlayer(playerID):
	playerlist.pop_at(playerID)
	players -= 1
	for i in street.size():
		if street[i].owner == playerID:
			street[i].owner = false
	
func checkPlayers():
	for i in players:
		if playerList.size() > 1:
			if playerList[i-1].money < 1:
				removePlayer(i-1)
		else:
			win(playerList[0].playerID)
	if playerList[currentPlayer-1].money > 1_000_000:
		win(currentPlayer+1)

func win(playerID):
	winner.visible = true
	winnerLabel.text = "Player %s Won" % [playerID]

func car():
	var startpos =  Vector2(-1300,4660)
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


func moveCar():
	current_position = playerList[currentPlayer].playerPos
	playerList[currentPlayer].lastPos = current_position
	current_position = (current_position + result) % 40
	if current_position == 0:
		current_position += 40
	
	angle = (current_position+22) * (9)
	var rad_angle = deg_to_rad(angle)
	var x = center.x + radius * cos(rad_angle+4.5)
	var y = center.y + radius * sin(rad_angle+4.5)
	
	playerList[currentPlayer].car.position = Vector2(x, y)
	playerList[currentPlayer].car.rotation_degrees = angle+180
	playerList[currentPlayer].playerPos = current_position
	if playerList[currentPlayer].lastPos > playerList[currentPlayer].playerPos:
		playerList[currentPlayer].money += 20_000
		updateScreen()
	
func _on_roll_dice_button_up():
	checkPlayers()
	if currentPlayer > players-1:
		currentPlayer = 0
		
	var die1 = rng1.randi_range(1,6)
	var die2 = rng2.randi_range(1,6)
	dice1.texture = load(dice[die2-1])
	dice2.texture = load(dice[die1-1])
	
	result = die1+die2
	if playerList[currentPlayer].skipTurns == 0:
		moveCar()
	checkStreet()
	updateScreen()
	for i in players:
		playerlist[i].add_theme_color_override("font_color", Color(1, 1, 1))
	playerlist[currentPlayer].add_theme_color_override("font_color", Color(0, 1, 0))
	if playerList[currentPlayer].skipTurns != 0:
		playerList[currentPlayer].skipTurns -= 1
		if playerList[currentPlayer].inJail == true and playerList[currentPlayer].skipTurns == 0:
			playerList[currentPlayer].inJail = false
	if playerList[currentPlayer].lastPos != 21:
		playerList[currentPlayer].freePark = false
	currentPlayer += 1
	checkPlayers()

				
func checkStreet():
	var current_street = street[current_position-1]
	var activePlayer = playerList[currentPlayer]
	match current_street.type:
		
		"Street":
			if current_street.owner != 0:
				if current_street.pledged == false:
					if currentPlayer != current_street.owner:
						if not activePlayer.freePark:
							for i in current_street.rowNumbers:
								if street[i-1].owner == currentPlayer:
									streetsOwned += 1
								
								# TODO: fix street check
								
							match current_street.houses:
								0:
									activePlayer.money = activePlayer.money - current_street.rent
									playerList[current_street.owner-1].money += current_street.rent
								1: 
									activePlayer.money = activePlayer.money - current_street.house1
									playerList[current_street.owner].money += current_street.house1
								2: 
									activePlayer.money = activePlayer.money - current_street.house2
									playerList[current_street.owner].money += current_street.house2
								3: 
									activePlayer.money = activePlayer.money - current_street.house3
									playerList[current_street.owner].money += current_street.house3
								4: 
									activePlayer.money = activePlayer.money - current_street.house4
									playerList[current_street.owner].money += current_street.house4
								5:
									activePlayer.money = activePlayer.money - current_street.house5
									playerList[current_street.owner].money += current_street.house5
							streetsOwned = 0
			else:
				buyButton.visible = !buyButton.visible
				rollDiceButton.visible = !rollDiceButton.visible
				auctionButton.visible = !auctionButton.visible
		"boat":
			if current_street.owner != 0:
				if current_street.pledged == false:
					if currentPlayer != current_street.owner-1:
						if not activePlayer.freePark:
							for i in [6, 16, 26, 36]:
								if street[i].owner == currentPlayer:
									boatsOwned += 1
							match boatsOwned:
								1:
									activePlayer.money = activePlayer.money - current_street.one
									playerList[current_street.owner-1].money += current_street.one
								2:
									activePlayer.money = activePlayer.money - current_street.two
									playerList[current_street.owner-1].money += current_street.two
								3:
									activePlayer.money = activePlayer.money - current_street.three
									playerList[current_street.owner-1].money += current_street.three
								4:
									activePlayer.money = activePlayer.money - current_street.four
									playerList[current_street.owner-1].money += current_street.four
					boatsOwned = 0
			else:
				buyButton.visible = !buyButton.visible
				rollDiceButton.visible = !rollDiceButton.visible
				auctionButton.visible = !auctionButton.visible
		"airport":
			if current_street.owner != 0:
				if current_street.pledged == false:
					if currentPlayer != current_street.owner-1:
						if not activePlayer.freePark:
							for i in [14, 29]:
								if street[i].owner == currentPlayer:
									airportsOwned += 1
							match airportsOwned:
								1:
									activePlayer.money = result * current_street.one
									playerList[current_street.owner-1].money += result * current_street.one
								2:
									activePlayer.money = result * current_street.two
									playerList[current_street.owner-1].money += result * current_street.two
					
			else:
				buyButton.visible = !buyButton.visible
				rollDiceButton.visible = !rollDiceButton.visible
				auctionButton.visible = !auctionButton.visible
		"jail":
			if not playerList[currentPlayer].inJail:
				playerList[currentPlayer].inJail = true
				playerList[currentPlayer].skipTurns = 3
		"luck":
			if cardList.size() > 0:
				var card = rngCard.randi_range(1,cardList.size()-1)
				usedCardList.append(cardList[card-1])
				match cardList[card-1].type:
					"pay":
						activePlayer.money -= cardList[card-1].amount
					"get":
						activePlayer.money += cardList[card-1].amount
				cardList.remove_at(card-1)

			else:
				cardList = usedCardList
				usedCardList = []
		"tax":
			activePlayer.money -= 10_000
		"tax10":
			activePlayer.money -= activePlayer.money*0.1
		"traficlight":
			activePlayer.freePark = true
			
func updateScreen():
	for i in players:
		playerlist[i].text = "Player %s \n%s \nMoney: %s \n %s" % [playerList[i].playerID, carlist[i], playerList[i].money, "Jail Time: "+str(playerList[i].skipTurns) if playerList[i].skipTurns > 0 else ""]
	
	for i in players:
		if not player_offsets.has(i):
			player_offsets[i] = {"offset_x": 0, "offset_y": 1300, "row_count": 0}
		
		var player_offset = player_offsets[i]

		for y in propertyCards:
			var card_path = str(street[y - 1].card)
			
			if street[y-1].owner == i+1 and not displayed_cards.has(card_path):
				var card_holder = TextureRect.new()
				var sprite = load(card_path)
				card_holder.texture = sprite
				card_holder.scale = Vector2(2.2,2.2)
				
				if i < playerData.size():
					card_holder.position = playerData[i] + Vector2i(player_offset["offset_x"], player_offset["offset_y"])
				
				add_child(card_holder)
				cardHolders[str(current_position)] = card_holder
				displayed_cards[card_path] = true
				
				
				card_holder.mouse_filter = Control.MOUSE_FILTER_STOP
				
				card_holder.connect("gui_input", Callable(self, "_on_card_clicked").bind(card_holder, card_holder.position, y))
				
				player_offset["row_count"] += 1
				player_offset["offset_x"] += 2200
				
				if player_offset["row_count"] == 2:
					player_offset["offset_x"] = 0
					player_offset["offset_y"] += 600
					player_offset["row_count"] = 0
				
func _on_card_clicked(event, card_holder, cardPos, card):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked = !clicked
		if clicked:
			card_holder.scale = Vector2(4, 4)
			card_holder.position = Vector2(-2000, -2000)
			
			if street[card-1].owner == currentPlayer:
				action.visible = !action.visible
				activeCard = street[card-1].streetNumber
			
		else:
			card_holder.scale = Vector2(2.2, 2.2)
			card_holder.position = cardPos
			action.visible = false
	

func buy():
	if currentPlayer > players:
		currentPlayer = 0
	var current_street = street[current_position-1]
	if playerList[currentPlayer-1].money >= current_street.price:
		playerList[currentPlayer-1].money -= current_street.price
		
		current_street.owner = currentPlayer
		doneButton.visible = !doneButton.visible
		buyButton.visible = !buyButton.visible
		auctionButton.visible = !auctionButton.visible
	else:
		auction()
	updateScreen()
	
func auction():
	buyButton.visible = !buyButton.visible
	auctionButton.visible = !auctionButton.visible
	bid.visible = !bid.visible
	var current_street = street[current_position-1]
	
	bidInput.text = str(current_street.price+1000)
	
func done():
	doneButton.visible = !doneButton.visible
	rollDiceButton.visible = !rollDiceButton.visible
	for i in players:
		playerlist[i].add_theme_color_override("font_color", Color(1, 1, 1))
	playerlist[currentPlayer-1].add_theme_color_override("font_color", Color(0, 1, 0))
	
func pass_button():
	if currPlayer > players:
		currPlayer = 1
	passedPlayers += 1
	if passedPlayers == players and currentBid == 0:
		rollDiceButton.visible = !rollDiceButton.visible
		bid.visible = !bid.visible
		
	elif passedPlayers >= players and currentBid and playerList[currPlayer-1].money > 0:
		playerList[currPlayer-1].money -= currentBid
		street[current_position-1].owner = currPlayer
		updateScreen()
		rollDiceButton.visible = !rollDiceButton.visible
		bid.visible = !bid.visible
		passedPlayers = 0
	
	for i in players:
		playerlist[i].add_theme_color_override("font_color", Color(1, 1, 1))
	playerlist[currPlayer-1].add_theme_color_override("font_color", Color(0, 1, 0))
	currPlayer += 1

	
func bid_button():
	var new_text = bidInput.text
	if currPlayer > players:
		currPlayer = 1
	if new_text.is_valid_int() and int(new_text)+1000 < playerList[currPlayer-1].money:
		new_text = int(new_text)
		for i in players:
			playerlist[i].add_theme_color_override("font_color", Color(1, 1, 1))
		playerlist[currPlayer-1].add_theme_color_override("font_color", Color(0, 1, 0))
		currentBid = new_text + 1000
		bidInput.text = str(currentBid)
		currPlayer += 1
	passedPlayers = 0


func _on_pledge_button_up():
	if street[activeCard-1].type == "Street" or street[activeCard-1].type == "boat" or street[activeCard-1].type == "airport":
		if street[activeCard-1].pledged == false:
			var card_holder = cardHolders[str(activeCard)]
			street[activeCard-1].pledged = true
			playerList[currentPlayer-1].money += street[activeCard-1].price / 2
			var card_path = str(street[activeCard-1].pledgedCard)
			var sprite = load(card_path)
			
			card_holder.texture = sprite
			updateScreen()
		else:
			var card_holder = cardHolders[str(activeCard)]
			street[activeCard-1].pledged = false
			playerList[currentPlayer-1].money -= street[activeCard-1].price / 2
			var card_path = str(street[activeCard-1].card)
			var sprite = load(card_path)
			
			card_holder.texture = sprite
			updateScreen()


func _on_buy_house_button_up():
	if street[activeCard-1].type == "Street":
		var streetsOwnedDisp = []
		for i in street[activeCard-1].rowNumbers:
			if street[i-1].owner == currentPlayer:
				streetsOwnedDisp.append(i)
		if streetsOwnedDisp != street[activeCard-1].rowNumbers:
			if street[activeCard-1].houses != 5:
				street[activeCard-1].houses += 1
				playerList[currentPlayer-1].money -= street[activeCard-1].housePrice
				updateScreen()
			if not street[activeCard-1].houseTexture:
				house = Sprite2D.new()
				add_child(house)
			street[activeCard-1].houseTexture = house
			match street[activeCard-1].houses:
				1:
					street[activeCard-1].houseTexture.texture = load("res://hus/Hus1.png")
				2:
					street[activeCard-1].houseTexture.texture = load("res://hus/Hus2.png")
					street[activeCard-1].houseTexture.scale = Vector2(0.75, 0.75)
				3:
					street[activeCard-1].houseTexture.texture = load("res://hus/Hus3.png")
					street[activeCard-1].houseTexture.scale = Vector2(0.5, 0.5)
				4:
					street[activeCard-1].houseTexture.texture = load("res://hus/Hus4.png")
					street[activeCard-1].houseTexture.scale = Vector2(0.5, 0.5)
				5:
					if street[activeCard-1].row != 40:
						street[activeCard-1].houseTexture.texture = load("res://hus/Hotell.png")
						street[activeCard-1].houseTexture.scale = Vector2(0.5, 0.5)
					else:
						street[activeCard-1].houseTexture.texture = load("res://hus/Slott.png")
						street[activeCard-1].houseTexture.scale = Vector2(0.5, 0.5)
			
			angle = (activeCard+22) * (9)
			var houseRadius = 3500
			
			
			var rad_angle = deg_to_rad(angle)
			var x = center.x + houseRadius * cos(rad_angle+4.5)
			var y = center.y + houseRadius * sin(rad_angle+4.5)
			
			street[activeCard-1].houseTexture.rotation = angle - PI
			print(angle-PI)
			street[activeCard-1].houseTexture.position = Vector2(x, y)
