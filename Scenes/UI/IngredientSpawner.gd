extends CanvasLayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_down"):
		if Global.current_ingredient:
			var spawn = Global.current_ingredient.instantiate()
			get_tree().current_scene.add_child(spawn, true)
			Events.food_added.emit(spawn)
			Events.food_array.append(spawn)
			spawn.global_position.y = 100
			spawn.global_position.x = get_tree().current_scene.get_global_mouse_position().x
  
func _on_left_pressed() -> void:
	press_key("ui_left")

func _on_right_pressed() -> void:
	press_key("ui_right")

func press_key(key: String):
	var cancel_event = InputEventAction.new()
	cancel_event.action = key
	cancel_event.pressed = true
	Input.parse_input_event(cancel_event)

