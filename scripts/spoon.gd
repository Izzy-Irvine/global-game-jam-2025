extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var type_count: Array

func mix(contents: Array):
	for item in contents:
		if type_count[item.type] == null:
			type_count[item.type] = 0
		type_count[item.type] += 1
		pass

	# EXAMPLE MIX TYPE:
	# fire and ice cancel each other out
	if type_count[Constants.item_type.FIRE] > type_count[Constants.item_type.ICE]:
		type_count[Constants.item_type.ICE] - type_count[Constants.item_type.FIRE]
	elif type_count[Constants.item_type.ICE] > type_count[Constants.item_type.FIRE]:
		type_count[Constants.item_type.FIRE] - type_count[Constants.item_type.ICE]

	return contents
