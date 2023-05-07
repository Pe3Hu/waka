extends Node2D


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_
	init_vertexs()


func init_vertexs() -> void:
	var vertexs = []
	var a = Global.num.insel.w/2
	
	for neighbor in Global.dict.neighbor.linear2:
		var vertex = neighbor*a
		vertexs.append(vertex)
	
	$Background.set_polygon(vertexs)
	
	vertexs = []
	a = Global.num.insel.w/4
	
	for neighbor in Global.dict.neighbor.linear2:
		var vertex = neighbor*a
		vertexs.append(vertex)
	
	$Emblem.set_polygon(vertexs)
	
	var h = 0.75
	var s = 0.75
	var v = 0
	parent.color.background = Color.from_hsv(h,s,v)
	$Background.set_color(parent.color.background)
	recolor()


func recolor() -> void:
	var h = 0.75
	var s = 0.75
	var v = 1
	
	if parent.obj.zunft.obj.gewerkschaft != null:
		match parent.obj.zunft.obj.gewerkschaft.word.title:
			"1":
				h = 120.0/360
			"2":
				h = 200.0/360
			"3":
				h = 320.0/360
	else:
		s = 0
	
	parent.color.emblem = Color.from_hsv(h,s,v)
	$Emblem.set_color(parent.color.emblem)


func update_position() -> void:
	var vector = parent.obj.gebiet.current.vec.center
	set_position(vector)


func use_radar() -> void:
	var time = 0.5
	tween = create_tween()
	tween.tween_property(self, "skew", PI, time/2)
	tween.tween_property(self, "skew", 0, time/2)
	tween.tween_callback(parent.follow_schedule)


func move_to_next_gebiet() -> void:
	if parent.obj.gebiet.current == null:
		print("error move_to_next_gebiet obj.gebiet.current")
		return
		
	parent.obj.gebiet.current.obj.wohnwagen = null
	parent.obj.gebiet.next.obj.wohnwagen = parent
	parent.obj.gebiet.previous = parent.obj.gebiet.current
	
	var distance = parent.obj.gebiet.current.num.w+parent.obj.gebiet.next.num.w
	var time = float(distance)/parent.num.speed
	var direction = parent.obj.gebiet.next.vec.center
	parent.obj.gebiet.current = null
	tween = create_tween()
	tween.tween_property(self, "position", direction, time)
	tween.tween_callback(parent.follow_schedule)


func use_scan() -> void:
	var time = 0.5
	tween = create_tween()
	tween.tween_property(self, "rotation", PI/2, time)
	tween.tween_callback(parent.follow_schedule)


func use_drill() -> void:
	parent.obj.trailer.chipping_away_at_nugget(parent.obj.gebiet.current.obj.erzlager)
	var time = 0.1
	tween = create_tween()
	tween.tween_property(self, "rotation", -PI/60, time).as_relative()
	tween.tween_callback(parent.follow_schedule)


func wait() -> void:
	var time = 1
	tween = create_tween()
	tween.tween_property(self, "rotation", 0, time).as_relative()
	var repeat = parent.arr.schedule[parent.arr.schedule.size()-2]
	parent.arr.schedule.append(repeat)
	tween.tween_callback(parent.follow_schedule)
