extends Node

signal currency_updated

var currency: int = 0:
	set(value):		
		currency = max(0, value)
		currency_updated.emit()
