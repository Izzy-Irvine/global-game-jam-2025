extends Node2D

const Drink = preload("res://scenes/level/drink.gd")

var currency: int = 2000: # in cents
	set(value):
		currency = value
		$"Coin Jar".update_currency(currency)

var current_potion_ingredients: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Coin Jar".update_currency(currency)
	
	for child in get_children():
		if is_instance_of(child, Ingredient):
			(child as Ingredient).add_to_cauldron.connect(_on_add_to_cauldron)
	
	Ingredient.cauldron_area2d = $Cauldron/Area2D
	$Spoon.mix_button_pressed.connect(mix)

func _on_add_to_cauldron(target: Ingredient):
	if currency < target.costCents:
		return
	
	currency -= target.costCents
	current_potion_ingredients.append(target)
	print("Added: " + target.name)
	$Bubbles.show()
	$Bubbles.play()


@onready
var recipes = {
	[$Egg, $Ice]: 
		Drink.new("Egg on the Rocks", 99999999),
	[$Whisky, $"Lemon Juice", $"Sugar Cube", $"Orange Peel"]: 
		Drink.new("Whiskey Sour", 1000),
	[$Whisky, $Bitters, $"Sugar Cube", $"Orange Peel"]: 
		Drink.new("Old Fashioned", 1000),
	[$Rum, $"Mint leaf", $"Sugar Cube", $"Soda Water"]: 
		Drink.new("Mojito", 1000),
	[$"Fey wine (secretly Prosecco)", $"Elixir of clarity (secretly vodka)"]: 
		Drink.new("Clarity potion", 1000),
	[$Whisky, $"Fey wine (secretly Prosecco)", $Bitters, $"Starleaf Bitters", $Cherry]: 
		Drink.new("Mana-hattan", 1000),
	[$Rum, $"Lemon Juice", $"Sugar Cube", $"Lemon Peel"]: 
		Drink.new("Daiquiri", 1000),
	[$"Elixir of clarity (secretly vodka)", $"Mint leaf", $"Ginger Beer"]: 
		Drink.new("FrostHaven Mule", 1000),
	[$"Liquid sunlight (secretly Tequila)", $"Elixir of clarity (secretly vodka)", $Rum, $"Orange Juice", $"Lime Juice", $"Orange Peel", $Cherry]: 
		Drink.new("Sirens Sunrise", 1000),
	[$Whisky, $"Starleaf Bitters", $"Sugar Cube"]: 
		Drink.new("Astral mint", 1000),
	[$Rum, $"Elixir of clarity (secretly vodka)", $"Liquid sunlight (secretly Tequila)", $"Starleaf Bitters", $"Orange liqueur", $"Liquid moonlight (secretly Gin)", $Ice, $Cola]: 
		Drink.new("Astral Island", 1000),
	[$"Orange liqueur", $"Fey wine (secretly Prosecco)", $Ice]: 
		Drink.new("Fey Summer Spritz", 1000, load("res://scenes/level/Fey Summer Spritz.png")),
	[$"Fey wine (secretly Prosecco)", $"Liquid sunlight (secretly Tequila)"]: 
		Drink.new("Sunlight Spritz", 1000, load("res://scenes/level/Sunlight Spritz.png")),
	[$"Fey wine (secretly Prosecco)", $"Liquid moonlight (secretly Gin)"]: 
		Drink.new("Moonlight Spritz", 1000, load("res://scenes/level/Moonlight Sprtitz.png")),
	[$"Starleaf Bitters", $"Fey wine (secretly Prosecco)"]: 
		Drink.new("Starlight spritz", 1000, load("res://scenes/level/starlight Sprtitz.png")),
	[$"Liquid moonlight (secretly Gin)", $Egg, $"Lemon Juice", $"Lemon Peel"]: 
		Drink.new("Moonlight fizz", 1000, load("res://scenes/level/Moonlight Fizz.png"))	
}

var coin_particle_script = load("res://scenes/level/coin_particles.gd")

func create_sell_effect():
	var coin_particles = Node2D.new()
	coin_particles.script = coin_particle_script
	coin_particles.target = $"Coin Jar"
	coin_particles.particle_scene = preload("res://scenes/particles.tscn")
	coin_particles.duration = 0.7
	coin_particles.emit_interval = 0.033
	coin_particles.global_position = $Cauldron.global_position
	add_child(coin_particles)


func mix():
	if current_potion_ingredients.size() == 0:
		return
	
	create_sell_effect()
	var drink = get_drink()
	drink.apply_to_sprite($Drink)
	currency += drink.sell_price
	$Cauldron.visible = false
	$Drink.visible = true
	current_potion_ingredients.clear()
	

func get_drink() -> Drink:
	for recipe in recipes:
		if not recipe.size() == current_potion_ingredients.size():
			continue
		var missing_ingredient := false
		for ingredient in recipe:
			if ingredient not in current_potion_ingredients:
				missing_ingredient = true
				break
		if not missing_ingredient:
			return recipes[recipe]
	
	if current_potion_ingredients.size() == 1:
		var ingredient = current_potion_ingredients[0]
		return Drink.new(ingredient.name, ingredient.costCents * 0.8, ingredient.texture)
	
	# generic
	var sell_price = 0
	for ingredient in current_potion_ingredients:
		sell_price += ingredient.costCents
	sell_price *= 0.8
	return Drink.new("Mundane Potion", sell_price, null, true)
	
	return null
	
	# Can't find a recipe, so generate one
	
	$Bubbles.hide()
	$Bubbles.stop()
