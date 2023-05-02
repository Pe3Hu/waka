extends Node


#Веха
class Meilenstein:
	var vec = {}

	func _init(input_):
		vec.grid = input_.grid
		vec.position = input_.position


#Область
class Gebiet:
	var num = {}
	var vec = {}
	var obj = {}
	var arr = {}
	var dict = {}
	var flag = {}
	var color = {}
	var scene = {}


	func _init(input_) -> void:
		vec.grid = input_.grid
		vec.center = Vector2()
		num.parity = int(vec.grid.y)%2
		arr.meilenstein = input_.meilensteins
		dict.neighbor = {}
		obj.insel = input_.insel
		obj.cluster = null
		flag.on_screen = true
		color.background = Color()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.gebiet.instantiate()
		scene.myself.set_parent(self)
		obj.insel.scene.myself.add_child(scene.myself)


#Кластер
class Cluster:
	var word = {}
	var arr = {}
	var obj = {}
	var flag = {}


	func _init(input_) -> void:
		word.color = "White"
		arr.gebiet = input_.gebiets
		arr.neighbor = []
		obj.center = input_.center
		obj.insel = input_.insel
		flag.on_screen = true
		
		for gebiet in arr.gebiet:
			gebiet.obj.cluster = self
		
		if arr.gebiet.size() == 7:
			add_neighbors()


	func add_neighbors() -> void:
		var ring = 2
		var arounds = obj.insel.get_gebiets_around_gebiet(obj.center, ring)
		
		for gebiet in arounds[ring]:
			if gebiet.obj.cluster != null and gebiet.flag.on_screen and !arr.neighbor.has(gebiet.obj.cluster):
				if gebiet.flag.on_screen:
					arr.neighbor.append(gebiet.obj.cluster)
					gebiet.obj.cluster.arr.neighbor.append(self)


	func clean() -> void:
		for gebiet in arr.gebiet:
			gebiet.flag.on_screen = false
			gebiet.scene.myself.recolor()
		
		obj.insel.arr.cluster.erase(self)


	func paint_gebiets() -> void:
		for gebiet in arr.gebiet:
			gebiet.scene.myself.recolor()


