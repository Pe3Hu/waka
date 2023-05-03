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
		var h = 0.75
		var s = 0
		var v = 1
		var abundance = float(parent.obj.erzlager.num.abundance.current)/parent.obj.erzlager.num.abundance.max
		s += 0.7*abundance+0.05
		#print(s, " ", abundance)
		
		if parent.obj.cluster != null:
			match parent.obj.erzlager.word.element:
				"Fire":
					h = 350/360.0
				"Wind":
					h = 290/360.0
				"Aqua":
					h = 190.0/360.0
				"Earth":
					h = 90.0/360.0
		
		parent.color.background = Color.from_hsv(h,s,v)
		set_color(parent.color.background)
