extends Node


#Телега
class Wagen:
	var obj = {}


	func _init(input_) -> void:
		obj.wohnwagen = null
		obj.zunft = input_.zunft


#Летопись
class Chronik:
	var obj = {}
	var arr = {}
	var dict = {}


	func _init(input_) -> void:
		obj.archivar = input_.archivar
		dict.ethnography = {}
		init_runes()
		init_parameters()


	func init_runes() -> void:
		arr.rune = {}
		#total runes
		arr.rune.archive = []
		#current runes
		arr.rune.thought = []
		#future runes
		arr.rune.insight = []
		#previous runes
		arr.rune.memoir = []
		#exiled runes
		arr.rune.forgotten = []


	func init_parameters() -> void:
		dict.ethnography = {}
		
		for parameter in Global.dict.lied.parameter:
			if parameter != "servants":
				dict.ethnography[parameter] = {}


	func fill_thought() -> void:
		if arr.rune.insight.size() == 0:
			arr.rune.archive.shuffle()
			fill_insight()
		
		var space_left = obj.archivar.num.memory-arr.rune.thought.size()
		var novelty = min(space_left, obj.archivar.num.intellect)
		
		for _i in novelty:
			var rune = arr.rune.insight.pop_front()
			arr.rune.thought.append(rune)
		
		fill_insight()
		highlight_ehroniks()


	func fill_insight() -> void:
		while obj.archivar.num.intellect > arr.rune.insight.size():
			pull_rune_from_archive()


	func pull_rune_from_archive() -> void:
		if arr.rune.archive.size() == 0:
			arr.rune.archive.append_array(arr.rune.memoir)
			arr.rune.memoir = []
		
		arr.rune.archive.shuffle()
		var rune = arr.rune.archive.pop_front()
		arr.rune.insight.append(rune)


	func highlight_ehroniks() -> void:
		arr.ehronik = []
		Global.fill_ethnography_parameters(self, arr.rune.thought)
		var ehronik_runes = []
		masters_and_pureblood_repositioning(ehronik_runes)
		hierarchy_repositioning(ehronik_runes)
		fill_ehroniks(ehronik_runes)


	func fill_parameters() -> void:
		init_parameters()
		var powers = []
		
		for rune in arr.rune.thought:
			if dict.ethnography["masters"].keys().has(rune.num.power):
				dict.ethnography["masters"][rune.num.power].append(rune)
			else:
				dict.ethnography["masters"][rune.num.power] = [rune]
				powers.append(rune.num.power)
			
			if dict.ethnography["pureblood"].keys().has(rune.word.abbreviation):
				dict.ethnography["pureblood"][rune.word.abbreviation].append(rune)
			else:
				dict.ethnography["pureblood"][rune.word.abbreviation] = [rune]
		
		powers.sort()
		
		while powers.size() > 0:
			var power = powers.pop_front()
			dict.ethnography["hierarchy"][power] = [power]
			
			if powers.size() > 0:
				var next_power = powers.pop_front()
				
				while next_power == dict.ethnography["hierarchy"][power].back()+1:
					dict.ethnography["hierarchy"][power].append(next_power)
					next_power = powers.pop_front()
					
				powers.push_front(next_power)
		
		for parameter in dict.ethnography.keys():
			for _i in range(dict.ethnography[parameter].keys().size()-1,-1,-1):
				var key = dict.ethnography[parameter].keys()[_i]
				
				if dict.ethnography[parameter][key].size() < Global.num.lied.min_size[parameter]:
					dict.ethnography[parameter].erase(key)


	func masters_and_pureblood_repositioning(ehronik_runes_: Array) -> void:
		var parameters = ["masters","pureblood"]
		
		for parameter in parameters:
			for power in dict.ethnography[parameter].keys():
				var subpart_sizes = []
				
				for size in range(Global.num.lied.min_size[parameter],dict.ethnography[parameter][power].size()+1,1):
					subpart_sizes.append(size)
				
				var subparts = Global.get_all_subparts(dict.ethnography[parameter][power], subpart_sizes, parameter)
				
				for size in subparts.keys():
					for runes in subparts[size]:
						if !ehronik_runes_.has(runes):
							ehronik_runes_.append(runes)


	func hierarchy_repositioning(ehronik_runes_) -> void:
		var parameter = "hierarchy"
		var powers = []
		
		for begin in dict.ethnography[parameter].keys():
			var runes = []
			var subpart_sizes = []
			
			for size in range(Global.num.lied.min_size[parameter],dict.ethnography[parameter][begin].size()+1,1):
				subpart_sizes.append(size)
			
			var subparts = Global.get_all_subparts(dict.ethnography[parameter][begin], subpart_sizes, parameter)
			
			for size in subparts.keys():
				for _i in range(subparts[size].size()-1,-1,-1):
					var hierarchy = true
					var subpart = subparts[size][_i]
			
					for _j in range(0,subpart.size()-1):
						if subpart[_j]+1 != subpart[_j+1]:
							hierarchy = false
							break
					
					if hierarchy && !powers.has(subpart):
						#subparts[size].erase(subpart)
						powers.append(subpart)
		
		
		for powers_ in powers:
			var options = []
			for power in powers_:
				options.append(dict.ethnography["masters"][power]) 
				
			var substitutions = Global.get_all_substitution(options)
			
			for runes in substitutions:
				runes.sort_custom(func(a, b): return a.num.index > b.num.index)
				
				if !ehronik_runes_.has(runes):
					ehronik_runes_.append(runes)


	func fill_ehroniks(ehronik_runes_) -> void:
		for runes in ehronik_runes_:
			var input = {}
			input.chronik = self
			input.runes = runes
			var ehronik = Classes_2.Entwurf.new(input)
			arr.ehronik.append(ehronik)


