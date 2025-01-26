class_name Drink extends Node

static var generic_texture: Texture2D = load("res://scenes/level/Fill_rocks glass.png")

var is_generic: bool
var texture: Texture2D
var color: Color
var sell_price: int # in cents

func _init(name: String, sell_price: int, texture: Texture2D=null, is_generic: bool=false, color: Color=Color.DARK_ORANGE) -> void:
	self.name = name
	if texture == null:
		self.texture = generic_texture
	else:
		self.texture = texture
	self.color = color
	self.sell_price = sell_price
	self.is_generic = is_generic
