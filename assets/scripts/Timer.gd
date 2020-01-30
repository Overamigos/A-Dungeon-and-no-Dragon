extends Timer

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	print('a')
	var enemy = preload("res://assets/scenes/Enemy.tscn").instance()
	get_parent().add_child(enemy)
	print(enemy)
	enemy.global_position = Vector2(0,0)
	pass # Replace with function body.
