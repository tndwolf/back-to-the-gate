extends Node2D


var map:LevelMap setget set_map, get_map
var player:GameEntity
onready var world_tiles := $WorldTiles


func _ready():
	player = CharacterBuilder.new().is_player().build()
	add_child(player)
	GotoLevel.attempt(player, {'world_view': self})


func _process(delta):
	var actor = TurnManager.current()
	actor.mind.turn(map)
	while !actor.is_player:
		actor = TurnManager.current()
		actor.mind.turn(map)


func convert_tile(src_tile:int, up_tile:int=0):
	match src_tile:
		LevelMap.TileTypes.INVALID, LevelMap.TileTypes.WALL: return 0
		LevelMap.TileTypes.STAIRS: return 3
		LevelMap.TileTypes.VENT: return 2
		LevelMap.TileTypes.FLOOR: return 1
		LevelMap.TileTypes.DOOR:
			return 5 if up_tile == LevelMap.TileTypes.WALL else 4
		LevelMap.TileTypes.OPEN_DOOR:
			return 7 if up_tile == LevelMap.TileTypes.WALL else 6
	return -1


func get_map() -> LevelMap:
	return map


func set_map(value:LevelMap) -> void:
	map = value
	world_tiles.clear()
	for y in range(map.height()):
		for x in range(map.width()):
			var tile = map.get_tile(Vector2(x, y))
			var up_tile = map.get_tile(Vector2(x, y-1))
			world_tiles.set_cell(x, y, convert_tile(tile, up_tile))
	world_tiles.update_bitmask_region(Vector2.ZERO, map.size())
