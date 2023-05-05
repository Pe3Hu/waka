extends Node


#Черновик
class Entwurf:
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		obj.chronik = input_.chronik


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
			var rune = Classes_2.Rune.new(input)
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
			var alphabet = Classes_2.Alphabet.new(input)
			arr.alphabet.append(alphabet)
