extends Node


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
			if parameter != "masters":
				dict.ethnography[parameter] = {}


	func fill_thought() -> void:
		if arr.rune.insight.size() == 0:
			arr.rune.archive.shuffle()
			fill_insight()
		
		#print(">>> ",arr.rune.insight.front())
		var space_left = obj.archivar.num.memory-arr.rune.thought.size()
		var novelty = min(space_left, obj.archivar.num.intellect)
		
		for _i in novelty:
			pull_rune_from_insight()
		
		fill_insight()
		highlight_entwurfs()


	func fill_insight() -> void:
		while obj.archivar.num.intellect > arr.rune.insight.size():
			pull_rune_from_archive()


	func pull_rune_from_insight() -> void:
		var rune = arr.rune.insight.pop_front()
		arr.rune.thought.append(rune)
		obj.archivar.dict.preference.unspoiled.tint[rune.word.tint].erase(rune)
		obj.archivar.dict.preference.unspoiled.density[rune.num.density].erase(rune)


	func pull_rune_from_archive() -> void:
		if arr.rune.archive.size() == 0:
			arr.rune.archive.append_array(arr.rune.memoir)
			arr.rune.memoir = []
			obj.archivar.reset_unspoiled()
		
		arr.rune.archive.shuffle()
		var rune = arr.rune.archive.pop_front()
		arr.rune.insight.append(rune)


	func highlight_entwurfs() -> void:
		arr.entwurf = []
		Global.fill_ethnography_parameters(self, arr.rune.thought)
		var entwurf_runes = []
		servants_and_pureblood_repositioning(entwurf_runes)
		hierarchy_repositioning(entwurf_runes)
		fill_entwurfs(entwurf_runes)


	func fill_parameters() -> void:
		init_parameters()
		var powers = []
		
		for rune in arr.rune.thought:
			if dict.ethnography["servants"].keys().has(rune.num.density):
				dict.ethnography["servants"][rune.num.density].append(rune)
			else:
				dict.ethnography["servants"][rune.num.density] = [rune]
				powers.append(rune.num.density)
			
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


	func servants_and_pureblood_repositioning(entwurf_runes_: Array) -> void:
		var parameters = ["servants","pureblood"]
		
		for parameter in parameters:
			for power in dict.ethnography[parameter].keys():
				var subpart_sizes = []
				
				for size in range(Global.num.lied.min_size[parameter],dict.ethnography[parameter][power].size()+1,1):
					subpart_sizes.append(size)
				
				var subparts = Global.get_all_subparts(dict.ethnography[parameter][power], subpart_sizes, parameter)
				
				for size in subparts.keys():
					for runes in subparts[size]:
						if !entwurf_runes_.has(runes):
							entwurf_runes_.append(runes)


	func hierarchy_repositioning(entwurf_runes_) -> void:
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
				options.append(dict.ethnography["servants"][power]) 
				
			var substitutions = Global.get_all_substitution(options)
			
			for runes in substitutions:
				runes.sort_custom(func(a, b): return a.num.index > b.num.index)
				
				if !entwurf_runes_.has(runes):
					entwurf_runes_.append(runes)


	func fill_entwurfs(entwurf_runes_) -> void:
		for runes in entwurf_runes_:
			var input = {}
			input.chronik = self
			input.runes = runes
			var entwurf = Classes_5.Entwurf.new(input)
			arr.entwurf.append(entwurf)


	func play_rune(rune_) -> void:
		arr.rune.thought.erase(rune_)
		arr.rune.memoir.append(rune_)


	func reset_runes() -> void:
		while arr.rune.insight.size() > 0:
			pull_rune_from_insight()
		
		while arr.rune.thought.size() > 0:
			var rune = arr.rune.thought.pop_front()
			play_rune(rune)
		
		arr.rune.archive.append_array(arr.rune.memoir)
		arr.rune.memoir = []
		obj.archivar.reset_unspoiled()
		obj.archivar.dict.preference.runes = {}


