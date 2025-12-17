extends Node2D
class_name ResourceManager

@export var starting_resources := 50
@export var resource_collection_rate := 10

signal resources_changed()

@export var current_resources := 0:
	get:
		return current_resources
	set(value):
		current_resources = value
		resources_changed.emit()

@onready var resource_collection_timer = $ResourceCollectionTimer

func _ready():
	resource_collection_timer.timeout.connect(_handle_resource_collection_timer_timeout)	
	current_resources = starting_resources
	resource_collection_timer.start()
	
func _handle_resource_collection_timer_timeout():
	current_resources += resource_collection_rate
	
