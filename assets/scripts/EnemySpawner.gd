extends Timer

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	if get_parent().get_child_count() <= 0:
		var enemy = preload("res://assets/scenes/Characters/Enemy.tscn").instance()
		get_parent().add_child(enemy)
		enemy.global_position = Vector2(0,0)
	pass # Replace with function body.
