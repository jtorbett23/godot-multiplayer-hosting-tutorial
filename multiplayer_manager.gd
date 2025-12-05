extends Node

const SERVER_ADDR = "ws://127.0.0.1:6069"

var player_spawner : Node2D
var player := preload("res://Player.tscn")

func create_server():
	print("Creating server...")
	var server: WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()
	server.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)

func connect_to_server():
	print("Connecting to server...")
	var client: WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()
	client.create_client(SERVER_ADDR)
	multiplayer.multiplayer_peer = client

func on_player_connected(id: int):
	print("Player %s joining..." % id)
	var new_player = player.instantiate()
	new_player.name = str(id)
	player_spawner.add_child(new_player, true)
	
func on_player_disconnected(id:int):
	print("Player %s leaving..." % id)
		
	if player_spawner.has_node(str(id)):
		player_spawner.get_node(str(id)).queue_free()
