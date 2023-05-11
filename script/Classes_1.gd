extends Node


#Караван
class Wohnwagen:
	var num = {}
	var word = {}
	var vec = {}
	var obj = {}
	var arr = {}
	var dict = {}
	var color = {}
	var scene = {}


	func _init(input_) -> void:
		word.task = "start stasis"
		word.title = Global.generate_unique_title("Intro+Outro")
		word.phase = {}
		word.phase.current = ""
		obj.zunft = input_.zunft
		num.size = input_.size
		vec.grid = null
		dict.status = {}
		color.background = Color()
		color.emblem = Color()
		init_num()
		init_arr()
		init_obj()
		init_scene()
		init_trailer()
		init_archivar()


	func init_num() -> void:
		num.speed = 3000
		num.drill = 100
		num.radar = {}
		num.radar.basic = 3
		num.radar.current = num.radar.basic
		
		num.weight = {}
		num.weight.element = {}
		var elements = []
		elements.append_array(Global.arr.element)
		var weights = [0.6,0.3,0.1]
		elements.shuffle()
		
		while elements.size() > 0:
			var element = elements.pop_front()
			elements.erase(Global.dict.element.antipode[element])
			num.weight.element[element] = weights.pop_front()


	func init_arr() -> void:
		arr.wagen = []
		arr.schedule = []
		arr.erzlager = []
		arr.log = []
		arr.phase = []
		arr.path = []
		arr.abkommen = []
		arr.destination = []


	func init_obj() -> void:
		obj.gebiet = {}
		obj.gebiet.previous = null
		obj.gebiet.current = null
		obj.gebiet.next = null
		obj.gebiet.destination = null
		obj.cluster = {}
		obj.cluster.destination = null
		obj.abkommen = null
		obj.verfolgung = null


	func init_scene() -> void:
		scene.myself = Global.scene.wohnwagen.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("Wohnwagens").add_child(scene.myself)


	func init_trailer() -> void:
		var input = {}
		input.wohnwagen = self
		obj.trailer = Classes_2.Trailer.new(input)


	func init_archivar() -> void:
		var input = {}
		input.wohnwagen = self
		obj.archivar = Classes_4.Archivar.new(input)


	func add_wagen(wagen_) -> void:
		arr.wagen.append(wagen_)
		wagen_.obj.wohnwagen = self


	func set_gebiet(gebiet_) -> void:
		obj.gebiet.current = gebiet_
		obj.gebiet.current.obj.wohnwagen = self
		scene.myself.update_position()


	func return_to_gewerkschaft() -> void:
		obj.gebiet.destination = obj.zunft.obj.gewerkschaft.obj.hauptsitz.obj.gebiet
		word.task = "dock at hauptsitz"


	func set_phases_by_task() -> void:
		arr.phase = []
		dict.status.phase = {}
		
		match word.task:
			"mineral extraction":
				arr.phase.append("searching cluster for drill")
				arr.phase.append("relocate into cluster")
				arr.phase.append("enter cluster")
				arr.phase.append("cluster develope")
				arr.phase.append("end of task")
			"fall into stasis":
				arr.phase.append("start stasis")
				arr.phase.append("end of task")
			"dock at hauptsitz":
				arr.phase.append("relocate into hauptsitz")
				arr.phase.append("end of task")
			"hauptsitz walk":
				arr.phase.append("anschlagbrett review")
				arr.phase.append("sign abkommen")
				arr.phase.append("end of task")
			"deliver":
				arr.phase.append("set next hauptsitz as destination")
				arr.phase.append("relocate into hauptsitz")
				arr.phase.append("get reward")
				arr.phase.append("end of task")
			"pick up":
				arr.phase.append("set next hauptsitz as destination")
				arr.phase.append("relocate into hauptsitz")
				arr.phase.append("pick up")
				arr.phase.append("set next hauptsitz as destination")
				arr.phase.append("relocate into hauptsitz")
				arr.phase.append("get reward")
				arr.phase.append("end of task")
			"piracy":
				arr.phase.append("searching for a robbery victim")
				arr.phase.append("relocate into verfolgung")
				arr.phase.append("prosecute")
				arr.phase.append("catch inspection")
				arr.phase.append("end of task")
		
		reset_phases()


	func reset_phases() -> void:
		arr.path = []
		
		for phase in arr.phase:
			dict.status.phase[phase] = false


	func follow_phase() -> void:
		word.phase.current = null
		
		for _i in arr.phase.size():
			word.phase.current = arr.phase[_i]
			
			if !dict.status.phase[word.phase.current]:
				break
		
		#print(word.phase.current)
		
		match word.phase.current:
			"searching cluster for drill":
				arr.schedule.append("echo sounding")
			"relocate into cluster":
				arr.schedule.append("moving")
			"enter cluster":
				arr.schedule.append("scanning")
			"cluster develope":
				arr.schedule.append("drill manvering")
			"start stasis":
				arr.schedule.append("waiting")
			"relocate into hauptsitz":
				arr.schedule.append("moving")
			"anschlagbrett review":
				arr.schedule.append("anschlagbrett reviewing")
			"sign abkommen":
				arr.schedule.append("abkommen signing")
			"set next hauptsitz as destination":
				arr.schedule.append("destination updating")
			"pick up":
				arr.schedule.append("shipment receipting")
			"get reward":
				arr.schedule.append("rewarding")
			"end of task":
				end_of_task()
		
		follow_schedule()


	func follow_schedule() -> void:
		if  arr.schedule.size() > 0:
			if arr.schedule.size() > 1:
				print(arr.schedule)
			
			var action = arr.schedule.pop_front()
			
			match action:
				"echo sounding":
					radar()
				"moving":
					get_closer_to_destination()
				"parking":
					stop_moving()
				"scanning":
					assess_near_gebiets()
				"drill manvering":
					drilling_gebiet_selection()
				"drilling":
					drill()
				"waiting":
					scene.myself.wait()
				"anschlagbrett reviewing":
					anschlagbrett_review()
				"abkommen signing":
					sign_abkommen()
				"destination updating":
					departure()
				"shipment receipting":
					get_freight()
				"rewarding":
					get_reward()
			
			arr.log.append(action)
			
			if arr.log.size() > 15:
				arr.log.pop_front()
		else:
			follow_phase()


	func radar() -> void:
		if obj.gebiet.current == null:
			print("radar error obj.gebiet.current")
			return
		
		var rings = num.radar.current
		var arounds = Global.obj.insel.get_clusters_around_cluster(obj.gebiet.current.obj.cluster, rings)
		arounds.pop_front()
		var datas = []
		
		for _i in arounds.size():
			for cluster in arounds[_i]:
				if cluster.flag.eruption and num.weight.element.keys().has(cluster.word.element):
					if cluster.arr.gebiet.size() != cluster.arr.developed.size():
						var data = {}
						data.cluster = cluster
						data.element = cluster.word.element
						data.ring = _i+1
						datas.append(data)
		
		datas.sort_custom(func(a, b): return a.ring < b.ring)
		
		var options = {}
		
		for data in datas:
			if data.ring == datas.front().ring:
				options[data.cluster] = num.weight.element[data.element]
		
		if options.keys().size() == 0:
			num.radar.current += 1
		else:
			num.radar.current = num.radar.basic
			obj.cluster.destination = Global.get_random_key(options)
			obj.gebiet.destination = null
			dict.status.phase[word.phase.current] = true
		
		scene.myself.use_radar()


	func get_closer_to_destination() -> void:
		if obj.gebiet.current != null and (obj.cluster.destination != null or obj.gebiet.destination != null):
			var main_direction = Vector2()
			var destination = null
			
			if obj.cluster.destination != null:
				destination = obj.cluster.destination.obj.center
			
			if obj.gebiet.destination != null:
				destination = obj.gebiet.destination
			
			var surroundeds = []
			
			if destination != null:
				for neighbor in destination.dict.neighbor.keys():
					if neighbor.obj.wohnwagen == null:
						var access = false
						
						for neighbor_ in neighbor.dict.neighbor.keys():
							if neighbor_.obj.wohnwagen == null:
								access = true
						
						if access:
							surroundeds.append(neighbor)
				
				if surroundeds.size() == 0:
					reset_phases()
					return
				else:
					if destination.obj.wohnwagen != null:
						shift_destination_focus(surroundeds)
						return
			
			main_direction = destination.vec.grid-obj.gebiet.current.vec.grid
			var main_distance = abs(main_direction.x)+abs(main_direction.y)
			
			if main_distance > 0:
				var options = {}
				var distance = {}
				distance.max = 0
				distance.min = Global.num.insel.a*Global.num.meilenstein.rows*Global.num.meilenstein.cols
				var optimal = false
				
				for neighbor in obj.gebiet.current.dict.neighbor.keys():
					if neighbor.obj.hauptsitz != null:
						if neighbor == obj.gebiet.destination:
							match word.phase.current:
								"relocate into hauptsitz":
									obj.hauptsitz = neighbor.obj.hauptsitz
									dict.status.phase[word.phase.current] = true
									follow_phase()
									return
					elif neighbor.obj.wohnwagen == null and !arr.path.has(neighbor):
						var neighbor_direction = obj.gebiet.current.dict.neighbor[neighbor]
						var neighbor_distance = abs(neighbor_direction.x-main_direction.x)+abs(neighbor_direction.y-main_direction.y)
						
						if neighbor_distance < main_distance:
							optimal = true
						
						options[neighbor] = main_distance-neighbor_distance
						
						if distance.max < neighbor_distance:
							distance.max = neighbor_distance
						
						if distance.min > neighbor_distance:
							distance.min = neighbor_distance
				
				for neighbor in options.keys():
					if optimal:
						if options[neighbor] < 0:
							options.erase(neighbor)
					else:
						options[neighbor] = pow((distance.max-options[neighbor]),2)
				
				if options.size() == 0:
					arr.schedule.append("waiting")
					follow_schedule()
				else:
					obj.gebiet.next = Global.get_random_key(options)
					arr.schedule.append("parking")
					scene.myself.move_to_next_gebiet()
			else:
				obj.gebiet.next = obj.gebiet.current
				arr.schedule.append("parking")
				follow_schedule()


	func shift_destination_focus(surroundeds_: Array) -> void:
		obj.gebiet.destination = Global.get_random_element(surroundeds_)
		follow_phase()


	func after_stop_action() -> void:
		if obj.gebiet.current == null:
			print("error stop moving")
			obj.gebiet.destination = obj.gebiet.previous
			obj.gebiet.previous = obj.gebiet.next
			follow_phase()
			return
		
		if obj.cluster.destination != null:
				if obj.gebiet.current.obj.cluster == obj.cluster.destination:
					obj.cluster.destination = null
					dict.status.phase[word.phase.current] = true
		
		if obj.gebiet.destination != null:
			if obj.gebiet.current == obj.gebiet.destination:
				obj.gebiet.destination = null
				arr.schedule.append("drilling")
				obj.gebiet.current.obj.cluster.add_developed(obj.gebiet.current)
				obj.gebiet.current.obj.cluster.check_eruption()
			
		if obj.cluster.destination != null or obj.gebiet.destination != null:
			arr.schedule.append("moving")
		
		follow_schedule()


	func stop_moving() -> void:
		if obj.gebiet.next == null:
			print("error parking obj.gebiet.next")
			return
		
		#if obj.gebiet.current != obj.gebiet.next:
		obj.gebiet.current = obj.gebiet.next
		obj.gebiet.next = null
		after_stop_action()


	func assess_near_gebiets() -> void:
		for gebiet in obj.gebiet.current.obj.cluster.arr.gebiet:
			if !gebiet.obj.erzlager.arr.access.has(self):
				gebiet.obj.erzlager.arr.access.append(self)
				arr.erzlager.append(gebiet.obj.erzlager)
		
		dict.status.phase[word.phase.current] = true
		follow_phase()


	func drilling_gebiet_selection() -> void:
		if obj.gebiet.current == null:
			print("error in drilling_gebiet_selection obj.gebiet.current")
			print(obj.gebiet)
			return
		var options = {}
		
		for erzlager in arr.erzlager:
			if erzlager.obj.gebiet.obj.cluster == obj.gebiet.current.obj.cluster and erzlager.obj.gebiet.obj.wohnwagen == null:
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
				obj.gebiet.destination = null
				arr.schedule.append("drilling")
				obj.gebiet.current.obj.cluster.add_developed(obj.gebiet.current)
				obj.gebiet.current.obj.cluster.check_eruption()
			else:
				arr.schedule.append("moving")
			
			scene.myself.use_scan()
		else:
			dict.status.phase[word.phase.current] = true
			follow_phase()


	func drill() -> void:
		if obj.gebiet.current == null:
			print("drill obj.gebiet.current error")
			print(obj.gebiet)
			return
		
		if obj.gebiet.current.obj.erzlager.num.fossil.current >= num.drill:
			arr.schedule.append("drilling")
			scene.myself.use_drill()
			obj.gebiet.current.scene.myself.recolor_by_erzlager()
		else:
			follow_phase()


	func anschlagbrett_review() -> void:
		obj.abkommen = obj.hauptsitz.obj.anschlagbrett.arr.abkommen.front()
		dict.status.phase[word.phase.current] = true
		follow_phase()


	func sign_abkommen() -> void:
		if obj.hauptsitz.obj.anschlagbrett.arr.abkommen.size() == 0:
			dict.status.phase[word.phase.current] = true
		elif obj.hauptsitz.obj.anschlagbrett.arr.abkommen.has(obj.abkommen):
			obj.hauptsitz.obj.anschlagbrett.arr.abkommen.erase(obj.abkommen)
			arr.abkommen.append(obj.abkommen)
			arr.destination.append(obj.abkommen.obj.destination)
			
			match word.task:
				"pick up":
					arr.destination.append(obj.hauptsitz)
			
			dict.status.phase[word.phase.current] = true
		
			follow_phase()


	func departure() -> void:
		obj.gebiet.destination = arr.destination.pop_front()
		obj.hauptsitz = null
		dict.status.phase[word.phase.current] = true
		follow_phase()


	func get_freight() -> void:
		dict.status.phase[word.phase.current] = true
		follow_phase()


	func get_reward() -> void:
		dict.status.phase[word.phase.current] = true
		follow_phase()


	func end_of_task() -> void:
		match word.task:
			"dock at hauptsitz":
				word.task = "hauptsitz walk"
			"hauptsitz walk":
				if obj.abkommen == null:
					word.task = "fall into stasis"
				else:
					word.task = obj.abkommen.word.description
			"deliver":
				obj.abkommen = null
				return_to_gewerkschaft()
			"pick up":
				obj.abkommen = null
				return_to_gewerkschaft()
		
		word.task = word.task
		#print("____")
		#print("new task: ", word.task)
		#print("____")
		set_phases_by_task()


