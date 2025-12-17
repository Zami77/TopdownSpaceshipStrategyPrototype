class_name SpawnManager
extends Node2D

var possible_spawn_points: Array[SpawnPoint] = []
var player_manager_spawn_point = null
var network_id_to_spawn_point := {}

signal player_added(player_added: PlayerManager)

func setup_spawn_manager() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	_fetch_spawn_points()
	
	_add_player_to_game(NetworkManager.SERVER_ID) # Host needs to add self

func _fetch_spawn_points():
	for child in get_parent().get_children():
		if child is SpawnPoint:
			possible_spawn_points.append(child)

func _on_peer_connected(network_id):
	print("Peer Connected %s"  % [network_id])
	_add_player_to_game(network_id)

func _on_peer_disconnected(network_id):
	print("Peer Disonnected %s"  % [network_id])

func _add_player_to_game(network_id):
	var player_to_add: PlayerManager = ScenePaths.player_manager_instance.instantiate()
	player_to_add.network_id = network_id
	player_to_add.name = str(network_id)
	player_to_add.set_multiplayer_authority(NetworkManager.SERVER_ID)
	
	# TODO: make spawn points random for location
	var spawn_point_pos = possible_spawn_points.pop_back()
	network_id_to_spawn_point[player_to_add.network_id] = spawn_point_pos
	player_manager_spawn_point.add_child(player_to_add, true)
	player_to_add.setup_networking()
	player_to_add.unit_spawn_point.global_position = \
		network_id_to_spawn_point[player_to_add.network_id].global_position
	emit_signal("player_added", player_to_add)