#Остров
class Insel:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_meilensteins()
		init_gebiets()
		init_clusters()


	func init_scene() -> void:
		scene.myself = Global.scene.insel.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_meilensteins() -> void:
		arr.meilenstein = []
		var vec = Vector2(Global.vec.offset.map.x, Global.vec.offset.map.y)
		var x_shifts = [0,1,1,0]
		var y_shifts = [1,0,1,0]
		
		for _i in Global.num.meilenstein.rows:
			arr.meilenstein.append([])
			vec.y += Global.num.map.h/4
			
			vec.y += y_shifts[_i%y_shifts.size()]*Global.num.map.h/4
			vec.x += x_shifts[_i%x_shifts.size()]*Global.num.map.w/2
			
			for _j in Global.num.meilenstein.cols:
				vec.x += Global.num.map.w
				
				var input = {}
				input.position = vec
				input.grid = Vector2(_j,_i)
				var meilenstein = Classes_0.Meilenstein.new(input)
				arr.meilenstein[_i].append(meilenstein)
				
			vec.x = Global.vec.offset.map.x


	func init_gebiets() -> void:
		arr.gebiet = []
		var input = {}
		input.grid = Vector2(0,-1)
		input.insel = self
		
		for _i in Global.num.meilenstein.rows:
			input.grid.x = 0
			var k = (_i-1)%4
			var flag = false
			
			match k:
				0:
					flag = true
				1:
					flag = true
			
			if flag:
				input.grid.y += 1
				arr.gebiet.append([])
			
				for _j in Global.num.meilenstein.cols:
					var meilenstein = arr.meilenstein[_i][_j]
					var grid = meilenstein.vec.grid
					input.meilensteins = []
					
					for spin in Global.arr.spin[k]:
						grid += spin
						flag = flag and check_meilenstein(grid)
						
						if flag:
							input.meilensteins.append(arr.meilenstein[grid.y][grid.x])
						
					if flag:
						var gebiet = Classes_0.Gebiet.new(input)
						input.grid.x += 1
						arr.gebiet[input.grid.y].append(gebiet)
		
		arr.gebiet.pop_back()
		init_gebiet_neighbors()


	func init_gebiet_neighbors() -> void:
		for gebiets in arr.gebiet:
			for gebiet in gebiets:
				for direction in Global.arr.neighbor[gebiet.num.parity]:
					var grid = gebiet.vec.grid + direction
					
					if check_border(grid):
						var neighbor = arr.gebiet[grid.y][grid.x]
						gebiet.dict.neighbor[neighbor] = direction


	func init_clusters() -> void:
		arr.cluster = []
		var center = arr.gebiet[arr.gebiet.size()/2][arr.gebiet.size()/2]
		add_cluster_by_center(center)
		add_second_cluster()
		set_all_remaining_clusters()
		remove_incomplete_clusters() 
		set_cluster_colors()


	func add_cluster_by_center(center_) -> void:
		if center_ != null:
			var arounds = get_gebiets_around_gebiet(center_, 1)
			var input = {}
			input.center = center_
			input.gebiets = []
			input.insel = self
			
			for around in arounds:
				input.gebiets.append_array(around)
			
			var cluster = Classes_0.Cluster.new(input)
			arr.cluster.append(cluster)


	func get_gebiets_around_gebiet(gebiet_, rings_) -> Array:
		var arounds = [[gebiet_]]
		var totals = [gebiet_]
		
		for _i in rings_:
			var next_ring = []
			
			for _j in range(arounds[_i].size()-1,-1,-1):
				for neighbor in arounds[_i][_j].dict.neighbor.keys():
					if !totals.has(neighbor):
						next_ring.append(neighbor)
						totals.append(neighbor)
			
			arounds.append(next_ring)
		
		return arounds


	func add_second_cluster() -> void:
		var borderland = []
		
		for gebiet in arr.cluster.front().arr.gebiet:
			for neighbor in gebiet.dict.neighbor.keys():
				if neighbor.obj.cluster == null and neighbor.flag.on_screen and !borderland.has(neighbor):
					borderland.append(neighbor)
		
		var pair = get_pair_from_borderland(borderland)
		add_cluster_by_pair(pair)


	func add_cluster_by_pair(pair_) -> void:
		if pair_.size() == 2:
			var centers = []
			
			for neighbor in pair_[0].dict.neighbor.keys():
				if pair_[1].dict.neighbor.keys().has(neighbor):
					centers.append(neighbor)
			
			for center in centers:
				if center.obj.cluster == null and center.flag.on_screen:
					add_cluster_by_center(center)
					return
			
			for gebiet in pair_:
				gebiet.flag.on_screen = false


	func set_clusters_around_center() -> void:
		var borderland = []
		
		for cluster in arr.cluster:
			for gebiet in cluster.arr.gebiet:
				for neighbor in gebiet.dict.neighbor.keys():
					if neighbor.obj.cluster == null and neighbor.flag.on_screen and !borderland.has(neighbor):
						borderland.append(neighbor)
		
		for gebiet in borderland:
			gebiet.color.background = Color("blue")
			gebiet.scene.myself.recolor(gebiet.color.background)
		
		while borderland.size() > 1:
			var pair = get_pair_from_borderland(borderland)
			print("pair size ", pair.size())
			if pair.size() > 0:
				add_cluster_by_pair(pair)
				#pair.front().color.background = Color("green")
				#pair.front().scene.myself.recolor(pair.front().color.background)
				#pair.back().color.background = Color("blue")
				#pair.back().scene.myself.recolor(pair.back().color.background)
			
				for _i in range(borderland.size()-1,-1,-1):
					var gebiet = borderland[_i]
					
					if gebiet.obj.cluster != null && gebiet.flag.on_screen:
						borderland.erase(gebiet)


	func get_pair_from_borderland(borderland_) -> Array:
		var datas = []
		
		for gebiet in borderland_:
			if gebiet.obj.cluster == null and gebiet.flag.on_screen:
				var data = {}
				data.gebiet = gebiet
				data.neighbors = 0
				
				for neighbor in gebiet.dict.neighbor.keys():
					if borderland_.has(neighbor):
						data.neighbors += 1
				
				datas.append(data)
		
		if datas.size() > 0:
			datas.sort_custom(func(a, b): return a.neighbors < b.neighbors)
			var options = []
			#print(datas.front().neighbors, "   ",datas.size())
			
			for data in datas:
				if data.neighbors == datas.front().neighbors:
					options.append(data.gebiet)
			
			var first = Global.get_random_element(options)
			var seconds = []
			
			for neighbor in first.dict.neighbor.keys():
				if borderland_.has(neighbor) and neighbor.obj.cluster == null and neighbor.flag.on_screen:
					seconds.append(neighbor)
			
			if seconds.size() > 0:
				var second = Global.get_random_element(seconds)
				return [first,second]
		
		return []


	func set_all_remaining_clusters_0() -> void:
		var unclustered = {}
		
		for gebiets in arr.gebiet:
			for gebiet in gebiets:
				unclustered[gebiet] = []
		
		for cluster in arr.cluster:
			for gebiet in cluster.arr.gebiet:
				for neighbor in gebiet.dict.neighbor.keys():
					if neighbor.obj.cluster == null and neighbor.flag.on_screen and !unclustered[neighbor].has(cluster):
						unclustered[neighbor].append(cluster)
		
		var counter = 0
		var stoper = 1
		
		while unclustered.keys().size() > 100 and counter < stoper:
			add_next_cluster(unclustered)
			counter += 1


	func add_next_cluster_0(unclustered_) -> void:
		var options = []
		
		for gebiet in unclustered_.keys():
			if unclustered_[gebiet].size() == 2:
				options.append(gebiet)
		
		var first = Global.get_random_element(options)
		var seconds = []
		
		for neighbor in first.dict.neighbor.keys():
			if unclustered_.keys().has(neighbor): 
				if unclustered_[neighbor].size() > 0:
					seconds.append(neighbor)
		
		if seconds.size() > 0:
			var second = Global.get_random_element(seconds)
			add_cluster_by_pair([first, second])
		
		for gebiet in arr.cluster.back().arr.gebiet:
			unclustered_.erase(gebiet)
			
			for neighbor in gebiet.dict.neighbor.keys():
				if unclustered_.keys().has(neighbor):
					if !unclustered_[neighbor].has(arr.cluster.back()):
						unclustered_[neighbor].append(arr.cluster.back())


	func set_all_remaining_clusters() -> void:
		var unenclouded = []
		
		unenclouded.append_array(arr.cluster)
		
		var counter = 0
		var stoper = 1000
		
		while counter < stoper and unenclouded.size() > 0:
			add_next_cluster(unenclouded)
			counter += 1


	func add_next_cluster(unenclouded_) -> void:
		if unenclouded_.size() == 0:
			return
		
		var cluster = unenclouded_.front()
		var neighbors = 6
		var ring = 2
		
		if cluster.arr.neighbor.size() == neighbors or cluster.arr.gebiet.size() != neighbors+1:
			unenclouded_.pop_front()
			add_next_cluster(unenclouded_)
		else:
			var arounds = get_gebiets_around_gebiet(cluster.obj.center,ring)
			var options = []
			var gebiets = []
			
			for gebiet in arounds[ring]:
				if gebiet.obj.cluster == null and gebiet.flag.on_screen:
					gebiets.append(gebiet)
			
			for gebiet in gebiets:
				var clusters = []
				
				for neighbor in gebiet.dict.neighbor.keys():
					if !clusters.has(neighbor.obj.cluster) and neighbor.obj.cluster != null and neighbor.flag.on_screen:
						clusters.append(neighbor.obj.cluster)
				
				if clusters.size() > 1:
					options.append(gebiet)
			
			if options.size() > 0:
				var first = Global.get_random_element(options)
				var seconds = []
				
				for neighbor in first.dict.neighbor.keys():
					if arounds[ring].has(neighbor) and neighbor.obj.cluster == null and neighbor.flag.on_screen: 
						seconds.append(neighbor)
				
				if seconds.size() > 0:
					var second = Global.get_random_element(seconds)
					#print(second)
					var pair = [first, second]
					add_cluster_by_pair(pair)
					
					#pair.front().color.background = Color("green")
					#pair.front().scene.myself.recolor(pair.front().color.background)
					#pair.back().color.background = Color("blue")
					#pair.back().scene.myself.recolor(pair.back().color.background)
					#print(arr.cluster.back().arr.neighbor.size(), " ", arr.cluster.back().arr.gebiet.size())
					unenclouded_.append(arr.cluster.back())
				else:
					unenclouded_.pop_front()
					add_next_cluster(unenclouded_)
			else:
				unenclouded_.pop_front()
				add_next_cluster(unenclouded_)


	func remove_incomplete_clusters() -> void:
		var n = 7
		
		for _i in range(arr.cluster.size()-1,-1,-1):
			var cluster = arr.cluster[_i]
			
			if cluster.arr.gebiet.size() != n:
				cluster.clean()
		
		for gebiets in arr.gebiet:
			for gebiet in gebiets:
				if gebiet.obj.cluster == null:
					gebiet.flag.on_screen = false
					gebiet.scene.myself.recolor()


	func set_cluster_colors() -> void:
		var origin = arr.cluster.front()
		var unpainted = [origin]
		
		while unpainted.size() > 0:
			var cluster = unpainted.pop_front()
			var colors = []
			colors.append_array(Global.arr.color)
			
			for neighbor in cluster.arr.neighbor:
				colors.erase(neighbor.word.color)
				
				if neighbor.word.color == "White" && !unpainted.has(neighbor):
					unpainted.append(neighbor)
			
			cluster.word.color = Global.get_random_element(colors)
			cluster.paint_gebiets()


	func check_meilenstein(grid_) -> bool:
		return grid_.y >= 0 and grid_.x >= 0 and grid_.y < arr.meilenstein.size() and grid_.x < arr.meilenstein[0].size()


	func check_border(grid_) -> bool:
		var flag = ( grid_.x >= arr.gebiet[0].size() ) or ( grid_.x < 0 ) or ( grid_.y >= arr.gebiet.size() ) or ( grid_.y < 0 )
		return !flag
