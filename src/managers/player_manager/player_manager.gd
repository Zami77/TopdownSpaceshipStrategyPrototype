extends Node2D
class_name PlayerManager

@onready var resource_manager: ResourceManager = $ResourceManager
@onready var resources_label := $PlayerInfo/ResourcesLabel
@onready var unit_holder: Node2D = $UnitHolder
@onready var unit_spawn_point: Node2D = $UnitSpawnPoint
@onready var unit_builder_manager: UnitBuilderManager = $UnitBuilderManager

@export var player_number: PlayerNumber = PlayerNumber.PLAYER_ONE

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
	if not resource_manager.current_resources >= unit_cost:
		print("Not enough money!")
		return
		
	resource_manager.current_resources -= unit_cost
	# TODO: add proper logic for checking unit type, for now we'll spawn a tank
	var unit_to_build = UnitFactory.get_unit(unit_type)
	# TODO: We should also respect build time here in the future
	
	unit_to_build.global_position = unit_spawn_point.global_position
	unit_holder.add_child(unit_to_build)
	# TODO: Maybe an activate call?
