extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.cauldron_area2d = $Cauldron/Area2D
	$Spoon.mix_button_pressed.connect(mix)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var recipes = {
	[$Egg, $Ice]: "Egg on the Rocks",
	# TODO: Whiskey Sour. But I have a question about the ingredients first
	[$Whisky, $Bitters, $"Sugar Cube", $"Orange Peel"]: "Old Fashioned",
	[$Rum, $"Mint leaf", $"Sugar Cube", $"Soda Water"]: "Mojito",
	# TODO: Clarity potion. Mana-hattan. Issue with ingredients list
	[$Rum, $"Lemon Juice", $"Sugar Cube", $"Lemon Peel"]: "Daiquiri",
	[$"Elixir of clarity (secretly vodka)", $"Mint leaf", $"Ginger Beer"]: "FrostHaven Mule",
	#[$"Liquid sunlight (secretly Tequila)", $"Elixir of clarity (secretly vodka)", $Rum, $"Orange Juice", $"Lime Juice", $"Orange Peel"] # missing cherry. "Sirens Sunrise"
	[$Whisky, $"Starleaf Bitters", $"Sugar Cube"]: "Astral mint",
	[$Rum, $"Elixir of clarity (secretly vodka)", $"Liquid sunlight (secretly Tequila)", $"Starleaf Bitters", $"Orange liqueur", $"Liquid moonlight (secretly Gin)", $Ice, $Cola]: "Astral Island",
	[$"Orange liqueur", $"Fey wine (secretly Prosecco)", $Ice]: "Fey Summer Spritz",
	[$"Fey wine (secretly Prosecco)", $"Liquid sunlight (secretly Tequila)"]: "Sunlight Spritz",
	[$"Fey wine (secretly Prosecco)", $"Liquid moonlight (secretly Gin)"]: "Moonlight Spritz",
	[$"Starleaf Bitters", $"Fey wine (secretly Prosecco)"]: "Starlight spritz",
	[$"Liquid moonlight (secretly Gin)", $Egg, $"Lemon Juice", $"Lemon Peel"]: "Moonlight fizz"	
}

func mix():
	for recipe in recipes:
		if not recipe.size() == Globals.current_potion_ingredients.size():
			continue
		for ingredient in Globals.current_potion_ingredients:
			if ingredient not in recipe:
				continue
		print(recipes[recipe])
	
	# Can't find a recipe, so generate one
