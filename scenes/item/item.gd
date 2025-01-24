extends Node2D

@export var display_name: String
@export var texture: Texture2D:
	set(v):
		$Control/TextureRect.texture = v
@export var costCents: int
@export var type: Constants.item_type


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$Control.tooltip_text = display_name + ". $%.2f" % (costCents / 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
