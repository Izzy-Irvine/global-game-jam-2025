extends Sprite2D


func _ready() -> void:
	Globals.currency_updated.connect(update_currency)
	update_currency()


func _process(delta: float) -> void:
	Globals.currency += 1
	pass


func update_currency() -> void:
	$Label.text = "$%.2f" % (float(Globals.currency) / 100.0)
