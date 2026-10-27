class_name WeaponType
extends Node
enum type {None, Shotgun, Rifle, Pistol1911, Glock}
static var enum_dict = {
	type.Shotgun : "Shotgun",
	type.Rifle : "Rifle",
	type.Pistol1911: "M1911",
	type.Glock : "Glock"
}

static var color_dict: Dictionary[WeaponType.type, Color] = {
	WeaponType.type.None : Color.WHITE,
	WeaponType.type.Shotgun : Color.DARK_RED,
	WeaponType.type.Rifle : Color.BLUE,
	WeaponType.type.Pistol1911: Color.WEB_GREEN,
	WeaponType.type.Glock : Color.YELLOW
}

static func get_random_type() -> WeaponType.type:
	var arr = type.values()
	arr.erase(type.None)
	return arr.pick_random()
