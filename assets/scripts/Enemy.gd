extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
var speed = 60
var hp = 2
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if hp <=0:
		queue_free()
	
	if(get_node("../Player")):
		var distance = (get_node("../Player").global_position - global_position).normalized()

		move_and_slide(speed*distance)
	pass
