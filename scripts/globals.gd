extends Node

signal currency_updated

enum item_type {
	FIRE,
	ICE,
	WATER
}

var currency: int = 1000: # in cents
	set(value):
		currency = max(0, value)
		currency_updated.emit()

var is_dragging = false
var cauldron_area2d: Area2D

var current_potion_ingredients: Array
