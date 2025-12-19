extends Node2D
class_name Unit

@export var durability := 5
@export var attack_damage := 1
@export var attack_cool_down := 1.0
@export var vision_range := 3.0
@export var speed := 10.0
@export var rotation_speed := 1.0
@export var unit_type_altitude := UnitTypeAltitude.GROUND
@export var can_attack :Array[UnitTypeAltitude] = []
@export var cost := 100
@export var time_to_build := 10.0
@export var supply_cost := 2
@export var owning_player: PlayerManager.PlayerNumber = PlayerManager.PlayerNumber.PLAYER_ONE

@onready var animated_sprite := $AnimatedSprite2D
@onready var unit_vision := $UnitVisionArea2D
@onready var unit_vision_shape := $UnitVisionArea2D/CollisionShape2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var stats_label: Label = $StatsLabel

var current_state: ActionState = ActionState.IDLE
var next_objective_point: Vector2 = Vector2.ZERO
var current_durability := durability :
	set(value):
		current_durability = value
		if current_durability <= 0:
			current_durability = 0
			_death()
		_setup_stats_label()

signal death

enum UnitTypeAltitude { GROUND = 0, AIR = 1 }
enum ActionState { IDLE = 0, MOVE = 1, ATTACK = 2, DEATH = 3, STOP = 4 }
enum UnitType { TANK = 0 }

func _ready():
	_setup_vision_range()
	_setup_team_color()
	_setup_signals()
	_setup_stats_label()
	attack_cooldown_timer.wait_time = attack_cool_down

func _setup_stats_label():
	var stats_text = "Durability: %d / %d" % [current_durability, durability]
	print("%s %s" % [self.name, stats_text])
	# stats_label.text = stats_text
func _setup_signals():
	animated_sprite.animation_finished.connect(_handle_animation_finished)

func _setup_vision_range():
	# TODO: update vision range
	pass

func _setup_team_color():
	# TODO: setup team color via shader
	return

func _physics_process(delta):
	_handle_animation_state()
	_handle_unit_execution(delta)

func _handle_animation_state():
	match current_state:
		ActionState.IDLE:
			animated_sprite.play("idle")
		ActionState.ATTACK:
			animated_sprite.play("attack")
		ActionState.MOVE:
			animated_sprite.play("move")
		ActionState.DEATH:
			animated_sprite.play("death")
			
func _handle_unit_execution(delta):
	if current_state == ActionState.DEATH:
		return
	
	var valid_attack_targets = _search_for_valid_attack_targets()
	
	if valid_attack_targets:
		if _can_attack():
			var closest_target = _find_closest_target(valid_attack_targets)
			attack(closest_target)
		# should stand still if there are valid targets, but waiting for attack cooldown
	else:
			# TODO: Add unit logic to move towards next objective point, for now it'll move forward
			current_state = ActionState.MOVE
			position += (speed * delta) * (Vector2.UP.rotated(transform.get_rotation()))

func _can_attack() -> bool:
	return attack_cooldown_timer.is_stopped()		

func _find_closest_target(valid_targets: Array[Unit]):
	var closest_dist = INF
	var closest_target = null
	
	for target in valid_targets:
		var dist = target.global_position.distance_to(self.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_target = target
	
	return closest_target
		
func attack(defending_unit: Unit) -> void:
	# TODO: check for bonus damage against certain types
	defending_unit.current_durability -= self.attack_damage
	attack_cooldown_timer.start()
	current_state = ActionState.ATTACK

func _search_for_valid_attack_targets() -> Array[Unit]:
	var valid_targets: Array[Unit] = []
	var areas_in_vision: Array[Area2D] = unit_vision.get_overlapping_areas()
	
	for area in areas_in_vision:
		if _is_valid_attack_target(area):
			valid_targets.append(area.get_parent())
	
	return valid_targets

func _is_valid_attack_target(unit_area: Area2D) -> bool:
	var possible_unit = unit_area.get_parent()
	
	if possible_unit is Unit:
		if possible_unit.owning_player != self.owning_player \
			and (self.can_attack.has(possible_unit.unit_type_altitude)) \
			and possible_unit.is_alive(): # TODO: may have to check for teams in the future
			return true
	
	return false

func is_alive() -> bool:
	return current_state != ActionState.DEATH
	
func _handle_animation_finished():
	# This should only be called when attacking is complete, for now.
	if animated_sprite.animation == "attack":
		current_state = ActionState.IDLE

func _death():
	current_state = ActionState.DEATH
	print("%s died!" % [self.name])
	death.emit()
	
