class_name Drink extends Node

static var generic_texture: Texture2D = load("res://scenes/level/Moonlight Fizz.png")

var is_generic: bool
var texture: Texture2D
var color: Color
var sell_price: int # in cents

func _init(name: String, sell_price: int, texture: Texture2D=null, is_generic: bool=false, color: Color=Color.DARK_ORANGE) -> void:
	self.name = name
	self.texture = texture
	self.color = color
	self.sell_price = sell_price
	self.is_generic = is_generic

func apply_to_sprite(sprite: TextureRect):
	if texture == null:
		sprite.texture = generic_texture
	else:
		sprite.texture = texture
