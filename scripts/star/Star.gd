class_name Star
extends Node

const CHUNK_SCENE := preload("res://scenes/star/chunk.tscn")

@export var render_distance: int = 2
@export var chunk_size: float = 13

@export var circumnavigation: bool = false
@export var revolution_distance: int = 8

var active_coord: Array = []
var active_chunks: Array = []

var current_chunk: Vector2 = Vector2()
var previous_chunk: Vector2 = Vector2()
var chunk_loaded: bool = false

var noise: FastNoiseLite

func _init():
	Global.current_star = self

func _ready():
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi_range(0, 9999999)
	
	current_chunk = _get_player_chunk(Global.player.global_position)
	load_chunk()

func _process(_delta):
	current_chunk = _get_player_chunk(Global.player.global_position)
	if previous_chunk != current_chunk:
		if !chunk_loaded:
			load_chunk()
	else:
		chunk_loaded = false
	previous_chunk = current_chunk

func _get_player_chunk(pos):
	var chunk_pos = Vector2()
	chunk_pos.y = int(pos.z/chunk_size)
	chunk_pos.x = int(pos.x/chunk_size)
	if pos.x < 0:
		chunk_pos.x -= 1
	if pos.z < 0:
		chunk_pos.y -= 1
	return chunk_pos

func load_chunk():
	var render_bounds = (float(render_distance)*2.0)+1.0
	var loading_coord = []
	
	for x in range(render_bounds):
		for y in range(render_bounds):
			#await get_tree().create_timer(0.1).timeout
			var _x  = (x+1) - (round(render_bounds/2.0)) + current_chunk.x
			var _y  = (y+1) - (round(render_bounds/2.0)) + current_chunk.y
			
			var chunk_coords = Vector2(_x, _y)
			var chunk_key = _get_chunk_key(chunk_coords)
			loading_coord.append(chunk_coords)
			if active_coord.find(chunk_coords) == -1:
				var chunk = CHUNK_SCENE.instantiate()
				chunk.position = Vector3(chunk_coords.x, 0, chunk_coords.y) * chunk_size
				chunk.chunk_coords = chunk_key
				active_chunks.append(chunk)
				active_coord.append(chunk_coords)
				add_child.call_deferred(chunk)

	var deleting_chunks = []
	for x in active_coord:
		if loading_coord.find(x) == -1:
			deleting_chunks.append(x)
	for x in deleting_chunks:
		var index = active_coord.find(x)
		active_chunks[index].save()
		active_chunks.remove_at(index)
		active_coord.remove_at(index)
	
	chunk_loaded = true

func _get_chunk_key(coords : Vector2):
	var key = coords
	if !circumnavigation:
		return key
	key.x = wrapf(coords.x, -revolution_distance, revolution_distance+1)
	return key
 
