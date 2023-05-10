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
	num.index.rune = 0
	
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
	num.lied.min_size.servants = 1
	num.lied.min_size.hierarchy = 3
	num.lied.min_size.pureblood = 3
	
	num.title = {}
	num.title.max_size = 20
	
	num.modul = {}
	num.modul.indicator = {}
	num.modul.indicator[0] = {}
	num.modul.indicator[0].basis = 10
	num.modul.indicator[0].deviation = 3
	num.modul.indicator[1] = {}
	num.modul.indicator[1].basis = 12
	num.modul.indicator[1].deviation = 4
	num.modul.indicator[2] = {}
	num.modul.indicator[2].basis = 15
	num.modul.indicator[2].deviation = 5
	
	init_module_prices()
	
	num.modul.weight = {}
	num.modul.weight.modul = {}
	num.modul.weight.modul["motor"] = 1500
	num.modul.weight.modul["locator"] = 800
	num.modul.weight.modul["handler"] = 1000
	num.modul.weight.modul["packer"] = 750
	num.modul.weight.modul["spear"] = 1250
	num.modul.weight.modul["shield"] = 1250
	num.modul.weight.rank = 0.25


func init_module_prices() -> void:
	num.modul.price = {}
	num.modul.price.rank = {}
	num.modul.price.rank[0] = 100
	num.modul.price.rank[1] = 125
	num.modul.price.rank[2] = 175
	num.modul.price.deviation = {}
	
	var max_deviation = 0
	
	for rank in num.modul.indicator.keys():
		if max_deviation < num.modul.indicator[rank].deviation:
			max_deviation = num.modul.indicator[rank].deviation
	
	var prices = []
	var price = -1
	var step = 11
	
	for _i in max_deviation:
		price += step
		prices.append(price)
		step += 1
	
	prices.push_front(0)
	
	for _i in prices.size():
		num.modul.price.deviation[_i] = prices[_i]
		
		if _i != 0:
			num.modul.price.deviation[-_i] = -prices[_i]


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
	
	var max_hue = 360.0
	
	dict.element.hue = {
		"Fire": 350/max_hue,
		"Wind": 180/max_hue,
		"Aqua": 220/max_hue,
		"Earth": 100/max_hue,
		"Halo": 60/max_hue,
		"Dark": 290/max_hue,
	}
	
	init_sin()
	init_lied()
	init_title()
	init_karkasse()
	init_modul()


func init_sin() -> void:
	dict.alphabet = {}
	var path = "res://asset/json/alphabet_data.json"
	var array = load_data(path)
	dict.alphabet.sin = {}
	dict.alphabet.parameter = []
	
	for alphabet in array:
		var data = {}

		for key in alphabet.keys():
			if key != "sin":
				data[key] = alphabet[key]
				
				if !dict.alphabet.parameter.has(key) and key != "tint":
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
			if key != "name" and lied[key] > 0:
				data[key] = lied[key]
				
				if !dict.lied.parameter.keys().has(key):
					dict.lied.parameter[key] = {}
		
		dict.lied.name[lied["name"]] = data
		
	
	for key in dict.lied.name.keys():
		var lied = dict.lied.name[key]
		
		for parameter in lied.keys():
			var size = int(lied[parameter])
			
			if dict.lied.parameter[parameter].has(size):
				dict.lied.parameter[parameter][size].append(key)
			else:
				dict.lied.parameter[parameter][size] = [key]


func init_title() -> void:
	dict.title = {}
	var path = "res://asset/json/wohnwagen_title_data.json"
	var array = load_data(path)
	
	for key in array.front().keys():
		dict.title[key] = []
	
	for dict_ in array:
		for key in dict_.keys():
			dict.title[key].append(dict_[key])


func init_karkasse() -> void:
	dict.karkasse = {}
	var path = "res://asset/json/karkasse_data.json"
	var array = load_data(path)
	dict.karkasse.nickname = {}
	dict.karkasse.prices = []
	
	for karkasse in array:
		var data = {}

		for key in karkasse.keys():
			if key != "nickname" and karkasse[key] > 0:
				data[key] = karkasse[key]
			
		if !dict.karkasse.prices.has(karkasse["price"]):
			dict.karkasse.prices.append(karkasse["price"])
		
		dict.karkasse.nickname[karkasse["nickname"]] = data
	
	dict.karkasse.prices.sort_custom(func(a, b): return a > b)
	
	for nickname in dict.karkasse.nickname:
		var karkasse = dict.karkasse.nickname[nickname]
		var rarity = dict.karkasse.prices.find(dict.karkasse.nickname[nickname]["price"])
		var degree = rarity
		karkasse.rarity = pow(rarity+1,degree)


func init_modul() -> void:
	dict.modul = {}
	dict.modul.aspect = {}
	dict.modul.aspect["speed"] = "motor"
	dict.modul.aspect["drill"] = "motor"
	dict.modul.aspect["radar"] = "locator"
	dict.modul.aspect["jewellery"] = "locator"
	dict.modul.aspect["memory"] = "handler"
	dict.modul.aspect["intellect"] = "handler"
	dict.modul.aspect["price"] = "handler"
	dict.modul.aspect["cargo"] = "packer"
	dict.modul.aspect["tempo"] = "packer"
	dict.modul.aspect["attack"] = "spear"
	dict.modul.aspect["debuff"] = "spear"
	dict.modul.aspect["defense"] = "shield"
	dict.modul.aspect["buff"] = "shield"
	
	arr.modul = []
	
	for key in dict.modul.aspect.keys():
		var modul = dict.modul.aspect[key]
		
		if !arr.modul.has(modul):
			arr.modul.append(modul)


