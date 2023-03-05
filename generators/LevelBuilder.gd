class_name LevelBuilder
extends Node


enum LevelTypes {
	LAB,
	EXCAVATION,
	CAVE
}


const DIRECTIONS := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const CELLS_SIZE := Vector2(16, 16)


var _level_type = LevelTypes.CAVE
var _rooms_count := 6
var _room_size := Vector2.ONE * 12
var _size := Vector2.ONE * 32
var _steps := 64


func _add_doors(map:LevelMap, area:Rect2):
	if randi() % 2 == 0:
		var x = area.position.x + 1 + randi() % int(area.size.x - 2)
		var y = area.position.y if randi() % 2 == 0 else area.end.y-1
		map.set_tile(LevelMap.TileTypes.DOOR, Vector2(x, y))
	else:
		var y = area.position.y + 1 + randi() % int(area.size.y - 2)
		var x = area.position.x if randi() % 2 == 0 else area.end.x-1
		map.set_tile(LevelMap.TileTypes.DOOR, Vector2(x, y))


func build() -> LevelMap:
	var res = LevelMap.new()
	match _level_type:
		LevelTypes.LAB: _build_lab(res)
		_: _build_cave(res)
	res.dump()
	return res


func _build_cave(map:LevelMap):
	map.init(_size, LevelMap.TileTypes.WALL)
	var position := rand_point(map.area, 1)
	var step = 0
	map.start = position
	while step < _steps:
		map.set_tile(LevelMap.TileTypes.FLOOR, position)
		var next_position = position + DIRECTIONS[randi() % 4]
		if !map.is_valid(next_position):
			continue
		position = next_position
		if map.get_tile(position) == LevelMap.TileTypes.WALL:
			step += 1
	return map


func _build_lab(map:LevelMap):
	map.init(_size, LevelMap.TileTypes.INVALID)
	_dig_room(map, map.area, false)
	var rooms = []
	while rooms.size() < _rooms_count:
		var room = Rect2()
		room.position = rand_point(map.area)
		room.size = Vector2(5 + randi() % int(_room_size.x), 5 + randi() % int(_room_size.y))
		if _is_free(map, room):
			print(room)
			rooms.append(room)
			_dig_room(map, room)
			map.set_tile(LevelMap.TileTypes.VENT, rand_point(room, 1))
	_connect(map, rooms)
	map.start = rand_point(map.area, 1)
	for y in range(map.area.position.y + 1, map.area.end.y):
		for x in range(map.area.position.x + 1, map.area.end.x):
			var coords = Vector2(x, y)
			if map.get_tile(coords) == LevelMap.TileTypes.INVALID:
				map.set_tile(LevelMap.TileTypes.FLOOR, coords)
			if map.get_tile(coords) == LevelMap.TileTypes.DOOR and _surrounded(map, coords):
				map.set_tile(LevelMap.TileTypes.WALL, coords)
	map.start = rand_point(rooms[0], 1)
	map.end = rand_point(rooms[-1], 1)
	map.set_tile(LevelMap.TileTypes.STAIRS, map.end)
	return map


static func _surrounded(map:LevelMap, coords:Vector2) -> bool:
	var walls := 0
	for delta in DIRECTIONS:
		if map.get_tile(coords + delta) == LevelMap.TileTypes.WALL:
			walls += 1
	return walls > 2


static func _connect(map:LevelMap, rooms:Array):
	for i in range(rooms.size() - 1):
		var r0 = rooms[i]
		var r1 = rooms[i + 1]
		var start = rand_point(r0, 2)
		var end = rand_point(r1, 2)
		var position = start
		var delta = Vector2.LEFT if start.x > end.x else Vector2.RIGHT
		while position != end:
			if position.x == end.x:
				delta = Vector2.UP if start.y > end.y else Vector2.DOWN
			position += delta
			print('%s -> %s : %s' % [start, end, position])
			if (map.get_tile(Vector2(position)) == LevelMap.TileTypes.WALL
			and map.get_tile(Vector2(position+Vector2.LEFT)) != LevelMap.TileTypes.DOOR
			and map.get_tile(Vector2(position+Vector2.RIGHT)) != LevelMap.TileTypes.DOOR
			and map.get_tile(Vector2(position+Vector2.UP)) != LevelMap.TileTypes.DOOR
			and map.get_tile(Vector2(position+Vector2.DOWN)) != LevelMap.TileTypes.DOOR
			):
				map.set_tile(LevelMap.TileTypes.DOOR, Vector2(position))


static func _dig_room(map:LevelMap, area:Rect2, dig_floors:bool=true):
	for y in range(area.position.y, area.end.y):
		for x in range(area.position.x, area.end.x):
			if x == area.position.x or x == area.end.x-1:
				map.set_tile(LevelMap.TileTypes.WALL, Vector2(x, y))
			elif y == area.position.y or y == area.end.y-1:
				map.set_tile(LevelMap.TileTypes.WALL, Vector2(x, y))
			elif dig_floors and map.get_tile(Vector2(x, y)) == LevelMap.TileTypes.INVALID:
				map.set_tile(LevelMap.TileTypes.FLOOR, Vector2(x, y))


static func _is_free(map:LevelMap, area:Rect2):
	for y in range(area.position.y + 1, area.end.y - 1):
		for x in range(area.position.x + 1, area.end.x - 1):
			if map.get_tile(Vector2(x, y)) != LevelMap.TileTypes.INVALID:
				return false
			if !map.is_valid(Vector2(x, y)):
				return false
	return true


static func rand_point(within:Rect2, border_size:int = 0) -> Vector2:
	var x0 = within.position.x + border_size
	var y0 = within.position.y + border_size
	var dx = int(within.size.x - 2 * border_size)
	var dy = int(within.size.y - 2 * border_size)
	return Vector2(x0 + randi() % dx, y0 + randi() % dy)


func set_type(value:int) -> LevelBuilder:
	_level_type = value
	return self
