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
					"masters":
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
		
		if names.size() == 1:
			word.name = names.front()
		else:
			print("dect_lied eror")


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
		word.abbreviation = input_.abbreviation
		num.power = input_.power
		num.index = Global.num.index.rune
		Global.num.index.rune += 1
		obj.alphabet = input_.alphabet


#Алфавит
class Alphabet:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		word.sin = input_.sin
		num.size = input_.size
		obj.lexikon = input_.lexikon
		init_runes()


	func init_runes() -> void:
		arr.rune = []
		
		for _i in num.size:
			var input = {}
			input.alphabet = self
			input.abbreviation = word.sin.left(2)
			input.power = _i
			var rune = Classes_3.Rune.new(input)
			arr.rune.append(rune)


#Энциклопедия
class Lexikon:
	var arr = {}
	var obj = {}


	func _init() -> void:
		init_alphabets()


	func init_alphabets() -> void:
		arr.alphabet = []
		
		for sin in Global.dict.alphabet.sin.keys():
			var input = {}
			input.lexikon = self
			input.sin = sin
			input.size = 9
			var alphabet = Classes_3.Alphabet.new(input)
			arr.alphabet.append(alphabet)
