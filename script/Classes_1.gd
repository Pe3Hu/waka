extends Node


#Телега
class Wagen:
	var obj = {}


	func _init(input_) -> void:
		obj.wohnwagen = null
		obj.zunft = input_.zunft


#Прицеп
class Trailer:
	var num = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		obj.wohnwagen = input_.wohnwagen
		init_cargo()


	func init_cargo() -> void:
		arr.nugget = []
		num.cargo = {}
		num.cargo.current = 0
		num.cargo.max = 10000.0


	func chipping_away_at_nugget(erzlager_) -> void:
		var max_nugget = min(erzlager_.num.fossil.current, obj.wohnwagen.num.drill)
		var drill_step = 10
		var iteration = 0
		var nugget = 0
		var fiasco = {}
		fiasco[true] = 100.0
		fiasco[false] = 0
		
		while Global.get_random_key(fiasco):
			iteration += 1.0
			nugget += drill_step*iteration
			
			fiasco[true] = 1.0/(iteration+1.0)
			fiasco[false] =  1.0-fiasco[true]
			
			if nugget >= max_nugget:
				fiasco[false] = 1.0
				fiasco[true] = 0.0
		
		print("nugget_size: ", nugget)
		erzlager_.num.fossil.current -= nugget
		add_nugget(nugget)


	func add_nugget(nugget_) -> void:
		arr.nugget.append(nugget_)
		num.cargo.current += nugget_
		
		if num.cargo.current > num.cargo.max:
			print("overcargo")


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
		num.speed = 300
		num.drill = 100
		vec.grid = null
		obj.zunft = input_.zunft
		num.size = input_.size
		color.background = Color()
		arr.wagen = []
		arr.schedule = []
		arr.erzlager = []
		obj.gebiet = {}
		obj.gebiet.previous = null
		obj.gebiet.current = null
		obj.gebiet.next = null
		obj.gebiet.destination = null
		obj.cluster = {}
		obj.cluster.destination = null
		init_scene()
		init_trailer()
		arr.schedule.append("echo sounding")


	func init_scene() -> void:
		scene.myself = Global.scene.wohnwagen.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("Wohnwagens").add_child(scene.myself)


	func init_trailer() -> void:
		var input = {}
		input.wohnwagen = self
		obj.trailer = Classes_1.Trailer.new(input)


	func add_wagen(wagen_) -> void:
		arr.wagen.append(wagen_)
		wagen_.obj.wohnwagen = self


	func set_gebiet(gebiet_) -> void:
		obj.gebiet.current = gebiet_
		obj.gebiet.current.obj.wohnwagen = self
		scene.myself.update_position()


	func follow_schedule() -> void:
		if  arr.schedule.size() > 0:
			var action = arr.schedule.pop_front()
			print(action)
			
			match action:
				"echo sounding":
					radar()
				"moving":
					get_closer_to_destination()
				"scanning":
					assess_near_gebiets()
					drilling_gebiet_selection()
				"drilling":
					drill()


	func radar() -> void:
		var rings = 3
		var arounds = Global.obj.insel.get_clusters_around_cluster(obj.gebiet.current.obj.cluster, rings)
		arounds.pop_front()
		var datas = []
		var weight_of_curbeds = {
			"Fire": 0.6,
			"Halo": 0.3,
			"Earth": 0.1
		}
		
		for _i in arounds.size():
			for cluster in arounds[_i]:
				if cluster.flag.eruption and weight_of_curbeds.keys().has(cluster.word.element):
					var data = {}
					data.cluster = cluster
					data.element = cluster.word.element
					data.ring = _i+1
					datas.append(data) 
		
		datas.sort_custom(func(a, b): return a.ring < b.ring)
		
		var options = {}
		
		for data in datas:
			if data.ring == datas.front().ring:
				options[data.cluster] = weight_of_curbeds[data.element]
		
		if options.keys().size() == 0:
			for neighbor in obj.gebiet.current.obj.cluster.arr.neighbor:
				options[neighbor] = 1
		
		obj.cluster.destination = Global.get_random_key(options)
		obj.gebiet.destination = null
		arr.schedule.append("moving")
		scene.myself.use_radar()


	func get_closer_to_destination() -> void:
		if obj.gebiet.current != null and (obj.cluster.destination != null or obj.gebiet.destination != null):
			var main_direction = Vector2()
			
			if obj.cluster.destination != null:
				main_direction = obj.cluster.destination.obj.center.vec.grid
			
			if obj.gebiet.destination != null:
				main_direction = obj.gebiet.destination.vec.grid
			
			main_direction -= obj.gebiet.current.vec.grid
			
			var main_distance = abs(main_direction.x)+abs(main_direction.y)
			
			if main_distance > 0:
				var options = {}
				
				for neighbor in obj.gebiet.current.dict.neighbor.keys():
					var neighbor_direction = obj.gebiet.current.dict.neighbor[neighbor]
					var neighbor_distance = abs(neighbor_direction.x-main_direction.x)+abs(neighbor_direction.y-main_direction.y)
					
					if neighbor_distance < main_distance:
						options[neighbor] = main_distance-neighbor_distance
					
				obj.gebiet.next = Global.get_random_key(options)
				scene.myself.move_to_next_gebiet()
			else:
				#print("Wtf shedule")
				obj.gebiet.next = obj.gebiet.current
				parking()


	func parking() -> void:
		obj.gebiet.current = obj.gebiet.next
		obj.gebiet.next = null
		
		if obj.cluster.destination != null:
			if obj.gebiet.current.obj.cluster == obj.cluster.destination:
				obj.cluster.destination = null
				arr.schedule.append("scanning")
		
		
		if obj.gebiet.destination != null:
			if obj.gebiet.current == obj.gebiet.destination:
				obj.gebiet.destination = null
				arr.schedule.append("drilling")
		
		if obj.cluster.destination != null or obj.gebiet.destination != null:
			arr.schedule.append("moving")
		
		follow_schedule()


	func assess_near_gebiets() -> void:
		for gebiet in obj.gebiet.current.obj.cluster.arr.gebiet:
			if !gebiet.obj.erzlager.arr.access.has(self):
				gebiet.obj.erzlager.arr.access.append(self)
				arr.erzlager.append(gebiet.obj.erzlager)


	func drilling_gebiet_selection() -> void:
		var options = {}
		
		for erzlager in arr.erzlager:
			if erzlager.obj.gebiet.obj.cluster == obj.gebiet.current.obj.cluster:
				var weight = max(erzlager.num.fossil.current-num.drill,0)
				var distance = 2
				
				if erzlager.obj.gebiet == obj.gebiet.current:
					distance = 0
				
				if obj.gebiet.current.dict.neighbor.keys().has(erzlager.obj.gebiet):
					distance = 1
				
				weight = float(weight)*((2-distance)*0.25+0.75)
				
				if weight > 0:
					options[erzlager.obj.gebiet] = weight
		
		if options.keys().size() > 0:
			obj.gebiet.destination = Global.get_random_key(options)
			
			if obj.gebiet.destination == obj.gebiet.current:
				arr.schedule.append("drilling")
				obj.gebiet.destination = null
			else:
				arr.schedule.append("moving")
			
			scene.myself.use_scan()
		else:
			arr.schedule.append("echo sounding")
			follow_schedule()


	func drill() -> void:
		if obj.gebiet.current.obj.erzlager.num.fossil.current >= num.drill:
			arr.schedule.append("drilling")
			scene.myself.use_drill()
			obj.gebiet.current.scene.myself.recolor_by_erzlager()
		else:
			scene.myself.end_drill()

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
			if !cluster.flag.eruption and cluster.arr.neighbor.size() < cluster.arr.gebiet.size()-1 and cluster.obj.center.obj.wohnwagen == null:
				clusters.append(cluster)
		
		var cluster = Global.get_random_element(clusters)
		wohnwagen.set_gebiet(cluster.obj.center) 
