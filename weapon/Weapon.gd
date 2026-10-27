class_name Weapon
extends Node3D

static var instance: Weapon
static func get_instance() -> Weapon:
	return Weapon.instance

@export var magazine_type: WeaponType.type
@export var model: String
@export_range(0,3,0.001) var spring_adjust: float
@export var motor_rpm: float
@export var magazine: Magazine
@export var firing_mode: FireMode.mode
@export_range(0,18000) var hop_up: float = 6000

@export var rotations_per_fire: float
@export var fire_rate = motor_rpm/(60*rotations_per_fire)
@export var fire_interval = 1/fire_rate
@export var fire_timer: Timer = Timer.new() 

const bb: PackedScene = preload("res://bb/bb2.tscn") 
@onready var marker: Marker3D = $Marker3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
@export var spawn_point: Vector3
@export var player: Player = Player.get_instance()
@export var fire_flag: bool = false

func _ready() -> void:
	Weapon.instance = self
	fire_timer = $fire_timer
	magazine = $Magazine
	fire_timer.wait_time = fire_interval
	spawn_point = marker.global_position
	change_weapon(WeaponData.get_default_weapondata())
	set_player.call_deferred()
	
func fire() -> void:
	if (!player): #consertar essa atrocidade
		player = Player.get_instance()
	if fire_timer.is_stopped():
		if magazine != null:
			if magazine_type == magazine.type && magazine.has_ammo():
				var projectile_mass = magazine.mass_kg
				spawn_projectile(projectile_mass)
				magazine.fire()
				player.hud.update_ammo()
				fire_timer.start()
			else:
				feedback_empty_mag()
		else:
			feedback_no_mag()

func switch_fire_mode() -> void:
	if firing_mode == FireMode.mode.SEMI:
		firing_mode = FireMode.mode.AUTO
	else:
		firing_mode = FireMode.mode.SEMI
	player.hud.update_mode()

func feedback_empty_mag() -> void:
	fire_timer.start(0.2)
	sfx.play()
	

func feedback_no_mag() -> void:
	fire_timer.start(0.2)
	sfx.play()

func spawn_projectile(mass_kg: float) -> void:
	spawn_point = marker.global_position
	var projectile = bb.instantiate()
	projectile.global_position = spawn_point
	var joules = spring_adjust
	var bb_backspin = hop_up
	var air_density = Env.air_density
	#projectile.setup(mass_kg, joules, air_density, bb_backspin, self.global_transform)
	#se eu não der o setup aqui ele faz com o basis errado e o projétil não tem o efeito
	if (player):
		player.add_sibling(projectile)
	else:
		add_sibling(projectile)
	projectile.setup(mass_kg, joules, air_density, bb_backspin, self.global_transform)
	projectile.type = magazine_type
	if (player):
		projectile.velocity += player.velocity
	#mas se eu não colocar o setup aqui ele também fica com efeito errado por virtude de ir pra baixo
	#se o player virar pra trás
	#e em ambos os casos não faz a merda do efeito
func change_weapon(data: WeaponData) -> void:
	self.magazine_type = data.magazine_type
	self.model = data.model
	self.spring_adjust = data.spring_adjust
	self.motor_rpm = data.motor_rpm
	self.hop_up = data.hop_up
	change_mag(data.magazine)
	self.rotations_per_fire = data.rotations_per_fire
	fire_rate = motor_rpm/(60*rotations_per_fire)
	fire_interval = 1/fire_rate
	fire_timer.wait_time = fire_interval
	
func change_mag(mag: Magazine) -> void:
	magazine.change_mag(mag)
	if (player):
		player.hud.update()

func reload() -> void:
	magazine.reload()
	player.hud.update_ammo()
func start_shooting():
	fire_flag = true
	if (firing_mode == FireMode.mode.SEMI):
		fire()
	else:
		while fire_flag:
			if !fire_timer.is_stopped():
				await fire_timer.timeout
			fire()
func stop_shooting():
	fire_flag = false

func increase_hopup() -> void:
	if (hop_up < 18000):
		hop_up += 250
		player.hud.update_hopup()

func decrease_hopup() -> void:
	if (hop_up > 0):
		hop_up -= 250
		player.hud.update_hopup()

func set_player() -> void:
	player = Player.get_instance()

func change_type(type: WeaponType.type):
	magazine_type = type
	player.hud.update_make()
	var mat: StandardMaterial3D = mesh.get_active_material(0)
	mat.albedo_color = WeaponType.color_dict[type]
	mat.emission = WeaponType.color_dict[type]
