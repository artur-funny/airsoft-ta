class_name Bullet
extends RigidBody3D

@onready var sphere = $Node3D
const size_scale: float = 0.01
const mass_scale: float = 0.1
#const joules: float = 1.48644864
var sphere_drag_coefficient: float = 0.47 #https://en.wikipedia.org/wiki/Drag_coefficient
var air_density: float = 1.2250 #kg/m³
@export var radius: float = 0.3
var cross_section = PI*pow(radius*size_scale,2)
var backspin: float = 2
var lift_coefficient: float = 0.2

func _ready() -> void:
	mass = 0.002

func setup(mass: float, joules: float, air_density: float, rot: Vector3, backspin: float):
	self.mass = mass
	self.air_density = air_density
	linear_velocity += kinectic_to_vel(joules)*rot
	self.backspin = backspin
	print(backspin*PI)
	angular_velocity += Vector3.FORWARD*backspin*PI

func kinectic_to_vel(kin: float) -> float:
	return sqrt(2*kin/(mass*mass_scale))

func calculate_magnus_force() -> Vector3:
	var spin = calculate_spin()
	var velsquare = linear_velocity*linear_velocity
	var mforce = (calculate_spin()*0.5*air_density*velsquare*cross_section).cross(Vector3.FORWARD)
	$RayCast3D.target_position = mforce*100000
	return mforce

func calculate_spin() -> float:
	return angular_velocity.length()*radius*size_scale/linear_velocity.length()

func calculate_drag() -> Vector3:
	return -0.5*air_density*linear_velocity*linear_velocity*cross_section*sphere_drag_coefficient

func _physics_process(delta: float) -> void:
	apply_central_force(calculate_drag())
	apply_central_force(calculate_magnus_force())
	pass
	
func _on_timer_timeout() -> void:
	queue_free()
