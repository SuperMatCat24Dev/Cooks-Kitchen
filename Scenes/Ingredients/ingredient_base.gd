extends RigidBody2D
class_name Ingredient

@export var sprite : CompressedTexture2D
@export var cook_time := 30.0
@export var cook_result : PackedScene

@onready var time_left := cook_time

var cooking = false
var hold = true

func _integrate_forces(state):
	if not hold: return
	visible = true

	var t = state.get_transform()

	t.origin.x = get_global_mouse_position().x
	t.origin.y = 100
	
	state.linear_velocity = Vector2.ZERO
	
	state.set_transform(t)

func _ready() -> void:
	$ProgressBar.visible = false
	$ProgressBar.set_max(cook_time)

func _process(delta: float) -> void:
	if cooking: time_left -= delta
	$ProgressBar.set_value(time_left)
	
	if time_left <= 0: finished_cooking()
	
	if global_position.y >= 2000:
		Events.food_fell.emit()
		Events.food_array.erase(self)
		queue_free()
	
	if not Input.is_action_pressed("mouse_down"):
		hold = false
	if not hold: return
	var axis = Input.get_axis("left", "right")
	var rot = angular_velocity + axis * 200
	angular_velocity = rot

func finished_cooking():
	if not cook_result: return
	var ins = cook_result.instantiate()
	get_parent().add_child(ins)
	ins.global_position = global_position
	ins.hold = false
	queue_free()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("CookArea"): return
	$ProgressBar.visible = true
	cooking = true

func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("CookArea"): return
	$ProgressBar.visible = false
	cooking = false