#Архивариус
class Archivar:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		num.intellect = 10
		num.memory = 10
		obj.wohnwagen = input_.wohnwagen
		init_chronik()
		set_standard_content_of_chronik()
		
		#obj.chronik.fill_thought()
		
		#for rune in obj.chronik.arr.rune.thought:
		#	print(rune.word.abbreviation,rune.num.power)


	func init_chronik() -> void:
		var input = {}
		input.archivar = self
		obj.chronik = Classes_1.Chronik.new(input)


	func set_standard_content_of_chronik() -> void:
		for alphabet in Global.obj.lexikon.arr.alphabet:
			for rune in alphabet.arr.rune:
				add_rune_to_chronik(rune)


	func add_rune_to_chronik(rune_) -> void:
		obj.chronik.arr.rune.archive.append(rune_)
 

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
		
		#print("nugget_size: ", nugget)
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
	var word = {}
	var vec = {}
	var obj = {}
	var arr = {}
	var dict = {}
	var color = {}
	var scene = {}


	func _init(input_) -> void:
		word.task = "erzlager developing"
		word.phase = {}
		word.phase.current = ""
		obj.zunft = input_.zunft
		num.size = input_.size
		vec.grid = null
		dict.status = {}
		color.background = Color()
		init_num()
		init_arr()
		init_obj()
		init_scene()
		init_trailer()
		init_archivar()
		
		set_phases_by_task()


	func init_num() -> void:
		num.speed = 300
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


	func init_obj() -> void:
		obj.gebiet = {}
		obj.gebiet.previous = null
		obj.gebiet.current = null
		obj.gebiet.next = null
		obj.gebiet.destination = null
		obj.cluster = {}
		obj.cluster.destination = null


	func init_scene() -> void:
		scene.myself = Global.scene.wohnwagen.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("Wohnwagens").add_child(scene.myself)


	func init_trailer() -> void:
		var input = {}
		input.wohnwagen = self
		obj.trailer = Classes_1.Trailer.new(input)


	func init_archivar() -> void:
		var input = {}
		input.wohnwagen = self
		obj.archivar = Classes_1.Archivar.new(input)


	func add_wagen(wagen_) -> void:
		arr.wagen.append(wagen_)
		wagen_.obj.wohnwagen = self


	func set_gebiet(gebiet_) -> void:
		obj.gebiet.current = gebiet_
		obj.gebiet.current.obj.wohnwagen = self
		scene.myself.update_position()


	func set_phases_by_task() -> void:
		arr.phase = []
		dict.status.phase = {}
		
		match word.task:
			"erzlager developing":
				arr.phase.append("finding cluster for drill")
				arr.phase.append("relocating into cluster")
				arr.phase.append("entering cluster")
				arr.phase.append("developing cluster")
				arr.phase.append("end of task")
		
		reset_phases()


	func reset_phases() -> void:
		for phase in arr.phase:
			dict.status.phase[phase] = false


	func follow_phase() -> void:
		word.phase.current = null
		
		for _i in arr.phase.size():
			word.phase.current = arr.phase[_i]
			
			if !dict.status.phase[word.phase.current]:
				break
		
		match word.phase.current:
			"finding cluster for drill":
				arr.schedule.append("echo sounding")
			"relocating into cluster":
				arr.schedule.append("moving")
			"entering cluster":
				arr.schedule.append("scanning")
			"developing cluster":
				arr.schedule.append("drill manvering")
			"end of task":
				set_phases_by_task()
		
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
					if neighbor.obj.wohnwagen == null:
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


#Гильдия
class Zunft:
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		obj.gewerkschaft = null
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


#Армия
class Heer:
	var word = {}
	var arr = {}
	var obj = {}


	func _init() -> void:
		init_zunfts()
		spread_zunfts()


	func init_zunfts() -> void:
		arr.zunft = []
		var n = 30
		
		for _i in n:
			var input = {}
			input.zunft = self
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
