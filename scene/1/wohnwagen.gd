extends Polygon2D


var parent = null


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
	var vector = parent.obj.gabiet.current.vec.center
	set_position(vector)


func move_to_next_gebiet() -> void:
	parent.flag.moving = true
	parent.obj.gabiet.current.obj.wohnwagen = null
	parent.obj.gabiet.next.obj.wohnwagen = parent
	var tween = create_tween()
	var distance = parent.obj.gabiet.current.num.w+parent.obj.gabiet.next.num.w
	var time = float(distance)/parent.num.speed
	
	#for neighbor in parent.obj.gabiet.current.dict.neighbor.keys():
	#	if neighbor == parent.obj.gabiet.next:
	#		var direction = parent.obj.gabiet.current.dict.neighbor[neighbor]
	#		direction *= distance
	#		direction += parent.obj.gabiet.current.vec.center
	var direction = parent.obj.gabiet.next.vec.center
	tween.tween_property(self, "position", direction, time)
	$Moving.wait_time = time/2
	$Moving.start()
	return



func _on_moving_timeout():
	if parent.flag.moving && position:# != parent.obj.gabiet.next.vec.center:
		parent.obj.gabiet.previous = parent.obj.gabiet.current
		parent.obj.gabiet.current = null
		parent.flag.moving = false
		$Moving.start()
	
	var parking_distance = 1
	var distance = position.distance_to(parent.obj.gabiet.next.vec.center)
	
	if parking_distance > distance:
		parent.obj.gabiet.current = parent.obj.gabiet.next
		parent.obj.gabiet.next = null
		$Moving.stop()
		#$Moving.start()
