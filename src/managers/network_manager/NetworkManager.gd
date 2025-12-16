extends Node

const SERVER_PORT = 8080

func host_game():
	create_server()

func join_game():
	create_client()
	
func create_server():
	var enet_network_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_network_peer.create_server(SERVER_PORT)
	get_tree().get_multiplayer().multiplayer_peer = enet_network_peer
	print("Server created!")
	
func create_client(host_ip: String = "localhost", host_port: int = SERVER_PORT):
	var enet_network_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_network_peer.create_client(host_ip, host_port)
	get_tree().get_multiplayer().multiplayer_peer = enet_network_peer
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
