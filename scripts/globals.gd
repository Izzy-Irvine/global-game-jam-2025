extends Node

enum item_type {
	FIRE,
	ICE,
	WATER
}

var is_dragging = false
var cauldron_area2d: Area2D

var current_potion_ingredients: Array
