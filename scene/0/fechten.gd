extends StaticBody2D


var parent = null

func set_parent(parent_) -> void:#: Fechten
	parent = parent_


func set_walls() -> void:
	$CollisionShape2D.shape.size = Global.vec.size.window.center*2
	
	match parent.word.side:
		"top":
			$CollisionShape2D.shape.size.y = 10
			$CollisionShape2D.position.x = Global.vec.size.window.center.x
		"bot":
			$CollisionShape2D.shape.size.y = 10
			$CollisionShape2D.position.x = Global.vec.size.window.center.x
			$CollisionShape2D.position.y = Global.vec.size.window.center.y*2
		"left":
			$CollisionShape2D.shape.size.x = 10
			$CollisionShape2D.position.y = Global.vec.size.window.center.y
		"right":
			$CollisionShape2D.shape.size.x = 10
			$CollisionShape2D.position.x = Global.vec.size.window.center.x*2
			$CollisionShape2D.position.y = Global.vec.size.window.center.y
