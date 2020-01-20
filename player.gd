extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 200 # Pixels/second


func _physics_process(_delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_bottom"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
	
	decideAnimation(motion);
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)

func decideAnimation(motion):
	if motion == Vector2(0, 0):
		var oldAnimation = $RunSprite/AnimationPlayer.current_animation;
		var newAnimation = oldAnimation.replace('Run','Idle');
		$RunSprite.hide();
		$IdleSprite.show();
		$IdleSprite/AnimationPlayer.play(newAnimation);
	else:
		$IdleSprite.hide();
		$RunSprite.show();
	
	if motion == Vector2(1, 0):
		$RunSprite/AnimationPlayer.play("RunRight");
	if motion == Vector2(-1, 0):
		$RunSprite/AnimationPlayer.play("RunLeft");
	if motion == Vector2(0, 1):
		$RunSprite/AnimationPlayer.play("RunDown");
	if motion == Vector2(0, -1):
		$RunSprite/AnimationPlayer.play("RunUp");
	if motion == Vector2(1, 1):
		$RunSprite/AnimationPlayer.play("RunDownRight");
	if motion == Vector2(-1, 1):
		$RunSprite/AnimationPlayer.play("RunDownLeft");
	if motion == Vector2(1, -1):
		$RunSprite/AnimationPlayer.play("RunUpRight");
	if motion == Vector2(-1, -1):
		$RunSprite/AnimationPlayer.play("RunUpLeft");