extends Node


func _ready() -> void:
	Global.obj.insel = Classes_0.Insel.new()
	Global.obj.zunft = Classes_1.Zunft.new({"title":"First"})
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
					#Global.obj.zunft.arr.wohnwagen.front().radar()
					Global.obj.zunft.arr.wohnwagen.front().follow_schedule()
					


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
	
	for wohnwagen in Global.obj.zunft.arr.wohnwagen:
		if wohnwagen.scene.myself.tween == null:
			#if !wohnwagen.scene.myself.tween.is_running():
			wohnwagen.follow_schedule()