#Гильдия
class Zunft:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		num.members = 10
		word.title = input_.title
		obj.heer = input_.heer
		obj.gewerkschaft = null
		init_wohnwagens()
		init_wagens()
		init_treibers()
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
		
		for _i in num.members:
			var input = {}
			input.zunft = self
			var wagen = Classes_2.Wagen.new(input)
			arr.wagen.append(wagen)


	func init_treibers() -> void:
		arr.treiber = []
		
		for _i in num.members:
			var input = {}
			input.zunft = self
			var treiber = Classes_2.Treiber.new(input)
			arr.treiber.append(treiber)


	func spread_treibers() -> void:
		pass


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


#Армия
class Heer:
	var word = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_zunfts()
		spread_zunfts()


	func init_scene() -> void:
		scene.myself = Global.scene.heer.instantiate()
		Global.node.game.get_node("Layer1").add_child(scene.myself)


	func init_zunfts() -> void:
		arr.zunft = []
		var n = 3
		
		for _i in n:
			var input = {}
			input.heer = self
			input.title = str(_i)
			var zunft = Classes_1.Zunft.new(input)
			arr.zunft.append(zunft)


	func spread_zunfts() -> void:
		var zunfts = []
		var gewerkschafts = []
		zunfts.append_array(arr.zunft)
		gewerkschafts.append_array(Global.obj.handel.arr.gewerkschaft)
		zunfts.shuffle()
		gewerkschafts.shuffle()
		
		while zunfts.size() > 0:
			var zunft = zunfts.pop_front()
			var gewerkschaft = gewerkschafts.pop_front()
			gewerkschaft.bring_privateer(zunft)
			
			if gewerkschafts.size() == 0:
				gewerkschafts.append_array(Global.obj.handel.arr.gewerkschaft)
				gewerkschafts.shuffle()
