extends Node


#Черновик
class Entwurf:
	var word = {}
	var arr = {}
	var dict = {}
	var obj = {}


	func _init(input_) -> void:
		obj.chronik = input_.chronik
		arr.rune = input_.runes
		dict.ethnography = {}
		dect_lied()


	func dect_lied() -> void:
		Global.fill_ethnography_parameters(self, arr.rune)
		
		for parameter in dict.ethnography.keys():
			if dict.ethnography[parameter].keys().size() > 0:
				match parameter:
					"pureblood":
						var abbreviation = dict.ethnography[parameter].keys().front()
						dict.ethnography[parameter] = dict.ethnography[parameter][abbreviation]
				match parameter:
					"servants":
						var size = 0
						var runes = []
						
						for power in dict.ethnography[parameter].keys():
							runes.append_array(dict.ethnography[parameter][power])
							size = max(size,dict.ethnography[parameter][power].size())
						
						dict.ethnography[parameter] = []
						
						if size == runes.size():
							dict.ethnography[parameter].append_array(runes)
						else:
							dict.ethnography.erase(parameter)
			else:
				dict.ethnography.erase(parameter)
		
		for parameter in dict.ethnography.keys():
			match parameter:
				"hierarchy":
					dict.ethnography[parameter] = []
					dict.ethnography[parameter].append_array(arr.rune)
					
		var names = []
		
		for parameter in dict.ethnography.keys():
			var size = dict.ethnography[parameter].size()
			
			if size > 0:
				#print(parameter, " ", size)
				var a = Global.dict.lied.parameter[parameter]
				var names_ = Global.dict.lied.parameter[parameter][size]
				names.append_array(names_)
		
		for _i in range(names.size()-1,-1,-1):
			var name_ = names[_i]
			var correct = true
			var a = Global.dict.lied.name
			
			for parameter in Global.dict.lied.name[name_]:
				if dict.ethnography.keys().has(parameter):
					correct = correct and Global.dict.lied.name[name_][parameter] == dict.ethnography[parameter].size()
				else:
					correct = false
					break
			
			if !correct:
				names.erase(names[_i])
		
		match names.size():
			0:
				print("error dect_lied no name")
			1:
				var datas = [] 
				
				for name_ in names:
					var data = {}
					data.name = name_
					data.size = Global.dict.lied.name[name_][Global.dict.lied.name[name_].keys().front()]
					datas.append(data)
				
				datas.sort_custom(func(a, b): return a.size > b.size)
				word.name = datas.front().name
				
			2:
				word.name = names.front()
			4:
				var counts = {}
				
				for name_ in names:
					var count = names.count(name_)
					
					if !counts.keys().has(count):
						counts[count] = [name_]
					else:
						if !counts[count].has(name_):
							counts[count].append(name_)
				
				if counts[2].size() == 1:
					word.name = counts[2].front()
				else:
					print("error dect_lied names > 3")


#Песнь
class Lied:
	var word = {}
	var arr = {}


	func _init() -> void:
		arr.prerequisite = []


#Руна
class Rune:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.tint = input_.tint
		word.abbreviation = input_.tint.left(1)
		num.density = input_.density
		num.index = Global.num.index.rune
		Global.num.index.rune += 1
		obj.alphabet = input_.alphabet


	func print_self() -> void:
		print(word.abbreviation, num.density)


	func crease(owner_) -> void:
		for rune in owner_.obj.archivar.dict.preference.runes.keys():
			if owner_.obj.archivar.dict.preference.runes[rune].has(self):
				owner_.obj.archivar.dict.preference.runes[rune].erase(self)
		
		owner_.obj.archivar.dict.preference.runes.erase(self)
		owner_.play_rune(self)
		print("creased ",word.abbreviation, num.density)


#Алфавит
class Alphabet:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		word.tint = input_.tint
		num.density = input_.density
		obj.lexikon = input_.lexikon
		init_runes()


	func init_runes() -> void:
		arr.rune = []
		
		for density in num.density:
			var input = {}
			input.alphabet = self
			input.tint = word.tint
			input.density = density
			var rune = Classes_5.Rune.new(input)
			arr.rune.append(rune)


#Энциклопедия
class Lexikon:
	var arr = {}
	var obj = {}


	func _init() -> void:
		init_alphabets()


	func init_alphabets() -> void:
		var max_density = 9
		arr.alphabet = []
		arr.tint = []
		arr.density = []
		
		for density in max_density:
			arr.density = [density]
			
		
		for sin in Global.dict.alphabet.sin.keys():
			var input = {}
			input.lexikon = self
			input.tint = Global.dict.alphabet.sin[sin].tint
			input.density = max_density
			var alphabet = Classes_5.Alphabet.new(input)
			arr.alphabet.append(alphabet)
			arr.tint.append(input.tint)
