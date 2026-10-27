class_name Target
extends Area3D

@export var type: WeaponType.type = WeaponType.type.None
@onready var model = $MeshInstance3D
@export var radius: float = 0.5
@export var spawned: bool = false

func _ready() -> void:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = WeaponType.color_dict[type]
	mat.emission_enabled = true
	mat.emission = WeaponType.color_dict[type]
	model.set_surface_override_material(0,mat)

func hit(who: BulletNew) -> void:
	if type == WeaponType.type.None || type==who.type:
		Player.get_instance().score_add(1)
		if spawned:
			get_parent().remove_target(self)
		queue_free()
