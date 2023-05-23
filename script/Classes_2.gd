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

