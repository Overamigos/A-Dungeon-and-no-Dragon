extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
var speed = 60
var hp = 1
var target
var points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if hp <=0:
		queue_free()
	
	var enemy_position = get_global_position()
	
	points = get_node("../../Navigation2D").get_simple_path(enemy_position, get_node("../../Player").global_position, false)
	
	if points.size() > 1:
		var distance = points[1] - enemy_position
		var direction = distance.normalized()
		if points.size() > 2:
			move_and_slide(speed*direction)
		else:
			move_and_slide(Vector2(0,0))
	
	#if(get_node("../../Player")):
	#	var distance = (get_node("../../Player").global_position - global_position).normalized()

	#	move_and_slide(speed*distance)
	pass
