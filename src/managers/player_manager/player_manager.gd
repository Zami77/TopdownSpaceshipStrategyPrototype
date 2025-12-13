extends Node2D
class_name PlayerManager

@onready var resource_manager: ResourceManager = $ResourceManager
@onready var resources_label := $PlayerInfo/ResourcesLabel

# TODO: Team Color

func _ready():
	resource_manager.resources_changed.connect(_refresh_player_info)
	_refresh_player_info()
	
func _refresh_player_info():
	resources_label.text = "Resources: %s" % [resource_manager.current_resources]
