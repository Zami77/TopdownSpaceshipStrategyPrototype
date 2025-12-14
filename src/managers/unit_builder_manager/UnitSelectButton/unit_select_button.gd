extends Button
class_name UnitSelectButton

@export var unit_type: Unit.UnitType = Unit.UnitType.TANK

var cost := 10
var build_time := 10

signal attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int)

func _ready() -> void:
	_setup_icon()
	_setup_signals()

func _setup_signals():
	self.button_up.connect(_on_button_up)

func _setup_icon():
	# TODO: Implement fetching cost, build time, and others from unit scene
	pass

func _on_button_up():
	attempt_to_build_unit.emit(unit_type, cost)
