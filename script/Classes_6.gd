extends Node


#Погоня
class Verfolgung:
	var num = {}
	var arr = {}
	var obj = {}


	func _init() -> void:
		num.round = {}
		num.round.current = 0
		num.round.max = 100
		num.race = {}
		num.race.current = 0
		num.race.max = 1
		arr.victim = []
		arr.chaser = []
		init_nums()


	func init_nums() -> void:
		num.breakaway = 0
		num.speed = {}
		num.speed.victim = 0
		num.speed.victim = 0


	func add_victim(victim_) -> void:
		victim_.obj.verfolgung = self
		arr.victim.append(victim_)


	func add_chaser(chaser_) -> void:
		chaser_.obj.verfolgung = self
		arr.chaser.append(chaser_)


	func next_distribution() -> bool:
		num.round.current += 1
		var archivar = arr.chaser.front().obj.archivar
		archivar.obj.chronik.fill_thought()
		archivar.obj.chronik.highlight_entwurfs()
		return archivar.follow_preference()
		
#		for entwurf in archivar.obj.chronik.arr.entwurf:
#			for parameter in entwurf.dict.ethnography.keys(): 
#				print(parameter, " ", entwurf.dict.ethnography[parameter].size())


	func run_races() -> void:
		while num.race.current < num.race.max:
			find_imba()
			num.race.current += 1
		
		print(Global.stats)


	func find_imba() -> void:
		var imba = next_distribution()
		
		while !imba and num.round.current < num.round.max:
			imba = next_distribution()
		
		reset()


	func reset() -> void:
		num.round.current = 0
		
		for victim in arr.victim:
			victim.obj.archivar.obj.chronik.reset_runes()
		
		for chaser in arr.chaser:
			chaser.obj.archivar.obj.chronik.reset_runes()
