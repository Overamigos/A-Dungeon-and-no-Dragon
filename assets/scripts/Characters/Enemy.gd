extends "res://assets/scripts/Characters/Character.gd"

var target
var points = []
enum STATE{
	SEARCHING,
	FOLLOWING,
	ATTACKING
}
var currState

var attackMaxCD = 0.75;
var attackCD = attackMaxCD

var initialAttackDelay = 0.25
var attackDelay = initialAttackDelay

func _ready():
	currState = STATE.SEARCHING
	maxHp = 3
	hp = maxHp
	baseSpeed = 70
	MOTION_SPEED = baseSpeed
	pass # Replace with function body.


func _physics_process(delta):
	checkDeath()
	var distance = null
	
	if has_node("../../../Player"):
		target = get_node("../../../Player")
		distance = (target.global_position - global_position).length()
	else:
		target = null
		return
	
	match currState:
		STATE.SEARCHING:
			if distance <= 200:
				currState = STATE.FOLLOWING
				
		STATE.FOLLOWING:
			if(target):
				chooseDirection()
				run()
			
			if distance >= 500:
				currState = STATE.SEARCHING
				
			elif distance <= 50:
				if attackCD <= 0:
					currState = STATE.ATTACKING
					attackCD = attackMaxCD
				
		STATE.ATTACKING:
			attackDelay -= delta
			if !has_node("Weapon") && attackDelay <= 0:
				var sword = preload("res://assets/scenes/Powers/Weapon.tscn").instance()
				add_child(sword)
				sword.get_node("Area2D").set_collision_mask_bit(2,false)
				
				#sword.scale = Vector2(0.6,0.6)
				#currState = STATE.FOLLOWING
			
	
	decideFacingDirection()
	decideAnimation(motion)
	handleCoolDowns(delta)
	
	pass

func handleCoolDowns(delta):
	if attackCD > 0:
		attackCD -= delta

func attackFinish():
	currState = STATE.FOLLOWING
	attackDelay = initialAttackDelay
	
func chooseDirection():
	var enemy_position = get_global_position()

	points = get_node("../../../Navigation2D").get_simple_path(enemy_position, target.global_position, true)
	#$Line2D.points = points
	#$Line2D.global_position = Vector2(0,0)
	var overlaps = $Vision.get_overlapping_areas()
	var avoid = Vector2(0,0)
	for overlap in overlaps:
		avoid -= global_position.direction_to(overlap.global_position)
	
	avoid*=2
	
	if points.size() > 1:
		var distance = (points[1] - points[0]).length()
		points.remove(0)
		if points.size() > 1 && distance < 20.0:
			points.remove(0)
			
		#$Line2D.points = [points[0], enemy_position]
		motion = (points[0] - enemy_position + avoid).normalized()
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