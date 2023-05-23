extends Node


#Награда
class Auszeichnung:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		obj.abkommen = input_.abkommen
		word.currency = input_.currency
		num.value = input_.value


#Ящик
class Box:
	var obj = {}


	func _init() -> void:
		obj.onwer = null


#Договор
class Abkommen:
	var word = {}
	var obj = {}
	var arr = {}


	func _init(input_) -> void:
		obj.anschlagbrett = input_.anschlagbrett
		word.description = input_.description
		obj.freight = input_.freight
		obj.destination = input_.destination
		calc_reward()


	func calc_reward() -> void:
		var input = {}
		input.abkommen = self
		input.currency = "gold"
		input.value = 100
		obj.auszeichnung = Classes_3.Auszeichnung.new(input)


#Доска объявлений
class Anschlagbrett:
	var obj = {}
	var arr = {}


	func _init(input_) -> void:
		obj.hauptsitz = input_.hauptsitz


	func init_abkommen() -> void:
		arr.abkommen = []
		var abkommens = 10
		var descriptions = ["deliver", "pick up"]
		var destinations = []
		destinations.append_array(Global.obj.insel.arr.hauptsitz.hafen)
		
		for _i in abkommens:
			for description in descriptions:
				var input = {}
				input.anschlagbrett = self
				input.description = description
				input.freight = null
				input.destination = Global.get_random_element(destinations).obj.gebiet
				var abkommen = Classes_3.Abkommen.new(input)
				arr.abkommen.append(abkommen)


#Склад
class Lagerhaus:
	var obj = {}


	func _init(input_) -> void:
		obj.hauptsitz = input_.hauptsitz


#Управляющий
class Leiter:
	var obj = {}


	func _init(input_) -> void:
		obj.hauptsitz = input_.hauptsitz


#Торговый союз
class Gewerkschaft:
	var word = {}
	var arr = {}
	var obj = {}
	var color = {}


	func _init(input_) -> void:
		word.title = input_.title
		obj.handel = input_.handel
		obj.hauptsitz = input_.hauptsitz
		obj.hauptsitz.obj.owner = self
		arr.zunft = []
		init_color()
		obj.hauptsitz.obj.gebiet.scene.myself.add_hauptsitz()


	func init_color() -> void:
		var h = 0.75
		var s = 0.75
		var v = 1
		
		match word.title:
			"1":
				h = 120.0/360
			"2":
				h = 200.0/360
			"3":
				h = 320.0/360
		
		color.emblem = Color.from_hsv(h,s,v)


	func bring_privateer(zunft_) -> void:
		arr.zunft.append(zunft_)
		zunft_.obj.gewerkschaft = self
		
		for wohnwagen in zunft_.arr.wohnwagen:
			wohnwagen.scene.myself.recolor()


#Торговля
class Handel:
	var arr = {}


	func _init() -> void:
		init_gewerkschafts()
		fill_anschlagbretts()


	func init_gewerkschafts() -> void:
		arr.gewerkschaft = []
		var titles = ["1","2","3"]
		
		for _i in Global.obj.insel.arr.hauptsitz.gewerkschaft.size():
			var input = {}
			input.handel = self
			input.hauptsitz = Global.obj.insel.arr.hauptsitz.gewerkschaft[_i]
			input.title = titles[_i]
			var gewerkschaft = Classes_3.Gewerkschaft.new(input)
			arr.gewerkschaft.append(gewerkschaft)


	func fill_anschlagbretts() -> void:
		for key in Global.obj.insel.arr.hauptsitz.keys():
			for hauptsitz in Global.obj.insel.arr.hauptsitz[key]:
				hauptsitz.obj.anschlagbrett.init_abkommen()
