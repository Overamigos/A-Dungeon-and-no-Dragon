extends KinematicBody2D

var dashingSpeed = 800; 			#Pixels/second
var baseSpeed = 200;				#Pixels/second
var MOTION_SPEED = baseSpeed; 		# Pixels/second
var isRunning = false
var isIdle = true

var dashMaxCD = 0.5;				#Seconds
var dashingMaxDuration = 0.2;		#Seconds
var dashCD = 0;						#Seconds
var dashingDuration = 0;			#Seconds
var dashingMotion = Vector2(0,0);	#Direction vector
var isDashing = false


var attackMaxCD = 0.1;				#Seconds
var attackCD = 0.1;					#Seconds
var isAttacking = false

var motion = Vector2(0,0)			#Direcion player is moving

var maxHp = 5;
var hp = maxHp;
var facing = "D"					#Initial facing direction

### UPDATE FUNCTION ###
func _physics_process(delta):
	checkDeath()
	handleInputs()
	decideFacingDirection()
	
	if isDashing:
		dash(delta)
	else:
		if isAttacking:
			attack()
		if isRunning:
			run(delta)
			
	decideAnimation(motion);
	handleCoolDowns(delta)
	MOTION_SPEED = baseSpeed;
	pass


##################################################################
func checkDeath():
	if hp <=0:
		var source = get_node("Camera2D");
		source.current = false;
		get_parent().queue_free()
		queue_free();
	else:
		return false


func handleInputs():
	motion = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_bottom") - Input.get_action_strength("move_up")
	)
	if Input.is_action_just_pressed("attack") && attackCD <= 0:
		attackCD = attackMaxCD
		isAttacking = true;
	if Input.is_action_just_pressed("dash") && dashCD <= 0 && !isDashing:
		isDashing = true
		dashingDuration = dashingMaxDuration;
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
					

	isRunning = motion != Vector2(0,0) && !isDashing



func dash(delta):
	$Hitbox/CollisionShape2D.disabled = true;
	set_collision_mask_bit(2,false)
	MOTION_SPEED = dashingSpeed;
	motion = dashingMotion;
	dashingDuration -= delta;
	motion = motion.normalized();
	if dashingDuration < 0:
		set_collision_mask_bit(2,true)
		$Hitbox/CollisionShape2D.disabled = false;
		dashingDuration = 0;
		isDashing = false
		dashCD = dashMaxCD;
		
	move_and_slide(motion * dashingSpeed);


func run(delta):
	move_and_slide(motion * MOTION_SPEED);
	pass


func attack():
	if !$Weapon:
		var sword = preload("res://assets/scenes/Powers/Weapon.tscn").instance()
		match facing:
			'L':
				sword.rotation_degrees = 0
			'R':
				sword.rotation_degrees = 180
			'U':
				sword.rotation_degrees = 90
			'D':
				sword.rotation_degrees = 270
		sword.position += Vector2(-25,0).rotated(sword.rotation)
		add_child(sword)
	pass


func handleCoolDowns(delta):
	dashCD -= delta
	attackCD -= delta


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


func decideAnimation(motion):
	$RunSprite.visible = false
	$IdleSprite.visible = false
	$DashSprite.visible = false
	$AttackSprite.visible = false
	var action;
	if isRunning:
		action = "Run"
		$RunSprite.visible = true
	elif isDashing:
		action = "Dash"
		$DashSprite.visible = true
	else:
		action = "Idle"
		$IdleSprite.visible = true
	$AnimationPlayer.play(action+"_"+facing)
	pass

##Signals

func _on_Area2D_area_entered(area):
	if(area.collision_mask == 2):
		print('hit');
		hp-=1;
	pass # Replace with function body.


func _on_DashGhostTimer_timeout():
	if isDashing:
		var thisGhost = preload("res://assets/scenes/Powers/DashGhost.tscn").instance()
		get_parent().add_child(thisGhost)
		thisGhost.position = position
		thisGhost.texture = $DashSprite.texture
		thisGhost.vframes = $DashSprite.vframes
		thisGhost.hframes = $DashSprite.hframes
		thisGhost.frame = $DashSprite.frame
	pass # Replace with function body.


func _on_DashSprite_frame_changed():
	
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	if 'Attack' in anim_name:
		isAttacking = false;
	pass # Replace with function body.
