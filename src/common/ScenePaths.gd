class_name ScenePaths
extends Node

static var main_menu = "res://src/ui/main_menu/MainMenu.tscn"
static var credits_screen = "res://src/ui/credits_screen/CreditsScreen.tscn"
static var settings_menu = "res://src/ui/settings_menu/SettingsMenu.tscn"
static var match_manager = "res://src/managers/match_manager/MatchManager.tscn"

static var spawn_manager_instance = load("res://src/managers/spawn_manager/SpawnManager.tscn")
static var player_manager_instance = load("res://src/managers/player_manager/PlayerManager.tscn")

# Units
static var unit_tank = preload("res://src/units/Tank/Tank.tscn")
static var unit_drone = preload("res://src/units/Drone/Drone.tscn")
