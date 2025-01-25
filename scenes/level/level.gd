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


@onready
var recipes = {
	[$Egg, $Ice]: Drink.new("Egg on the Rocks", 99999999),
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
		Drink.new("Fey Summer Spritz", 1000),
	[$"Fey wine (secretly Prosecco)", $"Liquid sunlight (secretly Tequila)"]: 
		Drink.new("Sunlight Spritz", 1000),
	[$"Fey wine (secretly Prosecco)", $"Liquid moonlight (secretly Gin)"]: 
		Drink.new("Moonlight Spritz", 1000),
	[$"Starleaf Bitters", $"Fey wine (secretly Prosecco)"]: 
		Drink.new("Starlight spritz", 1000),
	[$"Liquid moonlight (secretly Gin)", $Egg, $"Lemon Juice", $"Lemon Peel"]: 
		Drink.new("Moonlight fizz", 1000)	
}

func mix():
	for recipe in recipes:
		if not recipe.size() == current_potion_ingredients.size():
			continue
		var missing_ingredient := false
		for ingredient in recipe:
			if ingredient not in current_potion_ingredients:
				missing_ingredient = true
				break
		if not missing_ingredient:
			print(recipes[recipe])
			return
		
	
	# Can't find a recipe, so generate one
