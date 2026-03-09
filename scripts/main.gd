extends Node2D

@export var tile_scene: PackedScene

const TILE_SIZE = 180
const TILE_POSITIONS = [100, 100 + TILE_SIZE, 100 + 2 * TILE_SIZE, 100 + 3 * TILE_SIZE]
const GRID_SIZE = 4


func _ready() -> void:
	#spawn_tile()
	#spawn_tile()
	
	test_spawn(Vector2i(1, 0))
	test_spawn(Vector2i(3, 0))


func grid_to_pixel(pos: Vector2i) -> Vector2:
	return Vector2(
		TILE_POSITIONS[pos.x],
		TILE_POSITIONS[pos.y]
	)


func random_pos() -> Vector2i:
	var tiles = get_tree().get_nodes_in_group("tiles")
	var empty_pos = []
	
	for x in 4:
		for y in 4:
			var pos = Vector2i(x, y)
			
			var occupied = false
			for tile in tiles:
				if tile.get_pos() == pos:
					occupied = true
					break
			
			if not occupied:
				empty_pos.append(pos)
	
	if empty_pos.is_empty():
		return Vector2i(-1, -1)
	
	return empty_pos.pick_random()

func test_spawn(pos: Vector2i):
	var tile = tile_scene.instantiate()
	
	if pos.x == -1 or pos.y == -1:
		print("Lose")
		return
	
	tile.set_pos(pos)
	tile.position = grid_to_pixel(pos)
	add_child(tile)


func spawn_tile():
	var tile = tile_scene.instantiate()
	var pos = random_pos()
	
	if pos.x == -1 or pos.y == -1:
		print("Lose")
		return
	
	tile.set_pos(pos)
	tile.position = grid_to_pixel(pos)
	add_child(tile)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		move_left()
	elif event.is_action_pressed("ui_right"):
		move_right()
		spawn_tile()
	elif event.is_action_pressed("ui_up"):
		move_up()
		spawn_tile()
	elif event.is_action_pressed("ui_down"):
		move_down()
		spawn_tile()


func merge_tiles(tile, target):
	tile.animate_to(grid_to_pixel(target.get_pos()))
	target.set_value(target.value * 2)
	target.set_merged(true)
	target.play_merged()
	
	tile.queue_free()


func move_left():
	var tiles: Array = get_tree().get_nodes_in_group("tiles")
	var can_spawn = false
	var empty_pos = []
	
	for x in 4:
		for y in 4:
			var pos = Vector2i(x, y)
			
			var occupied = false
			for tile in tiles:
				tile.set_merged(false)
				if tile.get_pos() == pos:
					occupied = true
					break
			
			if not occupied:
				empty_pos.append(pos)
	
	for tile in tiles:
		tiles.sort_custom(Callable(tile, "sort_left"))
		for x in range(0, tile.get_pos().x):
			var target = Vector2i(x, tile.get_pos().y)
			if target in empty_pos:
				empty_pos.append(tile.get_pos())
				#tile.animate_to(grid_to_pixel(target))
				tile.position = grid_to_pixel(target)
				empty_pos.erase(target)
				can_spawn = true
				break
			else:
				for other in tiles:
					if tile.get_value() == other.get_value() and target == other.get_pos() and not other.get_merged():
						merge_tiles(tile, other)
						can_spawn = true
						break
	
	if can_spawn == true:
		spawn_tile()


func move_right():
	print("right")


func move_up():
	print("up")


func move_down():
	print("down")
