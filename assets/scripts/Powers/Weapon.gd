extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

func _ready():
	match get_parent().facing:
		'L':
			rotation_degrees = 0
		'R':
			rotation_degrees = 180
		'U':
			rotation_degrees = 90
		'D':
			rotation_degrees = 270
	position += Vector2(-25,0).rotated(rotation)
	$AnimationPlayer.play("attack")
	for i in range(0,20):
		$Area2D.set_collision_layer_bit(i,get_parent().get_node("Hitbox").get_collision_layer_bit(i))
		$Area2D.set_collision_mask_bit(i,get_parent().get_node("Hitbox").get_collision_mask_bit(i))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().call('attackFinish')
	queue_free()
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	if area.name == 'Hitbox':
		if $Area2D.collision_layer != area.collision_layer:
			var impact = preload("res://assets/scenes/Particles/impact.tscn").instance()
			get_parent().add_child(impact)
			impact.global_position = area.global_position
			area.get_parent().hp -= 1
	pass # Replace with function body.
