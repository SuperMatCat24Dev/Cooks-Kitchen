extends Node2D
class_name Customer

var order_display = preload("res://Scenes/Customers/order_display.tscn")

@export_enum("Regular") var type := "Regular"
@onready var orders = list_files_in_directory("res://Resources/Orders/" + type + "/")
var order : Order

var happiness = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		check_order()

func _ready() -> void:
	randomize()
	randomise_order()

func  _process(delta: float) -> void:
	$Happiness.text = str(happiness)

func randomise_order():
	var currentorder = orders[randi()%orders.size()]
	var loadedorder = ResourceLoader.load("res://Resources/Orders/" + type + "/" + currentorder, "Order", ResourceLoader.CACHE_MODE_IGNORE)
	if loadedorder.difficulty <= Global.difficulty:
		order = loadedorder
	else:
		randomise_order()
	create_order_display()

func create_order_display():
	for children in $Panel/GridContainer.get_children():
		children.queue_free()
	
	var i = 0
	while i < order.order.size():
		happiness += order.order[i].Amount
		var display = order_display.instantiate()
		var ingred_txt = order.order[i].Item.instantiate()
		$Panel/GridContainer.add_child(display)
		display.get_node("Texture").texture = ingred_txt.sprite
		display.get_node("Amount").text = str(order.order[i].Amount)
		ingred_txt.free()
		i += 1

func list_files_in_directory(path):

	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	return files

func clear_ingredients():
	for children in $Area2D.get_overlapping_bodies():
		if children is Ingredient:
			children.queue_free()

func check_order():
	var total_order_check = order.order.duplicate()
	
	for children in get_tree().current_scene.get_children():
		
		if children is Ingredient:
			
			var i = 0
			var order_check : Array = order.order
			
			check_bad_ingredient(order_check, children)
			
			while i < order_check.size():
				var ingred_check = order_check[i].Item.instantiate()
				
				if children.scene_file_path == ingred_check.scene_file_path:
					total_order_check[i].Amount -= 1
					Global.score += 50
					Hud.time_left += 2
				
				ingred_check.free()
				i += 1
	var ii = 0
	while ii < total_order_check.size():
		if not total_order_check[ii].Amount == 0:
			happiness -= abs(total_order_check[ii].Amount) * 3
			Hud.time_left -= 12
		ii += 1
	check_ingredient_height()
	
	Global.difficulty += 1
	clear_ingredients()
	randomise_order()

func check_ingredient_height():
	var ingredient_list = []
	for children in get_tree().current_scene.get_children():
		if children is Ingredient:	
			ingredient_list.append(children)
	
	ingredient_list.sort_custom(func(a, b): return a.global_position.y < b.global_position.y)
	if ingredient_list.is_empty(): return
	if not ingredient_list.front().is_in_group("Topper"):
		happiness -= 10
		Hud.time_left -= 40
		Global.score -= 200
	if not ingredient_list.back().is_in_group("Topper"):
		happiness -= 10
		Hud.time_left -= 40
		Global.score -= 200

func check_bad_ingredient(order_check, child):
	pass
	#for i in order_check.size():
	#	var ingred_check = order_check[i].Item.instantiate()
	#	if child.scene_file_path == ingred_check.scene_file_path:
	#		ingred_check.free()
	#		break
	#		return
	#	ingred_check.free()
	#happiness -= 1
