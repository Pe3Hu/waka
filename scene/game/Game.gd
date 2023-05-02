extends Node


func _ready() -> void:
	Global.obj.map = Classes_0.Insel.new()
#	datas.sort_custom(func(a, b): return a.value > b.value)


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				Global.obj.planet.obj.vorderseite.select_next_schlachtfeld(-1)
			KEY_D:
				Global.obj.planet.obj.vorderseite.select_next_schlachtfeld(1)
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					#Global.obj.planet.obj.vorderseite.next_turn()
					Global.obj.austausch.next_round()

func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
