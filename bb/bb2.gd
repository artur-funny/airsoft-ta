class_name BulletNew
extends Area3D

@onready var sphere: MeshInstance3D = $Node3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var timer = $Timer
#const joules: float = 1.48644864
@export_range(0.0, 1000, 0.00001) var mass_kg:float = 0.0002
@export_range(0.0, 100, 0.01) var sphere_drag_coefficient: float = 0.47 #https://en.wikipedia.org/wiki/Drag_coefficient
@export_range(0.0, 100, 0.0001) var air_density: float = 1.2250 #kg/m³
@export_range(0.0, 100, 0.0001) var radius: float = 0.003
var air_dyn_viscosity: float = 0.0000186

var velocity: Vector3 = Vector3.ZERO
var spin: Vector3 = Vector3.ZERO
var cross_section: float = PI*(radius**2)
var backspin: float = 6000 #RPM
var lift_coefficient: float = 0.2
var grav_vector_dir: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector", Vector3.DOWN)
var grav_vector_accel: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.81)
var grav_vector: Vector3 = grav_vector_dir*grav_vector_accel
var next_pos: Vector3 = Vector3.ZERO
var type: WeaponType.type = WeaponType.type.None

func setup(mass: float, joules: float, air_density: float, backspin: float, global_transform: Transform3D) -> void:
	self.global_transform = global_transform
	self.mass_kg = mass
	self.air_density = air_density
	self.backspin = backspin
	self.velocity = -global_transform.basis.z.normalized()*kinectic_to_vel(joules) #igual
	self.spin = global_basis.x.normalized()*backspin_rpm_to_rad()
	#print("arg: ",global_transform.basis)
	#print("self: ", self.global_transform.basis)
	#print("basis: ", global_basis, "\n")
	#Race condition muito legal: global_transform.basis só se iguala a global_basis quando você
	#adiciona o nó à arvore. Vou matar 13 pessoas

func set_type(new_type: WeaponType.type):
	type = new_type
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = WeaponType.color_dict[type]
	mat.emission_enabled = true
	mat.emission = WeaponType.color_dict[type]
	sphere.set_surface_override_material(0,mat)

func kinectic_to_vel(kin: float) -> float:
	return sqrt(2*kin/(mass_kg))

func backspin_rpm_to_rad() -> float:
	return backspin*(PI/30.0)
func calculate_magnus_force() -> float:
	return (0.5*air_density*spin.length()*velocity.length()*cross_section*radius)
	#return (0.5*air_density*velocity.length_squared()*cross_section*lift_coefficient)

func calculate_drag() -> float:
	return 0.5*air_density*velocity.length_squared()*cross_section*sphere_drag_coefficient

func _physics_process(delta: float) -> void:
	velocity += grav_vector*delta
	if velocity.length_squared() > 0.0001:
		velocity -= velocity.normalized()*(calculate_drag()/mass_kg)*delta
		if (spin.length() > 0.1 && spin.cross(velocity).length() > 0.1):
			var magnus_dir = spin.cross(velocity).normalized() 
			var magnus_accel = calculate_magnus_force() / mass_kg
			velocity += magnus_dir*magnus_accel*delta
			var momentum_inertia: float = 0.4*mass_kg*(radius**2)
			var torque_friction = -8*PI*air_dyn_viscosity*(radius**3)*spin
			spin += (torque_friction/momentum_inertia)*delta
	next_pos = velocity*delta
	#eu quando jank de transform me faz ter que fazer o casting de outro jeito
	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position+next_pos)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result:
		global_position = result.position
		var who = result.collider
		if who is Target:
			who.hit(self)
			on_hit()
			return
	position += next_pos

func _on_timer_timeout() -> void:
	queue_free()


func on_hit() -> void:
	queue_free()
