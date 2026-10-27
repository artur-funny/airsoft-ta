class_name Magazine
extends Node

@export var type: WeaponType.type
@export var max_amount: int
@export var current_amount: int
@export_range(0.0, 1000, 0.00001) var mass_kg: float

func has_ammo() -> bool:
	return current_amount > 0

func fire() -> void:
	if (current_amount > 0):
		current_amount -= 1
	
func reload() -> void:
	current_amount = max_amount
#0.002 = 2g
static func get_default_magazine() -> Magazine:
	var send = Magazine.new()
	send.type = WeaponType.type.Rifle
	send.max_amount = 15
	send.current_amount = send.max_amount
	send.mass_kg = 0.0002
	return send

func change_mag(mag: Magazine) -> void:
	type = mag.type
	max_amount = mag.max_amount
	current_amount = mag.current_amount
	mass_kg = mag.mass_kg

func change_type(new_type: WeaponType.type):
	self.type = new_type

static func from_pickup(pickup: MagazinePickup) -> Magazine:
	var mag = Magazine.new()
	mag.type = pickup.type
	mag.max_amount = pickup.max_amount
	mag.current_amount = pickup.current_amount
	mag.mass_kg = pickup.mass_kg
	return mag
