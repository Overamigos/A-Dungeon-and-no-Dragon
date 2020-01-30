extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$alpha_tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), .2, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$alpha_tween.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_alpha_tween_tween_completed(object, key):
	queue_free()
	pass # Replace with function body.