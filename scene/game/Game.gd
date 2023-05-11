extends Node


func _ready() -> void:
	Global.obj.insel = Classes_0.Insel.new()
	Global.obj.lexikon = Classes_5.Lexikon.new()
	Global.obj.handel = Classes_3.Handel.new()
	Global.obj.heer = Classes_1.Heer.new()
	Global.obj.verfolgung = Classes_6.Verfolgung.new()
	var wohnwagen = Global.obj.heer.arr.zunft.front().arr.wohnwagen.front()
	Global.obj.verfolgung.add_chaser(wohnwagen)
	Global.obj.verfolgung.run_races()
	#Global.obj.verfolgung.next_distribution()
	#Global.obj.verfolgung.add_chaser()
	
#	datas.sort_custom(func(a, b): return a.value < b.value) 012
#	for zunft in Global.obj.heer.arr.zunft:
#		for wohnwagen in zunft.arr.wohnwagen:
#			wohnwagen.return_to_gewerkschaft()
#			wohnwagen.set_phases_by_task()
#			wohnwagen.follow_phase()
	
#	var letters = 0
#	var wohnwagens = 0
#
#	for zunft in Global.obj.heer.arr.zunft:
#		for wohnwagen in zunft.arr.wohnwagen:
#			letters += wohnwagen.word.title.length()
#			wohnwagens += 1.0
#
#	print(letters/wohnwagens)


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					Global.obj.verfolgung.next_distribution()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
