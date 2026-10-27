class_name PlayerHud
extends Control

@onready var weapon_make: Label = $MarginContainer/HudContainer/VBoxContainer/WeaponMake
@onready var magazine_type: Label = $MarginContainer/HudContainer/VBoxContainer/MagazineType
@onready var ammo_counter: Label = $MarginContainer/HudContainer/VBoxContainer/AmmoCounter
@onready var mass: Label = $MarginContainer/HudContainer/VBoxContainer/Mass
@onready var fire_mode: Label = $MarginContainer/HudContainer/VBoxContainer/FireMode
@onready var hop_up: Label = $MarginContainer/HudContainer/VBoxContainer/HopUp
@onready var time: Label = $VBoxContainer/TimeLabel
@onready var score: Label = $VBoxContainer/ScoreLabel
@export var player: Player
var weapon = Weapon.get_instance()

static var instance: PlayerHud
static func get_instance() -> PlayerHud:
	return instance
	
func _ready() -> void:
	instance = self

func update():
	if weapon:
		update_make()
		update_mag_type()
		update_ammo()
		update_mass()
		update_mode()
		update_hopup()
		update_score()
		update_time()


func update_make():
	weapon_make.text = ("Arma: %s" % WeaponType.enum_dict[weapon.magazine_type])
	weapon_make.label_settings.font_color = WeaponType.color_dict[weapon.magazine_type]

func update_ammo():
	ammo_counter.text = ("%d / %d" % [weapon.magazine.current_amount, weapon.magazine.max_amount]) 

func update_mass():
	mass.text = ("%.3fg" % (weapon.magazine.mass_kg*1000))
	
func update_mode():
	if weapon.firing_mode == FireMode.mode.SEMI:
		fire_mode.text = "Semi"
	else:
		fire_mode.text = "Auto"

func update_hopup():
	hop_up.text = ("%.0f RPM" % weapon.hop_up)

func update_mag_type() -> void:
	magazine_type.text = ("Mag: %s" % WeaponType.enum_dict[weapon.magazine.type])
	magazine_type.label_settings.font_color = WeaponType.color_dict[weapon.magazine.type]
 
func update_score() -> void:
	var str: String = "Pontos %d" % player.score
	if (player.scored):
		str += "/%d" % player.pass_score
	score.text = (str)
	
func update_time() -> void:
	time.text = ("%.0fs" % player.time_left)
