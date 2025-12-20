extends Button
class_name UnitSelectButton

@export var unit_type: Unit.UnitType = Unit.UnitType.TANK

var cost := 10
var build_time := 10

signal attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int)

func _ready() -> void:
	_fetch_unit_data()
	_setup_signals()

func _setup_signals():
	self.button_up.connect(_on_button_up)

func _fetch_unit_data():
	var unit_build = UnitFactory.get_unit(unit_type)
	
	cost = unit_build.cost
	build_time = unit_build.time_to_build
	self.text = unit_build.unit_name
	
	# After we fetch the data, we don't need the unit anymore
	unit_build.queue_free()
	

func _on_button_up():
	attempt_to_build_unit.emit(unit_type, cost)
