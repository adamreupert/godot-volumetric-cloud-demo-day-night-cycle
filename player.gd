extends CharacterBody3D

#Camera variables
@onready var camrot_h := $h
@onready var camrot_v := $h/v
@export var mouse_sensitivity = 0.01
@export var cam_v_angle = Vector2(-55,75)
@export var cam_h_angle = Vector2(-90,90)
#@export var cam_acceleration = 10


# Movement variables
var player_movement_speed = 5.0
@export var jump_velocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camrot_h.rotate_y(-event.relative.x * mouse_sensitivity)
			camrot_v.rotate_x(-event.relative.y * mouse_sensitivity)
			camrot_v.rotation.x = clamp(camrot_v.rotation.x, deg_to_rad(cam_v_angle.x),deg_to_rad(cam_v_angle.y))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (camrot_h.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * player_movement_speed
		velocity.z = direction.z * player_movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_movement_speed)
		velocity.z = move_toward(velocity.z, 0, player_movement_speed)

	move_and_slide()
