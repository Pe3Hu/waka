extends CharacterBody2D


var parent = null

func set_parent(parent_) -> void:
	parent = parent_
	set_start_position()


func set_start_position() -> void:
	Global.rng.randomize()
	position = Vector2(
		Global.rng.randf_range(parent.num.radius.collide, Global.vec.size.window.center.x * 2 - parent.num.radius.collide),
		Global.rng.randf_range(parent.num.radius.collide, Global.vec.size.window.center.y * 2 - parent.num.radius.collide)
	)
