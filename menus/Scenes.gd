class_name Scenes
extends Node

static var current_level_id: int = 0
static var levels: Array[String] = ["res://levels/level1.tscn", "res://levels/level2.tscn",
"res://levels/level3.tscn"]
static var main_menu: String = "res://menus/MainMenu.tscn"
static var level_select: String = "res://menus/LevelSelect.tscn"
static var winscreen: String = "res://menus/WinScreen.tscn"
static var losescreen: String = "res://menus/LoseScreen.tscn"

static var player_score: int = 0
static var needed_score: int = 0

static func next_level() -> String:
	current_level_id += 1
	if (current_level_id < levels.size()):
		return levels[current_level_id]
	current_level_id = 0
	return main_menu

static func current_level() -> String:
	return levels[current_level_id]

static func start_game() -> String:
	current_level_id = 0
	return current_level()
	
static func select_level(id: int) -> String:
	if(id-1 < levels.size()):
		return levels[id-1]
	return level_select
