extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}


func init_num() -> void:
	num.index = {}
	
	num.insel = {}
	num.insel.rings = 25
	num.insel.sectors = 3
	num.insel.boundary = 3
	num.insel.a = 10
	num.insel.h = 2*num.insel.a
	num.insel.w = sqrt(3)*num.insel.a
	num.insel.neighbors = 6
	
	num.meilenstein = {}
	num.meilenstein.n = num.insel.rings*2-1
	num.meilenstein.rows = 4+(num.meilenstein.n-1)*2
	num.meilenstein.cols = 1+num.meilenstein.n
	
	num.lied = {}
	num.lied.min_size = {}
	num.lied.min_size.masters = 1
	num.lied.min_size.hierarchy = 3
	num.lied.min_size.pureblood = 3


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	dict.element = {}
	dict.element.antipode = {
		"Aqua": "Fire",
		"Wind": "Earth",
		"Fire": "Aqua",
		"Earth": "Wind",
		"Halo": "Dark",
		"Dark": "Halo"
	}
	
	init_sin()
	init_lied()


func init_sin() -> void:
	dict.alphabet = {}
	var path = "res://asset/json/alphabet_data.json"
	var array = load_data(path)
	dict.alphabet.sin = {}
	dict.alphabet.parameter = []
	
	for alphabet in array:
		var data = {}

		for key in alphabet.keys():
			if key != "sin" && alphabet[key] > 0:
				data[key] = alphabet[key]
				
				if !dict.alphabet.parameter.has(key):
					dict.alphabet.parameter.append(key)
		
		dict.alphabet.sin[alphabet["sin"]] = data


func init_lied() -> void:
	dict.lied = {}
	var path = "res://asset/json/lied_data.json"
	var array = load_data(path)
	dict.lied.name = {}
	dict.lied.parameter = {}
	
	for lied in array:
		var data = {}

		for key in lied.keys():
			if key != "name" && lied[key] > 0:
				data[key] = lied[key]
				
				if !dict.lied.parameter.keys().has(key):
					dict.lied.parameter[key] = {}
		
		dict.lied.name[lied["name"]] = data
		
	
	for key in dict.lied.name.keys():
		var lied = dict.lied.name[key]
		
		for parameter in lied.keys():
			if dict.lied.parameter[parameter].has(lied[parameter]):
				dict.lied.parameter[parameter][lied[parameter]].append(key)
			else:
				dict.lied.parameter[parameter][lied[parameter]] = [key]
	


func init_arr() -> void:
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.element = ["Aqua","Wind","Fire","Earth","Halo","Dark"]
	
	arr.neighbor = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 1, 1), 
			Vector2( 0, 1), 
			Vector2(-1, 0),
			Vector2( 0,-1)
		],
		[
			Vector2( 0,-1),
			Vector2( 1, 0),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2(-1,-1)
		]
	]
	
	arr.spin = [
		[
			Vector2( 1,-1), 
			Vector2( 0, 1), 
			Vector2( 0, 1), 
			Vector2( 0, 1), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2( 0,-1),
			Vector2( 0,-1),
			Vector2( 0,-1)
		]
	]


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.insel = load("res://scene/0/insel.tscn")
	scene.gebiet = load("res://scene/0/gebiet.tscn")
	scene.wohnwagen = load("res://scene/1/wohnwagen.tscn")


func init_vec():
	vec.size = {}
	vec.offset = {}
	init_window_size()
	
	vec.offset.insel = vec.size.window.center
	vec.offset.insel.y -= Global.num.insel.h/2
	vec.offset.insel.x -= Global.num.insel.w
	vec.offset.insel.x -= (num.meilenstein.rows-1)*num.insel.w / 4
	vec.offset.insel.y -= (num.meilenstein.cols+0.5*(num.meilenstein.n-1))*num.insel.h / 4


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func _ready() -> void:
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_scene()
	init_vec()


func get_random_element(arr_: Array):
	if arr_.size() == 0:
		print("!bug! empty array in get_random_element func")
		return null
	
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]


func split_two_point(points_: Array, delta_: float):
	var a = points_.front()
	var b = points_.back()
	var x = (a.x+b.x*delta_)/(1+delta_)
	var y = (a.y+b.y*delta_)/(1+delta_)
	var point = Vector2(x, y)
	return point


func save(path_: String, data_: String):
	var path = path_+".json"
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.save(data_)
	file.close()


func load_data(path_: String):
	var file = FileAccess.open(path_,FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_manhattan_distance(a_: Vector3, b_: Vector3) -> int:
	var d = 0
	d += abs(a_.x-b_.x)
	d += abs(a_.y-b_.y)
	d += abs(a_.z-b_.z)
	return d


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func reverse_weights(dict_: Dictionary) -> Dictionary:
	var result = {}
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	for key in dict_.keys():
		result[key] = total-dict_[key]
	
	total = 0
	
	for key in result.keys():
		total += result[key]
	
	for key in result.keys():
		result[key] = round(float(result[key])/total*100)
	
	return result


func from_weight_to_percentage(dict_: Dictionary) -> Dictionary:
	var result = {}
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	for key in dict_.keys():
		result[key] = round(float(dict_[key])/total*100)
	
	return result
