extends Node

const SERVER_PORT = 8080
const SERVER_ID = 1

var is_host = false

signal server_disconnected

func host_game():
	create_server()

func join_game():
	create_client()
	
func create_server():
	is_host = true
	var enet_network_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_network_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = enet_network_peer
	print("Server created!")
	
func create_client(host_ip: String = "localhost", host_port: int = SERVER_PORT):
	var enet_network_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_network_peer.create_client(host_ip, host_port)
	multiplayer.multiplayer_peer = enet_network_peer
	_setup_client_connection_signals()
	print("Client created!")

@rpc("any_peer","call_remote")
func _send_test_message(message: String):
	print("Message [%s] received on peer [%s], from peer [%s]." % 
		[
			message, 
			multiplayer.get_unique_id(), 
			multiplayer.get_remote_sender_id()
		]
	)

func _setup_client_connection_signals():
	if not multiplayer.server_disconnected.is_connected(_server_disconnected):
		multiplayer.server_disconnected.connect(_server_disconnected)

func _disconnect_client_connection_signals():
	if multiplayer.server_disconnected.has_connections():
		multiplayer.server_disconnected.disconnect(_server_disconnected)

func _server_disconnected():
	terminate_connection()
	_disconnect_client_connection_signals()
	emit_signal("server_disconnected")
	print("Server disconnected")

func terminate_connection():
	if multiplayer.multiplayer_peer == null:
		print("No connection to terminate")
		return
	
	if multiplayer.get_unique_id() != SERVER_ID:
		_disconnect_client_connection_signals()
	multiplayer.multiplayer_peer = null
	print("Connection terminated")
