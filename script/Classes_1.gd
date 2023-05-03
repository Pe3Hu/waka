extends Node


#Телега
class Wagen:
	var obj = {}


	func _init(input_) -> void:
		obj.wohnwagen = null
		obj.zunft = input_.zunft


#Караван
class Wohnwagen:
	var num = {}
	var vec = {}
	var obj = {}
	var arr = {}
	var color = {}
	var flag = {}
	var scene = {}


	func _init(input_) -> void:
		num.speed = 30
		vec.grid = null
		obj.zunft = input_.zunft
		num.size = input_.size
		color.background = Color()
		arr.wagen = []
		obj.gabiet = {}
		obj.gabiet.previous = null
		obj.gabiet.current = null
		obj.gabiet.next = null
		flag.moving = false
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.wohnwagen.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("Wohnwagens").add_child(scene.myself)


	func add_wagen(wagen_) -> void:
		arr.wagen.append(wagen_)
		wagen_.obj.wohnwagen = self


	func set_gebiet(gabiet_) -> void:
		obj.gabiet.current = gabiet_
		obj.gabiet.current.obj.wohnwagen = self
		scene.myself.update_position()


	func select_next_gebiet() -> void:
		if !flag.moving &&  obj.gabiet.current != null:
			var options = obj.gabiet.current.dict.neighbor.keys()
			var next = Global.get_random_element(options)
			obj.gabiet.next = next
			scene.myself.move_to_next_gebiet()


	func radar() -> void:
		var rings = 3
		var arounds = Global.obj.insel.get_clusters_around_cluster(obj.gabiet.current.obj.cluster, rings)
		var element = "Fire"
		arounds.pop_front()
		
		for clusters in arounds:
			for cluster in clusters:
				if cluster.flag.eruption:
					print(cluster.word.element)


#Гильдия
class Zunft:
	var word = {}
	var arr = {}


	func _init(input_) -> void:
		word.title = input_.title
		init_wohnwagens()
		init_wagens()
		spread_wagens()
		set_start_location()


	func init_wohnwagens() -> void:
		arr.wohnwagen = []
		var sizes = [2]
		
		for _i in sizes.size():
			var input = {}
			input.zunft = self
			input.size = sizes[_i]
			var wohnwagen = Classes_1.Wohnwagen.new(input)
			arr.wohnwagen.append(wohnwagen)


	func init_wagens() -> void:
		arr.wagen = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.type = "search"
			input.zunft = self
			var wagen = Classes_1.Wagen.new(input)
			arr.wagen.append(wagen)


	func spread_wagens() -> void:
		var wagen = arr.wagen.front()
		var wohnwagen = arr.wohnwagen.front()
		wohnwagen.add_wagen(wagen)


	func set_start_location() -> void:
		var wohnwagen = arr.wohnwagen.front()
		var clusters = []
		
		for cluster in Global.obj.insel.arr.cluster:
			if !cluster.flag.eruption && cluster.arr.neighbor.size() < cluster.arr.gebiet.size()-1 && cluster.obj.center.obj.wohnwagen == null:
				clusters.append(cluster)
		
		var cluster = Global.get_random_element(clusters)
		wohnwagen.set_gebiet(cluster.obj.center) 
