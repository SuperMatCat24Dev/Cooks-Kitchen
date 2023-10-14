extends Node2D

var screenwidth = ProjectSettings.get_setting("display/window/size/viewport_width")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.get_screen_center_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		global_position.x += screenwidth
	if event.is_action_pressed("ui_left"):
		global_position.x -= screenwidth