func init_arr() -> void:
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.element = ["Aqua","Wind","Fire","Earth","Halo","Dark"]
	arr.title = []
	
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
	scene.heer = load("res://scene/1/Heer.tscn")
	scene.wohnwagen = load("res://scene/1/wohnwagen.tscn")
	scene.trailer = load("res://scene/1/trailer.tscn")


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


func get_random_element(array_: Array):
	if array_.size() == 0:
		print("!bug! empty array in get_random_element func")
		return null
	
	rng.randomize()
	var index_r = rng.randi_range(0, array_.size()-1)
	return array_[index_r]


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


func generate_unique_title(type_: String) -> String:
	var title = generate_title(type_)
	
	while arr.title.has(title) or num.title.max_size < title.length():
		title = generate_title(type_)
	
	return title


func generate_title(type_: String) -> String:
	var title = ""
	
	if dict.title.keys().has(type_):
		dict.title = get_random_element(dict.title[type_])
	else:
		match type_:
			"Intro+Outro":
				var intro = get_random_element(dict.title["Intro"])
				var outro = get_random_element(dict.title["Outro"])
				title = intro + " " + outro
	
	return title


func fill_ethnography_parameters(obj_, runes_: Array) -> void:
		obj_.dict.ethnography = {}
		
		for parameter in Global.dict.lied.parameter:
			obj_.dict.ethnography[parameter] = {}
			
		var powers = []
		
		for rune in runes_:
			if obj_.dict.ethnography["servants"].keys().has(rune.num.density):
				obj_.dict.ethnography["servants"][rune.num.density].append(rune)
			else:
				obj_.dict.ethnography["servants"][rune.num.density] = [rune]
				powers.append(rune.num.density)
			
			if obj_.dict.ethnography["pureblood"].keys().has(rune.word.abbreviation):
				obj_.dict.ethnography["pureblood"][rune.word.abbreviation].append(rune)
			else:
				obj_.dict.ethnography["pureblood"][rune.word.abbreviation] = [rune]
		
		powers.sort()
		
		while powers.size() > 0:
			var power = powers.pop_front()
			obj_.dict.ethnography["hierarchy"][power] = [power]
			
			if powers.size() > 0:
				var next_power = powers.pop_front()
				
				while next_power == obj_.dict.ethnography["hierarchy"][power].back()+1:
					obj_.dict.ethnography["hierarchy"][power].append(next_power)
					next_power = powers.pop_front()
					
				powers.push_front(next_power)
		
		for parameter in obj_.dict.ethnography.keys():
			for _i in range(obj_.dict.ethnography[parameter].keys().size()-1,-1,-1):
				var key = obj_.dict.ethnography[parameter].keys()[_i]
				
				if obj_.dict.ethnography[parameter][key].size() < Global.num.lied.min_size[parameter]:
					obj_.dict.ethnography[parameter].erase(key)


func get_all_substitution(array_: Array):
	var result = [[]]
	
	for _i in array_.size():
		var slot_options = array_[_i]
		var next = []
		
		for arr_ in result:
			for option in slot_options:
				var pair = []
				pair.append_array(arr_)
				pair.append(option)
				next.append(pair)
		
		result = next
		for _j in range(result.size()-1,-1,-1):
			if result[_j].size() < _i+1:
				result.erase(result[_j])
	
	return result


func get_all_subparts(array_: Array, subpart_sizes_: Array, parametr_: String):
	var result = {}
	var perms = get_all_perms(array_)
	
	for subpart_size in subpart_sizes_:
		result[subpart_size] = []
	
	for perm in perms:
		for subpart_size in subpart_sizes_:
			var subpart = []
			
			for _i in subpart_size:
				subpart.append(perm[_i])
			
			match parametr_:
				"servants":
					subpart.sort_custom(func(a, b): return a.num.index > b.num.index)
				"pureblood":
					subpart.sort_custom(func(a, b): return a.num.index > b.num.index)
				"hierarchy":
					subpart.sort()
			
			if !result[subpart_size].has(subpart):
				result[subpart_size].append(subpart)
	
	return result


func get_all_perms(array_: Array):
	var result = []
	perm(result, array_, 0)
	return result


func perm(result_: Array, array_: Array, l_: int):
	if l_ >= array_.size():
		var array = []
		array.append_array(array_)
		result_.append(array)
		return
	
	perm(result_, array_, l_+1)
	
	for _i in range(l_+1,array_.size(),1):
		swap(array_, l_, _i)
		perm(result_, array_, l_+1)
		swap(array_, l_, _i)


func swap(array_: Array, i_: int, j_: int):
	var temp = array_[i_]
	array_[i_] = array_[j_]
	array_[j_] = temp


func conjunction(n_: int, m_: int) -> int:
	var result = factorial(n_)
	result /= factorial(n_ - m_)
	result /= factorial(m_)
	return result


func factorial(n_: int) -> int:
	var result = 1
	
	for _i in range(2,n_+1,1):
		result *= _i
	
	return result
