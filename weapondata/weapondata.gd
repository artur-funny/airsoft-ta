class_name WeaponData
extends Node

@export var magazine_type: WeaponType.type
@export var model: String
@export var spring_adjust: float
@export var motor_rpm: float
@export var magazine: Magazine
@export var firing_mode: FireMode.mode
@export var hop_up: float
@export var rotations_per_fire: float

static func get_default_weapondata() -> WeaponData:
	var send = WeaponData.new()
	send.magazine_type = WeaponType.type.Rifle
	send.model = "M16"
	send.spring_adjust = 1.49
	send.motor_rpm = 30000
	send.magazine = Magazine.get_default_magazine()
	send.firing_mode = FireMode.mode.SEMI
	send.hop_up = 4500
	send.rotations_per_fire = 50
	return send

static func make_data(type: WeaponType.type, model: String, spring: float, rpm: float, 
mag: Magazine, mode: FireMode.mode, hop: float, rpf: float) -> WeaponData:
	var send = WeaponData.new()
	send.type = type
	send.model = model
	send.spring_adjust = spring
	send.rpm = rpm
	send.magazine = mag
	send.firing_mode = mode
	send.hop_up = hop
	send.rotations_per_fire = rpf
	return send
