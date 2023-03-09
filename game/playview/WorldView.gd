extends Node2D


const DoorOccluderV = preload("res://game/playview/DoorOccluderV.tscn")


var map:LevelMap setget set_map, get_map
var player:GameEntity
onready var world_tiles := $WorldTiles


func _ready():
	player = CharacterBuilder.new().is_player().build()
	player.connect("dead", self, '_on_Player_dead')
	add_child(player)
	GotoLevel.attempt(player, {'world_view': self})


func _process(delta):
	var actor = TurnManager.current()
	if actor == null:
		return
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


func _on_Player_dead(player):
	TurnManager.clear()


func set_map(value:LevelMap) -> void:
	map = value
	world_tiles.clear()
	for y in range(map.height()):
		for x in range(map.width()):
			var tile = map.get_tile(Vector2(x, y))
			var up_tile = map.get_tile(Vector2(x, y-1))
			var effective_tile = convert_tile(tile, up_tile)
			if effective_tile == 5 or effective_tile == 4:
				var occluder = DoorOccluderV.instance()
				if effective_tile == 4:
					occluder.rotation_degrees = 90
				occluder.position = Vector2(x + 0.5, y + 0.5) * LevelBuilder.CELLS_SIZE
				map.place_occluder(occluder, Vector2(x, y))
				add_child(occluder)
			world_tiles.set_cell(x, y, effective_tile)
	world_tiles.update_bitmask_region(Vector2.ZERO, map.size())
	world_tiles.update_dirty_quadrants()
