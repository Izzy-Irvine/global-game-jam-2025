@tool
extends Node2D

@export var texture: Texture2D
@export var costCents: int

var draggable = false
var starting_position: Vector2

func _ready() -> void:
	$Control.tooltip_text = name + ". $%.2f" % (costCents / 100.0)
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
		if Globals.cauldron_area2d in $Area2D.get_overlapping_areas() and Globals.currency >= costCents:
			if self not in Globals.current_potion_ingredients:
				Globals.current_potion_ingredients.append(self)
			Globals.currency -= costCents


func _on_control_mouse_entered() -> void:
	if not Globals.is_dragging:
		draggable = true


func _on_control_mouse_exited() -> void:
	if not Globals.is_dragging:
		draggable = false
