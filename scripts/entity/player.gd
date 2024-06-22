extends CharacterBody3D

@export var walk_speed: float = 500.0
@export var jump_power: float = 4.5
@export var mouse_sensitivity: float = 0.01

@onready var camera: Camera3D = $Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var speed: float = walk_speed

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.z = move_toward(velocity.z, 0, speed * delta)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
