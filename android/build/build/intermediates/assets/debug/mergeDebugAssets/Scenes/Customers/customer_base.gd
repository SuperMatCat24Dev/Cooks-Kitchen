extends Node2D
class_name Customer

var order_display = preload("res://Scenes/Customers/order_display.tscn")

@export_enum("Regular") var type := "Regular"
var order : Order

var happiness = 10

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		check_order()

func _ready() -> void:
	randomise_order()

func randomise_order():
	randomize()
	var orders = list_files_in_directory("res://Resources/Orders/" + type + "/")
	var currentorder = orders[randi()%orders.size()]
	print(currentorder)
	order = load("res://Resources/Orders/" + type + "/" + currentorder)
	create_order_display()

func create_order_display():
	var i = 0
	while i < order.order.size():
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

func check_order():
	var total_order_check = order.order
	
	for children in get_tree().current_scene.get_children():
		
		if children is Ingredient:
			
			var i = 0
			var order_check : Array = order.order
			
			while i < order_check.size():
				var ingred_check = order_check[i].Item.instantiate()
				
				if children.scene_file_path == ingred_check.scene_file_path:
					total_order_check[i].Amount -= 1
				
				ingred_check.free()
				i += 1
	var ii = 0
	while ii < total_order_check.size():
		print(total_order_check[ii].Amount)
		ii += 1
