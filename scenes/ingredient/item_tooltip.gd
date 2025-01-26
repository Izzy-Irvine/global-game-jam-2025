extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_custom_tooltip(for_text: String) -> Object:
	var label = Label.new()
	label.text = for_text
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 24
	return label
