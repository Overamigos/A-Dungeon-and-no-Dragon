extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():

	for i in range(-100,100):
		for j in range(-100,100):
			set_cell(i,j,0)
	
	var i = 0
	var j = 0
	var rng = RandomNumberGenerator.new()
	var numberOfSpaces = 1000
	
	while numberOfSpaces >= 0:
		if(get_cell(i,j) != -1):
			set_cell(i,j,-1)
			numberOfSpaces-=1
		var nextDir = rng.randi_range(0,3)
		match(nextDir):
			0:
				i-=1
			1:
				i+=1
			2:
				j-=1
			3:
				j+=1
		
	
	update_bitmask_region()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
