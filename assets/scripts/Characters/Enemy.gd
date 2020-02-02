extends "res://assets/scripts/Characters/Character.gd"

var target
var points = []

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	checkDeath()	
	chooseDirection()
	decideFacingDirection()
	run(delta)
	
	pass

func chooseDirection():
	var enemy_position = get_global_position()

	points = get_node("../../Navigation2D").get_simple_path(enemy_position, get_node("../../Player").global_position, false)
	
	if points.size() > 1:
		var distance = points[1] - enemy_position
		motion = distance.normalized()
		isRunning = true
		if points.size() < 1:
			isRunning = false
			motion = Vector2(0,0)