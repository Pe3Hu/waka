extends MarginContainer


var parent = null
var hues = []
var sections = {}


func set_parent(parent_) -> void:
	parent = parent_
	$HBox/Label.text = parent.obj.wohnwagen.word.title
	
	for element in parent.obj.wohnwagen.num.weight.element.keys():
		sections[element] = []
	
	init_bars()


func init_bars() -> void:
	$HBox/Bars.custom_minimum_size = Vector2(100,20)
	
	for _i in parent.num.size.compartment:
		var container = MarginContainer.new()
		var color_rect = ColorRect.new()
		container.add_child(color_rect)
		container.set_h_size_flags(3)
		$HBox/Bars.add_child(container)
		hues.append(-1)
	
	recolor_bars()


func recolor_bars() -> void:
	var s = 0.75
	var v = 1
	var n = min($HBox/Bars.get_child_count(),hues.size())
	
	for _i in n:
		var container = $HBox/Bars.get_children()[_i]
		var h = hues[_i]
		
		if h < 0:
			container.get_children().front().set_color(Color.from_hsv(h,s,v,0.0))
		else:
			container.get_children().front().set_color(Color.from_hsv(h,s,v,1.0))
			


func update_bars() -> void:
	hues = []
	
	for element in sections.keys():
		for _i in sections[element].size():
			var hue = Global.dict.element.hue[element]
			hues.append(hue)
	
	recolor_bars()
