extends Node2D
class_name PlayerManager

@onready var resource_manager: ResourceManager = $ResourceManager
@onready var resources_label := $PlayerInfo/ResourcesLabel
@onready var unit_spawn_point: Node2D = $UnitSpawnPoint
@onready var unit_builder_manager: UnitBuilderManager = $UnitBuilderManager
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

@export var player_number: PlayerNumber = PlayerNumber.PLAYER_ONE

var network_id := -1

signal attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int)

enum PlayerNumber { PLAYER_ONE = 1, PLAYER_TWO = 2 }
enum PlayerTeam { TEAM_ONE = 1, TEAM_TWO = 2 }
# TODO: Team Color

func _ready():
	resource_manager.resources_changed.connect(_refresh_player_info)
	unit_builder_manager.attempt_to_build_unit.connect(_handle_attempt_to_build_unit)
	_refresh_player_info()
		
func _refresh_player_info():
	resources_label.text = "Resources: %s" % [resource_manager.current_resources]

func _handle_attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int):
	emit_signal("attempt_to_build_unit", unit_type, unit_cost)
