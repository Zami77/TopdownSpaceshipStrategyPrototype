extends Node2D
class_name MatchManager

@onready var tick_timer := $TickTimer
@onready var send_test_message_button: DefaultButton = $NetworkDebugVBox/SendTestMessageButton
@onready var main_menu_button: DefaultButton = $NetworkDebugVBox/MainMenuButton
@onready var unit_holder: Node2D = $UnitHolder
@onready var player_spawn_point = $PlayerSpawnPoint

var current_tick := 0.0

signal tick_complete(current_tick)
signal back_to_main_menu

func _ready():
	_setup_match()
	_start_match()

func _setup_networking():
	if NetworkManager.is_host():
		var spawn_manager: SpawnManager = ScenePaths.spawn_manager_instance.instantiate()
		add_child(spawn_manager)
		spawn_manager.player_added.connect(_on_player_manager_added)
		spawn_manager.player_manager_spawn_point = $PlayerSpawnPoint
		spawn_manager.setup_spawn_manager()
	else:
		NetworkManager.server_disconnected.connect(_on_server_disconnection)
	
	player_spawn_point.child_entered_tree.connect(_update_player_managers_visibility)
	
func _update_player_managers_visibility(_new_player_manager: PlayerManager):
	for player in player_spawn_point.get_children():
		if player is PlayerManager:
			var multiplayer_id = multiplayer.get_unique_id()
			var player_network_id = player.name.to_int()
			player.visible = player_network_id == multiplayer_id # Only the owning player should see player manager

func _setup_match():
	tick_timer.timeout.connect(_handle_tick_timer)

func _start_match():
	tick_timer.start()
	
func _handle_tick_timer():
	current_tick += tick_timer.wait_time
	emit_signal("tick_complete", current_tick)
	# print("Curent Ticks: %s" % [current_tick])

# TODO: add a func to check for duplicate players and error on it

func _on_send_test_message_button_button_up() -> void:
	NetworkManager._send_test_message.rpc("Sup")	

func _on_main_menu_button_button_up() -> void:
	emit_signal("back_to_main_menu")

func _on_server_disconnection():
	emit_signal("back_to_main_menu")

func _on_player_manager_added(player_manager: PlayerManager) -> void:
	player_manager.attempt_to_build_unit.connect(_on_attempt_to_build_unit.bind(player_manager))

func _on_attempt_to_build_unit(unit_type: Unit.UnitType, unit_cost: int, player_manager: PlayerManager):
	if not player_manager.resource_manager.current_resources >= unit_cost:
		print("Not enough money!")
		return
		
	player_manager.resource_manager.current_resources -= unit_cost
	# TODO: add proper logic for checking unit type, for now we'll spawn a tank
	var unit_to_build = UnitFactory.get_unit(unit_type)
	# TODO: We should also respect build time here in the future
	
	unit_to_build.global_position = player_manager.unit_spawn_point.global_position
	unit_to_build.owning_player = player_manager.player_number
	unit_holder.add_child(unit_to_build, true)
	# TODO: Maybe an activate call?
