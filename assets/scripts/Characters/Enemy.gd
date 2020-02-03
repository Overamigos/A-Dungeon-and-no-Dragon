extends "res://assets/scripts/Characters/Character.gd"

var target
var points = []

func _ready():
	maxHp = 1
	hp = maxHp
	baseSpeed = 50
	MOTION_SPEED = 50
	pass # Replace with function body.


func _physics_process(delta):
	checkDeath()
	if(get_node("../../../Player")):
		target = get_node("../../../Player")
		chooseDirection()
		decideFacingDirection()
		run(delta)
	decideAnimation(motion)
	
	pass

func chooseDirection():
	var enemy_position = get_global_position()

	points = get_node("../../../Navigation2D").get_simple_path(enemy_position, target.global_position, true)
	$Line2D.points = points
	$Line2D.global_position = Vector2(0,0)
		
	if points.size() > 1:
		var distance = (points[1] - points[0]).length()
		if distance > 2.0 :
			motion = (points[1] - enemy_position).normalized()
			isRunning = true
		elif points.size() > 2:
			motion = (points[2] - enemy_position).normalized()
			isRunning = true
		else:
			isRunning = false
			motion = Vector2(0,0)


func decideAnimation(motion):
	$RunSprite.visible = false
	$IdleSprite.visible = false
	var action;
	if isRunning:
		action = "Run"
		$RunSprite.visible = true
	else:
		action = "Idle"
		$IdleSprite.visible = true
	$AnimationPlayer.play(action+"_"+facing)
	pass