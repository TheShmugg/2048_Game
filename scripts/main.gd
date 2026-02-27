extends Node2D

@export var tile_scene: PackedScene

const TILE_SIZE = 180
const TILE_POSITIONS = [10, 10 + TILE_SIZE, 10 + 2 * TILE_SIZE, 10 + 3 * TILE_SIZE]
const GRID_SIZE = 4


func _ready() -> void:
		spawn_tile()
		spawn_tile()


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


func spawn_tile():
	var tile = tile_scene.instantiate()
	var pos = random_pos()
	
	if tile.get_pos().x == -1 or tile.get_pos().y == -1:
		print("Lose")
		return
	
	tile.set_pos(pos)
	tile.position = grid_to_pixel(pos)
	add_child(tile)
	print(tile.get_value())
	print(tile.get_pos())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		move_left()
		spawn_tile()
	elif event.is_action_pressed("ui_right"):
		move_right()
		spawn_tile()
	elif event.is_action_pressed("ui_up"):
		move_up()
		spawn_tile()
	elif event.is_action_pressed("ui_down"):
		move_down()
		spawn_tile()


func move_left():
	var tiles = get_tree().get_nodes_in_group("tiles")
	
	for tile in tiles:
		for other in tiles:
			var target = grid_to_pixel(tile.get_pos()).y - TILE_SIZE
			#while target != grid_to_pixel(other.get_pos()).y or target > 10:
				#tile.translate(Vector2i(-TILE_SIZE, 0))
				#target -= TILE_SIZE


func move_right():
	print("right")


func move_up():
	print("up")


func move_down():
	print("down")