#Архивариус
class Archivar:
	var dict = {}
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		dict.preference = {}
		dict.preference.parametr = null
		dict.preference.runes = {}
		num.intellect = 5
		num.memory = 10
		obj.wohnwagen = input_.wohnwagen
		init_chronik()
		set_standard_content_of_chronik()
		set_preference("servants")
		
		#obj.chronik.fill_thought()
		
		#for rune in obj.chronik.arr.rune.thought:
		#	print(rune.word.abbreviation,rune.num.density)


	func init_chronik() -> void:
		var input = {}
		input.archivar = self
		obj.chronik = Classes_4.Chronik.new(input)


	func set_standard_content_of_chronik() -> void:
		for alphabet in Global.obj.lexikon.arr.alphabet:
			for rune in alphabet.arr.rune:
				add_rune_to_chronik(rune)


	func add_rune_to_chronik(rune_) -> void:
		obj.chronik.arr.rune.archive.append(rune_)
 

	func set_preference(preference_) -> void:
		dict.preference.parametr = preference_
		num.imba = null
		reset_unspoiled()
		
		match dict.preference.parametr:
			"servants":
				num.imba = Global.dict.alphabet.sin.keys().size()
			"pureblood":
				num.imba = Global.num.rune.density
			"hierarchy":
				num.imba = Global.num.rune.density


	func reset_unspoiled() -> void:
		dict.preference.unspoiled = {}
		dict.preference.unspoiled.tint = {}
		dict.preference.unspoiled.density = {}
		
		for rune in obj.chronik.arr.rune.archive:
			if !dict.preference.unspoiled.tint.keys().has(rune.word.tint):
				dict.preference.unspoiled.tint[rune.word.tint] = [rune]
			else:
				dict.preference.unspoiled.tint[rune.word.tint].append(rune)
			
			if !dict.preference.unspoiled.density.keys().has(rune.num.density):
				dict.preference.unspoiled.density[rune.num.density] = [rune]
			else:
				dict.preference.unspoiled.density[rune.num.density].append(rune)


	func follow_preference() -> bool:
		set_best_entwurfs()
		return check_imba()


	func set_best_entwurfs() -> void:
		for entwurf in obj.chronik.arr.entwurf:
			if entwurf.dict.ethnography.keys().has(dict.preference.parametr):
				for rune in entwurf.dict.ethnography[dict.preference.parametr]:
					if dict.preference.runes.has(rune):
						if dict.preference.runes[rune].size() < entwurf.dict.ethnography[dict.preference.parametr].size():
							dict.preference.runes[rune] = entwurf.dict.ethnography[dict.preference.parametr]
					else:
						dict.preference.runes[rune] = entwurf.dict.ethnography[dict.preference.parametr]


	func check_imba() -> bool:
		var combinations = []
		
		for rune in dict.preference.runes.keys():
			if !combinations.has(dict.preference.runes[rune]) and dict.preference.runes[rune].size() > 0:
				combinations.append(dict.preference.runes[rune])
		
		combinations.sort_custom(func(a, b): return a.size() < b.size())
		
		if combinations.back().size() == num.imba:
			if Global.stats.keys().has(dict.preference.parametr):
				if Global.stats[dict.preference.parametr].keys().has(num.imba):
					Global.stats[dict.preference.parametr][num.imba].append(obj.wohnwagen.obj.verfolgung.num.round.current)
				else:
					Global.stats[dict.preference.parametr][num.imba] = [obj.wohnwagen.obj.verfolgung.num.round.current]
			else:
				Global.stats[dict.preference.parametr] = {}
				Global.stats[dict.preference.parametr][num.imba] = [obj.wohnwagen.obj.verfolgung.num.round.current]
			obj.wohnwagen.obj.verfolgung.reset()
		else:
			jettison(combinations)
		
		
		var runes = []
		
		for rune in dict.preference.runes.keys():
			var text = rune.word.abbreviation+str(rune.num.density)+"| "+str(dict.preference.runes[rune].size())
			runes.append(text)
			#print(rune.word.abbreviation, rune.num.density, "| ",dict.preference.runes[rune].size())
		
		print(runes)
		print("___",obj.wohnwagen.obj.verfolgung.num.round.current,"___")
		
		return combinations.back().size() == num.imba


	func jettison(combinations_: Array) -> void:
		while combinations_.has([]):
			combinations_.erase([])
		
		if combinations_.size() != 1:
			var available_space = num.memory-obj.chronik.arr.rune.thought.size()
			var ballast = max(0,num.intellect-available_space)
			
			if ballast > 0:
				var combination = null
				
				if combinations_.front().size() == combinations_.back().size():
					match dict.preference.parametr:
						"servants":
							var datas = []
							
							for combination_ in combinations_:
								var density = combination_.front().num.density
								var data = {}
								data.combination = combination_
								data.unspoiled = dict.preference.unspoiled.density[density]
								datas.append(data)
							
							datas.sort_custom(func(a, b): return a.unspoiled.size() < b.unspoiled.size())
							
							if datas.front().unspoiled.size() == datas.back().unspoiled.size():
								datas.shuffle()
							
							combination = datas.front().combination
				else:
					combination = combinations_.pop_front()
				
				if combination.size() > 0:
					var rune = Global.get_random_element(combination)
					rune.crease(obj.chronik)
					ballast -= 1
			
			if ballast > 0:
				jettison(combinations_)
