extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var args = Array(OS.get_cmdline_args())
	# If server
	if args.has("-s"):
		MultiplayerManager.player_spawner = $Players
		MultiplayerManager.create_server()
	# If client
	else:
		MultiplayerManager.connect_to_server()
