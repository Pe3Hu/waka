extends Node


#Погоня
class Verfolgung:
	var num = {}
	var arr = {}
	var obj = {}


	func _init() -> void:
		arr.victim = []
		arr.chaser = []
		init_nums()


	func init_nums() -> void:
		num.breakaway = 0
		num.speed = {}
		num.speed.victim = 0
		num.speed.victim = 0


	func add_victim(victim_) -> void:
		arr.victim.append(victim_)


	func add_chaser(chaser_) -> void:
		arr.chaser.append(chaser_)


	func next_distribution() -> void:
		var archivar = arr.chaser.front().obj.archivar
		archivar.obj.chronik.fill_thought()
		archivar.obj.chronik.highlight_entwurfs()
		archivar.follow_preference()
		
#		for entwurf in archivar.obj.chronik.arr.entwurf:
#			for parameter in entwurf.dict.ethnography.keys(): 
#				print(parameter, " ", entwurf.dict.ethnography[parameter].size())
