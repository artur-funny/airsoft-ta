class_name MagazinePickup
extends Node3D

@export var type: WeaponType.type
@export var max_amount: int
@export var current_amount: int
@export_range(0.0, 1000, 0.00001) var mass_kg: float = 0.0002
@onready var model = $MeshInstance3D

func _ready() -> void:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = WeaponType.color_dict[type]
	mat.emission_enabled = true
	mat.emission = WeaponType.color_dict[type]
	model.set_surface_override_material(0,mat)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if body.weapon is Weapon:
			body.weapon.change_mag(Magazine.from_pickup(self))
