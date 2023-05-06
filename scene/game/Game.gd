extends Node


func _ready() -> void:
	Global.obj.insel = Classes_0.Insel.new()
	Global.obj.lexikon = Classes_2.Lexikon.new()
	Global.obj.handel = Classes_3.Handel.new()
	Global.obj.heer = Classes_1.Heer.new()
	
#	datas.sort_custom(func(a, b): return a.value > b.value)
	
	for zunft in Global.obj.heer.arr.zunft:
		for wohnwagen in zunft.arr.wohnwagen:
			wohnwagen.follow_schedule()


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					pass


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
