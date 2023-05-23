extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	var vertexs = []
	parent = parent_
	
	for meilenstein in parent_.arr.meilenstein:
		vertexs.append(meilenstein.vec.position)
	
	set_polygon(vertexs)


func recolor_by_type(type_) -> void:
	set_visible(parent.flag.on_screen)
	var max_h = 360.0
	var h = 0.75
	var s = 0
	var v = 1
	
	match type_:
		"erzlager":
			if parent.flag.on_screen && parent.obj.hauptsitz == null:
				var fossil = float(parent.obj.erzlager.num.fossil.current)/parent.obj.erzlager.num.fossil.max
				s += 0.7*fossil+0.05
				
				if parent.obj.cluster != null:
					h = Global.dict.element.hue[parent.obj.erzlager.word.element]
			
			parent.color.background = Color.from_hsv(h,s,v)
			set_color(parent.color.background)
		"hauptsitz":
			parent.color.background = Color("black")
			set_color(parent.color.background)
			var emblem = get_children()[0]
			emblem.set_color(parent.color.emblem)


func paint_black() -> void:
	parent.color.background = Color("black")
	set_color(parent.color.background)
	var emblem = get_children()[0]
	emblem.set_color(parent.color.background)


func add_hauptsitz() -> void:
	var emblem = Polygon2D.new()
	var vertexs = []
	
	for meilenstein in parent.arr.meilenstein:
		var vertex = meilenstein.vec.position - parent.vec.center
		vertex = parent.vec.center+vertex*0.6
		vertexs.append(vertex)
	
	if parent.obj.hauptsitz.obj.owner != null:
		parent.color.emblem = parent.obj.hauptsitz.obj.owner.color.emblem
	else:
		parent.color.emblem = Color("White")
	
	emblem.set_polygon(vertexs)
	emblem.set_color(parent.color.emblem)
	add_child(emblem)
	recolor_by_type("hauptsitz")
