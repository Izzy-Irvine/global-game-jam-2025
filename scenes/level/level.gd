extends Node2D

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
	[$Egg, $Ice]: "Egg on the Rocks",
	[$Whisky, $"Lemon Juice", $"Sugar Cube", $"Orange Peel"]: "Whiskey Sour",
	[$Whisky, $Bitters, $"Sugar Cube", $"Orange Peel"]: "Old Fashioned",
	[$Rum, $"Mint leaf", $"Sugar Cube", $"Soda Water"]: "Mojito",
	[$"Fey wine (secretly Prosecco)", $"Elixir of clarity (secretly vodka)"]: "Clarity potion",
	[$Whisky, $"Fey wine (secretly Prosecco)", $Bitters, $"Starleaf Bitters", $Cherry]: "Mana-hattan",
	[$Rum, $"Lemon Juice", $"Sugar Cube", $"Lemon Peel"]: "Daiquiri",
	[$"Elixir of clarity (secretly vodka)", $"Mint leaf", $"Ginger Beer"]: "FrostHaven Mule",
	[$"Liquid sunlight (secretly Tequila)", $"Elixir of clarity (secretly vodka)", $Rum, $"Orange Juice", $"Lime Juice", $"Orange Peel", $Cherry]: "Sirens Sunrise",
	[$Whisky, $"Starleaf Bitters", $"Sugar Cube"]: "Astral mint",
	[$Rum, $"Elixir of clarity (secretly vodka)", $"Liquid sunlight (secretly Tequila)", $"Starleaf Bitters", $"Orange liqueur", $"Liquid moonlight (secretly Gin)", $Ice, $Cola]: "Astral Island",
	[$"Orange liqueur", $"Fey wine (secretly Prosecco)", $Ice]: "Fey Summer Spritz",
	[$"Fey wine (secretly Prosecco)", $"Liquid sunlight (secretly Tequila)"]: "Sunlight Spritz",
	[$"Fey wine (secretly Prosecco)", $"Liquid moonlight (secretly Gin)"]: "Moonlight Spritz",
	[$"Starleaf Bitters", $"Fey wine (secretly Prosecco)"]: "Starlight spritz",
	[$"Liquid moonlight (secretly Gin)", $Egg, $"Lemon Juice", $"Lemon Peel"]: "Moonlight fizz"	
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
	create_sell_effect()
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
