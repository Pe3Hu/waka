extends Node2D


var parent = null



func set_parent(parent_) -> void:
	parent = parent_


func _on_sludge_timeout():
	for gebiets in parent.arr.gebiet:
		for gebiet in gebiets:
			Global.rng.randomize()
			var sludge = Global.rng.randi_range(parent.num.sludge.min, parent.num.sludge.max)
			gebiet.obj.erzlager.add_fossil(sludge)
			gebiet.scene.myself.recolor_by_erzlager()
	
	parent.check_eruption()
