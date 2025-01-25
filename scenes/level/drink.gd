class_name Drink extends Node

var is_generic: bool
var texture: Texture2D
var color: Color
var sell_price: int # in cents

func _init(name: String, sell_price: int, texture: Texture2D=null, is_generic: bool=false, color: Color=Color.DARK_ORANGE) -> void:
	self.name = name
	self.texture = texture
	self.color = color
	self.sell_price = sell_price
