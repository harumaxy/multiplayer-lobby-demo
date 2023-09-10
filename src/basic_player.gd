extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _enter_tree():
	# call_deferred is required for setting initial spawn point at server
	(func():
		# the name going to become network peer id
		self.set_multiplayer_authority(name.to_int())
	).call_deferred()
	



func _physics_process(delta):
	if self.is_multiplayer_authority():
		# Do move
		self.velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
		self.move_and_slide()

func speek(message: String):
	if self.is_multiplayer_authority():
		%Speech.text = message
		%SpeechBubble.visible = true
		get_tree().create_timer(3).timeout.connect(func():
			%SpeechBubble.visible = false
		)

