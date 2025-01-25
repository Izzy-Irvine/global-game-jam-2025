extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.cauldron_area2d = $Cauldron/Area2D
	$Spoon.mix_button_pressed.connect(mix)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var recipes = {
	[$Egg, $Ice]: "Egg on the Rocks"
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
