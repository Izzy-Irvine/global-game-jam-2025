extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.currency_updated.connect(update_coins)
	update_coins()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_coins() -> void:
	$Label.text = "$%.2f" % (float(Globals.currency) / 100.0)
