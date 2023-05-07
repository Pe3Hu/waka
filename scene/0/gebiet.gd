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
			h = Global.dict.element.hue[parent.obj.erzlager.word.element]
		
		parent.color.background = Color.from_hsv(h,s,v)
		set_color(parent.color.background)


func paint_black() -> void:
	parent.color.background = Color("black")
	set_color(parent.color.background)
