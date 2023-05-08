extends Node


#Доска объявлений
class Anschlagbrett:
	var obj = {}


	func _init(input_) -> void:
		obj.gewerkschaft = input_.gewerkschaft


#Склад
class Lagerhaus:
	var obj = {}


	func _init(input_) -> void:
		obj.gewerkschaft = input_.gewerkschaft


#Управляющий
class Leiter:
	var obj = {}


	func _init(input_) -> void:
		obj.gewerkschaft = input_.gewerkschaft


#Торговый союз
class Gewerkschaft:
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		word.title = input_.title
		obj.handel = input_.handel
		arr.zunft = []
		init_anschlagbrett()
		init_lagerhaus()
		init_leiter()


	func init_anschlagbrett() -> void:
		var input = {}
		input.gewerkschaft = self
		obj.anschlagbrett = Classes_4.Anschlagbrett.new(input)


	func init_lagerhaus() -> void:
		var input = {}
		input.gewerkschaft = self
		obj.lagerhaus = Classes_4.Lagerhaus.new(input)


	func init_leiter() -> void:
		var input = {}
		input.gewerkschaft = self
		obj.leiter = Classes_4.Leiter.new(input)


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


	func init_gewerkschafts() -> void:
		arr.gewerkschaft = []
		var titles = ["1","2","3"]
		
		for title in titles:
			var input = {}
			input.handel = self
			input.title = title
			var gewerkschaft = Classes_4.Gewerkschaft.new(input)
			arr.gewerkschaft.append(gewerkschaft)


