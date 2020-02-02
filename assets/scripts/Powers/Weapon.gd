extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("attack")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	get_parent().isAttacking = false
	queue_free()
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	area.get_parent().hp -= 1
	pass # Replace with function body.
