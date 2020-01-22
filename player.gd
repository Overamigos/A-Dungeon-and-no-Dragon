extends KinematicBody2D

var dashingSpeed = 800; 			#Pixels/second
var baseSpeed = 200					#Pixels/second
var MOTION_SPEED = baseSpeed; 		# Pixels/second

var dashMaxCD = 0.5;					#Seconds
var dashingMaxDuration = 0.15;		#Seconds
var dashCD = 0;						#Seconds
var dashingDuration = 0;			#Seconds
var isDashing = false;				#If entity is dashing
var dashingMotion = Vector2(0,0);	#Direction vector

var maxHp = 2;
var hp = maxHp;

func _process(delta):
	get_node("Camera2D/healthText").text = "health: %d" % hp;
	if hp <=0:
		print('dead');
		var target = get_node('../..')
		var source = get_node("Camera2D")
		source.current = false;
		queue_free()
	pass

func _physics_process(delta):
	var motion = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_bottom") - Input.get_action_strength("move_up")
	);

	if Input.is_action_just_pressed("dash") && dashCD == 0 && !isDashing:
		dashCD = dashMaxCD
		MOTION_SPEED = dashingSpeed;
		dashingDuration = dashingMaxDuration;
		get_node("Hitbox/CollisionShape2D").disabled = true;
		isDashing = true;
		dashingMotion = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_bottom") - Input.get_action_strength("move_up")
		);
		if dashingMotion == Vector2(0,0):
			decideAnimation(motion);
			match($IdleSprite/AnimationPlayer.current_animation):
				"IdleDown":
					dashingMotion = Vector2(0,1);
				"IdleUp":
					dashingMotion = Vector2(0,-1);
				"IdleRight":
					dashingMotion = Vector2(1,0);
				"IdleLeft":
					dashingMotion = Vector2(-1,0);

	if isDashing:
		MOTION_SPEED = dashingSpeed
		motion = dashingMotion;
		dashingDuration -= delta
		if dashingDuration < 0:
			get_node("Hitbox/CollisionShape2D").disabled = false;
			dashingDuration = 0
			isDashing = false;
			dashCD = dashMaxCD;

	motion = motion.normalized()
	decideAnimation(motion);
	move_and_slide(motion * MOTION_SPEED);

	if dashCD > 0:
		dashCD -= delta;
	elif dashCD <0:
		dashCD = 0

	MOTION_SPEED = baseSpeed

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
	pass

func _on_Area2D_area_entered(area):
	if(area.collision_mask == 2):
		print('hit');
		hp-=1;
	pass # Replace with function body.
