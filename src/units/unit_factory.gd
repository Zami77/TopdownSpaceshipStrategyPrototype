extends Node
class_name UnitFactory

static func get_unit(unit_type: Unit.UnitType) -> Unit:
	match unit_type:
		Unit.UnitType.TANK:
			return ScenePaths.unit_tank.instantiate()
		_:
			push_error("No valid unit type found")
			return null
