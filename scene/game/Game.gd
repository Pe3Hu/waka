extends Node


func _ready() -> void:
	Global.obj.insel = Classes_0.Insel.new()
	Global.obj.lexikon = Classes_2.Lexikon.new()
	Global.obj.zunft = Classes_1.Zunft.new({"title":"First"})
	
#	datas.sort_custom(func(a, b): return a.value > b.value)
	#for wohnwagen in Global.obj.zunft.arr.wohnwagen:
	#	wohnwagen.follow_schedule()


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					pass


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
