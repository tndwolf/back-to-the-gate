class_name LevelMap
extends Resource


enum TileTypes {
	INVALID,
	FLOOR,
	WALL,
	DOOR,
	STAIRS,
	VENT
}


var area := Rect2()
var entities = {}
var end := Vector2.ZERO
var start := Vector2.ZERO
var tiles = []


func dump() -> void:
	for y in range(height()):
		var row = ''
		for x in range(width()):
			row += str(tiles[x + y * width()])
		print(row)


func entities_at(coords:Vector2) -> Array:
	if !is_valid(coords) or !(coords in entities):
		return []
	return entities[coords]


func get_tile(at:Vector2) -> int:
	if is_valid(at):
		return tiles[at.x + at.y * area.size.x]
	return 0


func height() -> int:
	return int(area.size.y)


func init(size:Vector2, def_tile:int=0):
	area = Rect2(Vector2.ZERO, size)
	tiles.clear()
	for _i in range(size.x * size.y):
		tiles.append(def_tile)


func is_valid(at:Vector2) -> bool:
	return area.has_point(at)


func place_entity(entity, at:Vector2):
	if at in entities:
		if entity in entities[at]:
			return
		entities[at].append(entity)
		return
	entities[at] = [entity]


func remove_entity(entity, from:Vector2):
	if from in entities:
		entities[from].erase(entity)


func set_tile(tile:int, at:Vector2) -> void:
	if is_valid(at):
		tiles[at.x + at.y * area.size.x] = tile


func size() -> Vector2:
	return area.size


func width() -> int:
	return int(area.size.x)
