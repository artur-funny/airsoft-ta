class_name Player
extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.3

static var instance: Player
static func get_instance() -> Player:
	return Player.instance
	
@onready var camera: Camera3D = $Head/Camera3D
var mouseInput: Vector2 = Vector2(0,0)
@onready var head: Node3D = $Head
@onready var weapon: Weapon = $Head/Weapon
@onready var hud: PlayerHud = $PlayerHud

@export_group("Game Settings")
@export var scored: bool = true
@export var score: int = 0
@export var pass_score: int = 30
@export var timed: bool = true
@export var time_left: float = 120

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Player.instance = self
	hud.weapon = weapon
	hud.player = self
	#Engine.time_scale = 0.1
	hud.update()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_cancel"):
		match (Input.mouse_mode):
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	handle_aim()
	handle_moving()
	handle_weapon()
	if (timed):
		handle_time(delta)
	move_and_slide()

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouseInput = event.relative
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon.increase_hopup()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon.decrease_hopup()


func handle_time(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		hud.update_time()
	else:
		time_up()

func handle_moving():
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var temp := input_dir.rotated(-head.rotation.y)
	var direction = Vector3(temp.x, 0, temp.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func handle_aim():
	head.rotation_degrees.y -= mouseInput.x * MOUSE_SENS
	head.rotation_degrees.x -= mouseInput.y * MOUSE_SENS
	mouseInput = Vector2.ZERO
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func handle_weapon():
	if Input.is_action_just_pressed("m1"):
		weapon.start_shooting()
	if Input.is_action_just_released("m1"):
		weapon.stop_shooting()
	if Input.is_action_just_pressed("r"):
		weapon.reload()
	if Input.is_action_just_pressed("f"):
		weapon.switch_fire_mode()
	if Input.is_action_just_pressed("1"):
		weapon.change_type(WeaponType.type.Rifle)
	if Input.is_action_just_pressed("2"):
		weapon.change_type(WeaponType.type.Pistol1911)
	if Input.is_action_just_pressed("3"):
		weapon.change_type(WeaponType.type.Glock)
	if Input.is_action_just_pressed("4"):
		weapon.change_type(WeaponType.type.Shotgun)

func score_add(amount: int) -> void:
	score += amount
	hud.update_score()

func time_up() -> void:
	Scenes.player_score = score
	if (scored):
		Scenes.needed_score = pass_score
	if (!scored || score >= pass_score):
		get_tree().change_scene_to_file(Scenes.winscreen)
	else:
		get_tree().change_scene_to_file(Scenes.losescreen)
