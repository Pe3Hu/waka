extends Polygon2D


var parent = null


func set_parent(parent_):
	var vertexs = []
	parent = parent_
	
	for meilenstein in parent_.arr.meilenstein:
		vertexs.append(meilenstein.vec.position)
	
	set_polygon(vertexs)
	recolor()


func recolor():
	set_visible(parent.flag.on_screen)
	
	if parent.flag.on_screen:
		var h = 0.75
		var s = 0.75
		var v = 1
		
		if parent.obj.cluster != null:
			match parent.obj.cluster.word.color:
				"White":
					s = 0.0
					v = 1.0
				"Black":
					v = 0.0
				"Red":
					h = 0.0
				"Green":
					h = 120/360.0
				"Blue":
					h = 210.0/360.0
				"Yellow":
					h = 60.0/360.0
		
		parent.color.background = Color.from_hsv(h,s,v)
		set_color(parent.color.background)
