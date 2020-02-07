extends TileMap

var emptySpaces = []
var playerResource = preload("res://assets/scenes/Characters/Player.tscn")
var Player
# Called when the node enters the scene tree for the first time.
func _ready():

	for i in range(-30,30):
		for j in range(-30,30):
			set_cell(i,j,0)
	
	var i = 0
	var j = 0
	var rng = RandomNumberGenerator.new()
	var numberOfSpaces = 300
	var prevDir = 0;
	while numberOfSpaces >= 0:
		if(!get_cell(i,j) in [1,2,3]):
			var k = rng.randi_range(1,3)
			set_cell(i,j,k)
			numberOfSpaces-=1
			emptySpaces.push_back(map_to_world(Vector2(i,j))+Vector2(32,32))
		var nextDir = rng.randi_range(0,3);
		if rng.randi_range(0,100) < 5:
			nextDir = prevDir;
		prevDir = nextDir;
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
	placePlayer()
	placeEnemies(30)
	pass # Replace with function body.

func placePlayer():
	var world = get_parent().get_parent()
	if (world):
		Player = playerResource.instance()
		world.call_deferred("add_child",Player);
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var randomPosition = rng.randi_range(0,emptySpaces.size()-1)
		Player.global_position = emptySpaces[randomPosition]
		emptySpaces.remove(randomPosition)
		
	else:
		print('Error, no World!')
	
	pass

func placeEnemies(quantity):
	var enemiesHolder = get_parent().get_node("Enemies")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	while quantity > 0:
		var randomPosition = rng.randi_range(0,emptySpaces.size()-1)
		var distance = (emptySpaces[randomPosition] - Player.global_position).length()
		if distance >= 250:
			var enemy = preload("res://assets/scenes/Characters/Enemy.tscn").instance()
			enemiesHolder.add_child(enemy)
			enemy.global_position = emptySpaces[randomPosition]
			quantity -= 1
		emptySpaces.remove(randomPosition)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
