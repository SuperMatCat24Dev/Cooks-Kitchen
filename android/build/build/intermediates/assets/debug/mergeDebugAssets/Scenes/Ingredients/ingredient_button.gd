extends TextureButton
class_name IngredientButton

@export var ingredient : PackedScene

func _ready() -> void:
	connect("button_down", _on_pressed)

func _on_pressed() -> void:
	if ingredient:
		Global.current_ingredient = ingredient
