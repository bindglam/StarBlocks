extends Node3D

@export var chunk_coords: Vector2i = Vector2i()

@onready var terrain: Terrain = $Terrain

var chunk_data: Array = []

var thread: Thread

func _ready():
	if WorldSave.loaded_coords.find(chunk_coords) == -1:
		WorldSave.add_chunk(chunk_coords)
	else:
		chunk_data = WorldSave.retrive_data(chunk_coords)
	
	thread = Thread.new()
	thread.start(terrain.generate.bind(chunk_coords))
	#terrain.generate(chunk_coords)

func save():
	if thread != null and is_instance_valid(thread):
		thread.wait_to_finish()
	WorldSave.save_chunk(chunk_coords, chunk_data)
	queue_free()
