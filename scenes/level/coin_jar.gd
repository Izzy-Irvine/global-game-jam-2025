extends Sprite2D

func update_currency(currency: int) -> void:
	$Label.text = "$%.2f" % (float(currency) / 100.0)
