@tool
extends Node2D

@export var display_name: String
@export var texture: Texture2D
@export var costCents: int
@export var type: Globals.item_type

var draggable = false
var starting_position: Vector2

func _ready() -> void:
	$Control.tooltip_text = display_name + ". $%.2f" % (costCents / 100)
	$Control/TextureRect.texture = texture
	starting_position = position
	

func _process(delta: float) -> void:
	if not draggable:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Globals.is_dragging = true
		position = get_viewport().get_mouse_position()
	elif Globals.is_dragging:
		Globals.is_dragging = false
		position = starting_position
		if Globals.cauldron_area2d in $Area2D.get_overlapping_areas():
			Globals.current_potion_ingredients.append(self)


func _on_control_mouse_entered() -> void:
	if not Globals.is_dragging:
		draggable = true


func _on_control_mouse_exited() -> void:
	if not Globals.is_dragging:
		draggable = false
