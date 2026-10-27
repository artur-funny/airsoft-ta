extends Node3D

@export var target_scene: PackedScene = preload("res://Target/Target.tscn")
@export var bounds: Vector3 = Vector3.ONE
@export var current_targets: Array[Target]
@export var target_radius: float = 0.5
@export var target_diameter: float = 1
@export var target_scale: float = 1
@export var target_distancing: float = 1.5
@export var target_random_offset_factor: float = 0.2
@export var max_targets: int = 5
@export var typed_targets: bool = false
@export var next_target_type: WeaponType.type = WeaponType.type.None
#@export var emergency_brake: int = 0

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (current_targets.size() < max_targets):
		spawn_target()
		

func spawn_target() -> void:
	var pos := get_random_pos()
	var brake: int = 0
	while !check_empty(pos):
		brake += 1
		if(brake > 5):
			return
		#print("while")
		pos = get_random_pos()
	var t: Target = target_scene.instantiate()
	pos += get_random_offset()
	t.position = pos
	t.spawned = true
	if (typed_targets):
		var new_type = WeaponType.get_random_type()
		t.type = new_type
		#random_next_target_type()
	if (target_scale != 1):
		t.scale *= target_scale
	add_child(t)
	current_targets.push_back(t)
	
func check_empty(vec: Vector3) -> bool:
	if !current_targets.is_empty():
		for i in current_targets:
			if i.position.snappedf(target_diameter*target_distancing*target_scale) == vec:
				return false
	return true

func get_random_pos() -> Vector3:
	var rand = Vector3(randf_range(0,bounds.x),randf_range(0,bounds.y), randf_range(0,bounds.z))
	return rand.snappedf(target_diameter*target_distancing*target_scale)
	
func get_random_offset() -> Vector3:
	var v: float = target_diameter*target_random_offset_factor
	var ret: Vector3 = Vector3.ZERO
	if bounds.x != 0:
		ret.x = randf_range(-v,v)
	if (bounds.y != 0):
		ret.y = randf_range(-v,v)
	if bounds.z != 0:
		ret.z = randf_range(-v,v)
	return ret
func random_next_target_type() -> void:
	next_target_type = WeaponType.get_random_type()

func remove_target(target: Target):
	current_targets.erase(target)
