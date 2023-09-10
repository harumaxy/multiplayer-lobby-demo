extends Node2D

var peer = ENetMultiplayerPeer.new()
@onready var player_scene : PackedScene = preload("res://src/basic_player.tscn")
@onready var player_list : Node = $PlayerList

const spawn_pos = Vector2(200, 200)

var my_player : Node2D = null

func _ready():
	%host.pressed.connect(_on_host_pressed)
	%join.pressed.connect(_on_join_pressed)
	%send.pressed.connect(_on_send_pressed)
	%message.text_submitted.connect(func(_message): _on_send_pressed())
	
func _on_host_pressed():
	peer.create_server(135)
	self.multiplayer.multiplayer_peer = peer
	self.multiplayer.peer_connected.connect(_add_player)
	my_player = _add_player()
	
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.position = spawn_pos + player_list.get_children().size() * Vector2(200, 0)
	(func():
		player_list.add_child(player)
		
	).call_deferred()
	
	return player
	
func _on_join_pressed():
	peer.create_client("localhost", 135)
	self.multiplayer.multiplayer_peer = peer


func _on_send_pressed():
	var my_player = player_list.get_node(str(peer.get_unique_id()))
	if my_player != null:
		my_player.speek(%message.text)
		# Clean up
		%message.clear()
		%send.disabled = true
		get_tree().create_timer(1).timeout.connect(func(): %send.disabled = false)

