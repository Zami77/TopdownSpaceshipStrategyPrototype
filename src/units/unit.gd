extends Node2D
class_name Unit

@export var durability := 5
@export var attack_damage := 1
@export var attack_cool_down := 1.0
@export var vision_range := 3
@export var speed := 1.0
@export var rotation_speed := 1.0
@export var unit_type_altitude := UnitTypeAltitude.GROUND
@export var can_attack :Array[UnitTypeAltitude] = []
@export var cost := 100
@export var time_to_build := 10.0
@export var supply_cost := 2

@onready var animated_sprite := $AnimatedSprite2D
@onready var unit_vision := $UnitVisionArea2D
@onready var unit_vision_shape := $UnitVisionArea2D/CollisionShape2D

var current_state: ActionState = ActionState.IDLE

enum UnitTypeAltitude { GROUND = 0, AIR = 1 }
enum ActionState { IDLE = 0, MOVE = 1, ATTACK = 2, DEATH = 3 }

func _ready():
	_setup_vision_range()
	_setup_team_color()

func _setup_vision_range():
	# point 0 is the center of the unit
	unit_vision_shape.polygon[1] *= vision_range
	unit_vision_shape.polygon[2] *= vision_range
	
func _setup_team_color():
	# TODO: setup team color via shader
	return

func _physics_process(_delta):
	_handle_animation_state()

func _handle_animation_state():
	match current_state:
		ActionState.IDLE:
			animated_sprite.play("idle")
