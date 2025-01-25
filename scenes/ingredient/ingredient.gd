@tool
class_name Ingredient extends Node2D

signal add_to_cauldron(target: Ingredient)

static var item_dragged = null
static var cauldron_area2d: Area2D

@export var texture: Texture2D
@export var costCents: int

var is_mouse_hovering = false
var starting_position: Vector2

func _ready() -> void:
	$Control.tooltip_text = name + ". $%.2f" % (costCents / 100.0)
	$Control/TextureRect.texture = texture
	starting_position = position
	

func _process(delta: float) -> void:
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and item_dragged == null and is_mouse_hovering:
		item_dragged = self
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and item_dragged == self:
		position = starting_position
		item_dragged = null
		if cauldron_area2d in $Area2D.get_overlapping_areas():
			add_to_cauldron.emit(self)
	
	if item_dragged == self:
		position = get_viewport().get_mouse_position()
		
		
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print(name + " is dragging")
		#is_dragging = true
		#position = get_viewport().get_mouse_position()
	#elif is_dragging:
		#is_dragging = false
		#print(name + " is not dragging")
		#position = starting_position
		#if cauldron_area2d in $Area2D.get_overlapping_areas():
			#add_to_cauldron.emit(self)


func _on_control_mouse_entered() -> void:
	is_mouse_hovering = true


func _on_control_mouse_exited() -> void:
	is_mouse_hovering = false
