extends KinematicBody2D
const MOTION_SPEED = 200; # Pixels/second
var lastMotion = Vector2(0,0);

func _physics_process(_delta):
	var motion = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_bottom") - Input.get_action_strength("move_up")
	);	
	motion = motion.normalized()
	decideAnimation(motion);
	move_and_slide(motion * MOTION_SPEED);

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
		var vertical = motion[0];
		var horizontal = motion[1];
		if abs(vertical) > abs(horizontal):
			if vertical > 0:
				$RunSprite/AnimationPlayer.play("RunRight");
			else:
				$RunSprite/AnimationPlayer.play("RunLeft");
		if abs(vertical) < abs(horizontal):
			if horizontal > 0:
				$RunSprite/AnimationPlayer.play("RunDown");
			else:
				$RunSprite/AnimationPlayer.play("RunUp");
		else:
			if vertical < 0 && $RunSprite/AnimationPlayer.current_animation == 'RunRight':
				$RunSprite/AnimationPlayer.play("RunLeft");
			elif vertical > 0 && $RunSprite/AnimationPlayer.current_animation == 'RunLeft':
				$RunSprite/AnimationPlayer.play("RunRight");
			elif horizontal < 0 && $RunSprite/AnimationPlayer.current_animation == 'RunDown':
				$RunSprite/AnimationPlayer.play("RunUp");
			elif horizontal > 0 && $RunSprite/AnimationPlayer.current_animation == 'RunUp':
				$RunSprite/AnimationPlayer.play("RunDown");