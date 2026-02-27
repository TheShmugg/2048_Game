extends Node2D

var pos_x: int
var pos_y: int
var pos: Vector2i
var color: Color
var value: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("tiles")
	value = random_value()
	$Value.text = str(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_pos()
	update_color()


func random_value() -> int:
	var random_float = randf()

	if random_float < 0.9:
		return 2
	else:
		return 4


func get_pos() -> Vector2i:
	pos_x = (get_position().x - 10) / 180
	pos_y = (get_position().y - 10) / 180
	return Vector2i(pos_x, pos_y)


func get_color() -> Color:
	return color


func get_value() -> int:
	return value


func set_pos(p: Vector2i):
	pos = p
	pos_x = p.x
	pos_y = p.y


func set_value(num: int):
	value = num


func update_pos():
	pos_x = (get_position().x - 10) / 180
	pos_y = (get_position().y - 10) / 180
	pos = Vector2i(pos_x, pos_y)


func update_color():
	var colors = {
		2: Color("#fff089"),
		4: Color("f8c53a"),
		8: Color("#e88a36"),
		16: Color("#f1641f"),
		32: Color("#b9451d"),
		64: Color("#612721"),
		128: Color("#612721"),
		256: Color("#966888"),
		512: Color("#966888"),
		1024: Color("#bfa5c9"),
		2048: Color("#c9d4fd"),
		4096: Color("#8aa1f6"),
		8192: Color("#4572e3"),
		16384: Color("#2789cd"),
		32768: Color("#42bfe8"),
		65536: Color("#59cf93"),
		131072: Color("#42a459")
	}
	
	$Color.color = colors.get(value)
