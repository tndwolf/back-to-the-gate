extends Node2D


var map:LevelMap setget set_map, get_map
var player:GameEntity
onready var world_tiles := $WorldTiles


func _ready():
	set_map(LevelBuilder.new().set_type(LevelBuilder.LevelTypes.LAB).build())
	player = CharacterBuilder.new().is_player().build()
	add_child(player)
	MoveAction.teleport(player, map.start, map)
	var enemy = CharacterBuilder.new().model(CharacterBuilder.HumanModel.instance()).build()
#	var enemy = CharacterBuilder.new().build()
	add_child(enemy)
	MoveAction.teleport(enemy, map.start + Vector2.LEFT, map)
	TurnManager.add(player)
	TurnManager.add(enemy)


func _process(delta):
	TurnManager.current().mind.turn(map)


func convert_tile(src_tile:int):
	match src_tile:
		LevelMap.TileTypes.INVALID, LevelMap.TileTypes.WALL: return 0
		LevelMap.TileTypes.DOOR: return 7
		LevelMap.TileTypes.STAIRS: return 3
		LevelMap.TileTypes.VENT: return 2
		LevelMap.TileTypes.FLOOR: return 1
	return -1


func get_map() -> LevelMap:
	return map


func set_map(value:LevelMap) -> void:
	map = value
	world_tiles.clear()
	for y in range(map.height()):
		for x in range(map.width()):
			var tile = map.get_tile(Vector2(x, y))
			world_tiles.set_cell(x, y, convert_tile(tile))
