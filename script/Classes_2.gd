extends Node


#Кучер
class Treiber:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		obj.wagen = null
		obj.zunft = input_.zunft
		init_features()


	func init_features() -> void:
		num.rune = {}


	func set_wagen(wagen_) -> void:
		obj.wagen = wagen_
		wagen_.obj.treiber = self


#Модуль
class Modul:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		num.rank = input_.rank
		word.type = input_.type
		obj.wagen = input_.wagen
		num.weight = Global.num.modul.weight.modul[word.type]*(1+Global.num.modul.weight.rank*num.rank)
		obj.wagen.obj.karkasse.num.tonnage.current -= num.weight 
		roll_indicator()


	func roll_indicator() -> void:
		num.indicator = {}
		num.indicator.current = Global.num.modul.indicator[num.rank].basis
		var deviation = Global.num.modul.indicator[num.rank].deviation
		
		Global.rng.randomize()
		num.indicator.roll = Global.rng.randi_range(-deviation, deviation)
		num.indicator.current += num.indicator.roll
		
		num.price = Global.num.modul.price.rank[num.rank]
		num.price += Global.num.modul.price.deviation[num.indicator.roll]


	func get_value_by_type() -> void:
		num.value = 0
		
		match word.type:
			"motor":
				num.value = 100
			"locator":
				pass
			"handler":
				pass
			"packer":
				pass
			"spear":
				pass
			"shield":
				pass


	func get_value_by_aspect() -> void:
		var value = 0
		
		match word.type:
			"speed":
				value = 300
			"drill":
				value = 100
			"radar":
				value = 3
			"memory":
				value = 10
			"intellect":
				value = 10
			"cargo":
				value = 10000.0
			"jewellery":
				pass
			"attack":
				pass
			"defense":
				pass
			"buff":
				pass
			"debuff":
				pass
			"price":
				pass
			"tempo":
				pass


#Остов
class Karkasse:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		obj.wagen = input_.wagen
		roll_nickname()


	func roll_nickname() -> void:
		var prices = {}
		
		for nickname in Global.dict.karkasse.nickname:
			if !prices.keys().has(Global.dict.karkasse.nickname[nickname].price):
				prices[Global.dict.karkasse.nickname[nickname].price] = Global.dict.karkasse.nickname[nickname].rarity
		
		var price = Global.get_random_key(prices)
		var nicknames = []
		
		for nickname in Global.dict.karkasse.nickname:
			if Global.dict.karkasse.nickname[nickname].price == price:
				nicknames.append(nickname)
		
		word.nickname = Global.get_random_element(nicknames)
		num.tonnage = {}
		num.tonnage.total = Global.dict.karkasse.nickname[word.nickname].tonnage
		num.tonnage.current = num.tonnage.total


#Телега
class Wagen:
	var obj = {}
	var dict = {} 


	func _init(input_) -> void:
		obj.zunft = input_.zunft
		obj.treiber = null
		obj.wohnwagen = null
		init_karkasse()
		init_moduls()
		
		print(obj.karkasse.word,obj.karkasse.num.tonnage.current)


	func init_karkasse() -> void:
		var input = {}
		input.wagen = self
		obj.karkasse = Classes_2.Karkasse.new(input)


	func init_moduls() -> void:
		dict.modul = {}
		
		for type in Global.arr.modul:
			dict.modul[type] = []
			
			for _i in Global.dict.karkasse.nickname[obj.karkasse.word.nickname][type]:
				var input = {}
				input.wagen = self
				input.type = type
				input.rank = 0
				var modul = Classes_2.Modul.new(input)
				dict.modul[type].append(modul)


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
		obj.chronik = Classes_2.Chronik.new(input)


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
	var scene = {}


	func _init(input_) -> void:
		obj.wohnwagen = input_.wohnwagen
		init_cargo()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.trailer.instantiate()
		scene.myself.set_parent(self)
		obj.wohnwagen.obj.zunft.obj.heer.scene.myself.get_node("Trailers").add_child(scene.myself)


	func init_cargo() -> void:
		arr.nugget = []
		num.cargo = {}
		num.cargo.current = 0
		num.cargo.max = 10000.0
		num.cargo.compartment = {}
		num.size = {}
		num.size.compartment = 50
		num.size.section = num.cargo.max/num.size.compartment


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
		erzlager_.remove_fossil(nugget)
		var input = {}
		input.nugget_size = nugget
		input.erzlager = erzlager_
		add_nugget(input)


	func add_nugget(input_) -> void:
		arr.nugget.append(input_.nugget_size)
		num.cargo.current += input_.nugget_size
		fill_compartment(input_)
		
		if num.cargo.current > num.cargo.max:
			obj.wohnwagen.word.task = "fall into stasis"
			obj.wohnwagen.set_phases_by_task()


	func fill_compartment(input_) -> void:
		var a = num.cargo.compartment.keys().has(input_.erzlager.word.element)
		
		if !num.cargo.compartment.keys().has(input_.erzlager.word.element):
			num.cargo.compartment[input_.erzlager.word.element] = [input_.nugget_size]
		else:
			var back = num.cargo.compartment[input_.erzlager.word.element].pop_back()
			back += input_.nugget_size
			num.cargo.compartment[input_.erzlager.word.element].append(back)
		
		while num.cargo.compartment[input_.erzlager.word.element].back() > num.size.section:
			var back = num.cargo.compartment[input_.erzlager.word.element].pop_back()
			back -= num.size.section
			num.cargo.compartment[input_.erzlager.word.element].append(num.size.section)
			num.cargo.compartment[input_.erzlager.word.element].append(back)
			scene.myself.sections[input_.erzlager.word.element].append(num.size.section)
		
		scene.myself.update_bars()

