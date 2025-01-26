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
	$Bubbles.modulate = Color.from_hsv(randf(), 0.3, 1.00)


@onready
var recipes = {
	[$Egg, $Ice]: 
		Drink.new("Egg on the Rocks", 99999999, load("res://scenes/level/drink-assets/Egg on the rocks.png")),
	[$Whisky, $Lemon, $"Sugar Cube", $Orange]: 
		Drink.new("Whiskey Sour", 1000, load("res://scenes/level/drink-assets/whisky sour.png")),
	[$Whisky, $Bitters, $"Sugar Cube", $Orange]: 
		Drink.new("Old Fashioned", 1000, load("res://scenes/level/drink-assets/old fashioned.png")),
	[$Rum, $"Mint Leaf", $"Sugar Cube"]: 
		Drink.new("Mojito", 1000, load("res://scenes/level/drink-assets/Mojito.png")),
	[$"Fey Wine", $"Elixir of Clarity"]: 
		Drink.new("Clarity potion", 1000, load("res://scenes/level/drink-assets/Elixir of clarity .png")),
	[$Whisky, $"Fey Wine", $Bitters, $"Starleaf Bitters", $Cherry]: 
		Drink.new("Mana-hattan", 1000, load("res://scenes/level/drink-assets/Mana-hattan.png")),
	[$Rum, $Lemon, $"Sugar Cube"]: 
		Drink.new("Daiquiri", 1000, load("res://scenes/level/drink-assets/Daiquiri.png")),
	[$"Elixir of Clarity", $"Mint Leaf", $"Ginger Beer"]: 
		Drink.new("FrostHaven Mule", 1000, load("res://scenes/level/drink-assets/Frost Haven Mule.png")),
	[$"Liquid Sunlight", $"Elixir of Clarity", $Rum, $Orange, $Lime, $Orange, $Cherry]: 
		Drink.new("Sirens Sunrise", 1000, load("res://scenes/level/drink-assets/Sirens sunrise.png")),
	[$Whisky, $"Starleaf Bitters", $"Sugar Cube"]: 
		Drink.new("Astral mint", 1000, load("res://scenes/level/drink-assets/Astral Old Fashioned.png")),
	[$Rum, $"Elixir of Clarity", $"Liquid Sunlight", $"Starleaf Bitters", $"Orange liqueur", $"Liquid Moonlight", $Ice, $Cola]: 
		Drink.new("Astral Island", 1000, load("res://scenes/level/drink-assets/Astral Island.png")),
	[$"Orange Liqueur", $"Fey Wine", $Ice]: 
		Drink.new("Fey Summer Spritz", 1000, load("res://scenes/level/drink-assets/Fey Summer Spritz.png")),
	[$"Fey Wine", $"Liquid Sunlight"]: 
		Drink.new("Sunlight Spritz", 1000, load("res://scenes/level/drink-assets/Sunlight Spritz.png")),
	[$"Fey Wine", $"Liquid Moonlight"]: 
		Drink.new("Moonlight Spritz", 1000, load("res://scenes/level/drink-assets/Moonlight Sprtitz.png")),
	[$"Starleaf Bitters", $"Fey Wine"]: 
		Drink.new("Starlight spritz", 1000, load("res://scenes/level/drink-assets/starlight Sprtitz.png")),
	[$"Liquid Moonlight", $Egg, $Lemon]: 
		Drink.new("Moonlight fizz", 1000, load("res://scenes/level/drink-assets/Moonlight Fizz.png"))	
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
	
	var drink = get_drink()
	$Drink.texture = drink.texture
	if drink.is_generic:
		$"Generic glass".visible = true
		$Drink.modulate = drink.color
	$"Drink Label".text = drink.name
	$Cauldron.visible = false
	$"Drink Label".visible = true
	$Drink.visible = true
	current_potion_ingredients.clear()
	
	$Bubbles.hide()
	$Bubbles.stop()
	
	await get_tree().create_timer(1.0).timeout
	currency += drink.sell_price
	create_sell_effect()
	$Cauldron.visible = true
	$Drink.visible = false
	$Drink.modulate = Color.WHITE
	$"Generic glass".visible = false
	$"Drink Label".visible = false


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
	return Drink.new("Mundane Potion", sell_price, null, true, $Bubbles.modulate)
