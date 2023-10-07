extends RigidBody2D
class_name Ingredient

@export var sprite : CompressedTexture2D

var hold = true

func _integrate_forces(state):
	if not hold: return

	var t = state.get_transform()

	t.origin.x = get_global_mouse_position().x
	t.origin.y = 250
	
	state.linear_velocity = Vector2.ZERO
	
	state.set_transform(t)

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(_screen_exited)

func _process(delta: float) -> void:
	if not Input.is_action_pressed("mouse_down"):
		hold = false
	if not hold: return
	var axis = Input.get_axis("left", "right")
	var rot = angular_velocity + axis * 200
	angular_velocity = rot

func _screen_exited() -> void:
	Events.food_fell.emit()
	Events.food_array.erase(self)
	queue_free()
