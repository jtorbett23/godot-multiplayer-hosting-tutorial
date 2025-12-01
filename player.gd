extends CharacterBody2D


const SPEED = 300.0

func _enter_tree() -> void:
	%MultiplayerSynchronizer.set_multiplayer_authority(int(name))
	
func _ready():
	$PlayerId.text = name
	if(multiplayer.get_unique_id() != int(name)):
		set_physics_process(false)
	
func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction:
		velocity = input_direction * SPEED
	else:
		velocity = lerp(velocity, Vector2.ZERO, 1.0)
	move_and_slide()
