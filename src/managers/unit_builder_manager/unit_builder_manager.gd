extends Control
class_name UnitBuilderManager

@onready var unit_options: HBoxContainer = $UnitOptions

signal attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int)

func _ready() -> void:
	_setup_unit_select_buttons()

func _setup_unit_select_buttons():
	for unit_select_button in unit_options.get_children():
		if unit_select_button is UnitSelectButton:
			unit_select_button.attempt_to_build_unit.connect(_handle_attempt_to_build_unit)
			
func _handle_attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int):
	emit_signal("attempt_to_build_unit", unit_type, unit_cost)
	
