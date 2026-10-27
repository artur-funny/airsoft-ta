extends StaticBody3D

@onready var marker = $ponta
@export_range(0.0, 1000, 0.0001) var air_density: float = 1.2250 #kg/m³
@export var joules: float = 1.49
@export_range(0.0, 1000, 0.0001) var mass: float = 0.0002
@export var bb_backspin: float = 6000
#const actual_radius = 0.3
const bb: PackedScene = preload("res://bb/bb2.tscn")

func _ready() -> void:
	Engine.time_scale = 0.2
func spawnprojectile():
	var projectile = bb.instantiate()
	projectile.setup(mass, joules, air_density, bb_backspin, global_transform)
	add_sibling(projectile)
	projectile.global_position = marker.global_position
	#projectile.post_setup(joules, global_transform)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("q"):
		spawnprojectile()
