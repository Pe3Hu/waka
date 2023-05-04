extends Polygon2D


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_
	var vertexs = []
	var a = Global.num.insel.w/2
	
	for neighbor in Global.dict.neighbor.linear2:
		var vertex = neighbor*a
		vertexs.append(vertex)
	
	set_polygon(vertexs)
	recolor()


func recolor() -> void:
	var h = 0.75
	var s = 0.75
	var v = 1
	
	match parent.obj.zunft.word.title:
		"First":
			v = 0.0
	
	parent.color.background = Color.from_hsv(h,s,v)
	set_color(parent.color.background)


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
	parent.flag.moving = true
	parent.obj.gebiet.current.obj.wohnwagen = null
	parent.obj.gebiet.next.obj.wohnwagen = parent
	parent.obj.gebiet.previous = parent.obj.gebiet.current
	
	var distance = parent.obj.gebiet.current.num.w+parent.obj.gebiet.next.num.w
	var time = float(distance)/parent.num.speed
	var direction = parent.obj.gebiet.next.vec.center
	tween = create_tween()
	tween.tween_property(self, "position", direction, time)
	parent.obj.gebiet.current = null
	tween.tween_callback(parent.parking)


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


func end_drill() -> void:
	var time = 0
	tween = create_tween()
	tween.tween_property(self, "rotation", 0, time)
	tween.tween_callback(parent.follow_schedule)
	tween.tween_callback(parent.drilling_gebiet_selection)

