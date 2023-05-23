extends Node


#Ограждение fechten
class Fechten:
	var word = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.garten = input_.garten
		word.side = input_.side
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.fechten.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("fechtens").add_child(scene.myself)


#Сад garten
class Garten:
	var arr = {}


	func _init() -> void:
		init_fechtens()
		init_bienenstocks()


	func init_fechtens() -> void:
		arr.fechten = []
		
		for side in Global.arr.side:
			var input = {}
			input.garten = self
			input.side = side
			var fechten = Classes_0.Fechten.new(input)
			arr.fechten.append(fechten)


	func init_bienenstocks() -> void:
		arr.bienenstock = []
		var bienenstocks = 1
		
		for _i in bienenstocks:
			var input = {}
			input.garten = self
			var bienenstock = Classes_1.Bienenstock.new(input)
			arr.bienenstock.append(bienenstock)
