extends Node3D

@onready var terrain: Terrain = $Terrain

func _ready():
	terrain.generate()
