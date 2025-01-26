extends AnimatedSprite2D

func update_currency(currency: int) -> void:
	$Label.text = "$%.2f" % (float(currency) / 100.0)
	if currency >= 100000:
		frame = 1
	else:
		frame = 0
