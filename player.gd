extends KinematicBody2D

var dashingSpeed = 600; 			#Pixels/second
var baseSpeed = 200;				#Pixels/second
var MOTION_SPEED = baseSpeed; 		# Pixels/second

var dashMaxCD = 0.5;				#Seconds
var dashingMaxDuration = 0.2;		#Seconds
var dashCD = 0;						#Seconds
var dashingDuration = 0;			#Seconds
var isDashing = false;				#If entity is dashing
var dashingMotion = Vector2(0,0);	#Direction vector

var facing = "D"					#Initial facing direction

var isAttacking = false;			#If entity is attacking
var attackMaxCD = 0.1;				#Seconds
var attackCD = 0;					#Seconds

var maxHp = 2;
var hp = maxHp;

func _process(delta):
	get_node("Camera2D/healthText").text = "health: %d" % hp;
	if hp <=0:
		print('dead');
		var source = get_node("Camera2D");
		source.current = false;
		queue_free();
	pass

func _physics_process(delta):
	var motion = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_bottom") - Input.get_action_strength("move_up")
	);
	
	if Input.is_action_just_pressed("Attack") && attackCD:
		print('attack')
		isAttacking = true

	if Input.is_action_just_pressed("dash") && dashCD == 0 && !isDashing:
		isDashing = true;
		dashingDuration = dashingMaxDuration;
		get_node("Hitbox/CollisionShape2D").disabled = true;
		dashingMotion = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_bottom") - Input.get_action_strength("move_up")
		);
		if dashingMotion == Vector2(0,0):
			decideAnimation(motion);
			match(facing):
				"D":
					dashingMotion = Vector2(0,1);
				"U":
					dashingMotion = Vector2(0,-1);
				"R":
					dashingMotion = Vector2(1,0);
				"L":
					dashingMotion = Vector2(-1,0);

	if isDashing:
		MOTION_SPEED = dashingSpeed;
		motion = dashingMotion;
		dashingDuration -= delta;
		if dashingDuration < 0:
			get_node("Hitbox/CollisionShape2D").disabled = false;
			dashingDuration = 0;
			isDashing = false;
			dashCD = dashMaxCD;

	motion = motion.normalized();
	decideAnimation(motion);
	move_and_slide(motion * MOTION_SPEED);

	if dashCD > 0:
		dashCD -= delta;
	elif dashCD <0:
		dashCD = 0;

	MOTION_SPEED = baseSpeed;

func decideAnimation(motion):
	if $Sprite/AnimationPlayer.is_playing():
		var split = $Sprite/AnimationPlayer.current_animation.rsplit ('_',true,1)
		facing = split[-1]
	var action;
	
	if motion == Vector2(0, 0):
		action = 'Idle';
	else:
		action = 'Run'
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

	if isAttacking:
		action = "Attack"
		#$Sprite/AnimationPlayer.
		
	$Sprite/AnimationPlayer.play(action+"_"+facing)
	pass

func _on_Area2D_area_entered(area):
	if(area.collision_mask == 2):
		print('hit');
		hp-=1;
	pass # Replace with function body.
