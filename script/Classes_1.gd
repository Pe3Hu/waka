extends Node


#Пчела biene
class Biene:
	var num = {}
	var vec = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.bienenstock = input_.bienenstock


#Улей bienenstock
class Bienenstock:
	var num = {}
	var vec = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.garten = input_.garten
		init_num()
		init_vec()
		init_scene()


	func init_num() -> void:
		Global.rng.randomize()
		num.speed = Global.rng.randf_range(Global.num.bienenstock.speed.min, Global.num.bienenstock.speed.max)
		num.radius = {}
		num.radius.collide = 8
		num.radius.scream = 128


	func init_vec() -> void:
		Global.rng.randomize()
		vec.direction = Vector2(
			Global.rng.randf_range(-1, 1),
			Global.rng.randf_range(-1, 1)
		)
		vec.direction = vec.direction.normalized()


	func init_scene() -> void:
		scene.myself = Global.scene.bienenstock.instantiate()
		scene.myself.set_parent(self)
		Global.node.game.get_node("bienenstocks").add_child(scene.myself)
