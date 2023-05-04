extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	var vertexs = []
	parent = parent_
	
	for meilenstein in parent_.arr.meilenstein:
		vertexs.append(meilenstein.vec.position)
	
	set_polygon(vertexs)


func recolor_by_erzlager() -> void:
	set_visible(parent.flag.on_screen)
	
	if parent.flag.on_screen:
		var max_h = 360.0
		var h = 0.75
		var s = 0
		var v = 1
		var fossil = float(parent.obj.erzlager.num.fossil.current)/parent.obj.erzlager.num.fossil.max
		s += 0.7*fossil+0.05
		
		if parent.obj.cluster != null:
			match parent.obj.erzlager.word.element:
				"Fire":
					h = 350/max_h
				"Wind":
					h = 180/max_h
				"Aqua":
					h = 220/max_h
				"Earth":
					h = 100/max_h
				"Halo":
					h = 60/max_h
				"Dark":
					h = 290/max_h
					
		
		parent.color.background = Color.from_hsv(h,s,v)
		set_color(parent.color.background)
