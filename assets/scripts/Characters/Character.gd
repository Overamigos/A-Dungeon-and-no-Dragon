extends KinematicBody2D

var motion = Vector2(0,0)			#Direcion player is moving

var isRunning = false
var isIdle = true

var maxHp = 5;
var hp = maxHp;
var facing = "D"					#Initial facing direction

var baseSpeed = 200;				#Pixels/second
var MOTION_SPEED = baseSpeed; 		# Pixels/second

func run(delta):
	move_and_slide(motion * MOTION_SPEED);
	pass

func decideFacingDirection():
	if $AnimationPlayer.is_playing():
		var split = $AnimationPlayer.current_animation.rsplit ('_',true,1)
		facing = split[-1]
	var vertical = motion[0];
	var horizontal = motion[1];
	if abs(vertical) > abs(horizontal):
		if vertical > 0:
			facing = "R"
		else:
			facing = "L"
	if abs(vertical) < abs(horizontal):
		if horizontal > 0:
			facing = "D"
		else:
			facing = "U"
	else:
		if vertical < 0 && facing == "R":
			facing = "L"
		elif vertical > 0 && facing == "L":
			facing = "R"
		elif horizontal < 0 && facing == "U":
			facing = "U"
		elif horizontal > 0 && facing == "D":
			facing = "D"
	pass

func checkDeath():
	if hp <=0:
		queue_free();
	else:
		return false