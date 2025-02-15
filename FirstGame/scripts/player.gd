extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var coyote_timer = $CoyoteTimer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
		

		
	# Handle jump, including coyote time.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")
	

	# Get the input direction - 0 idle, -1 left, 1 right.
	var direction = Input.get_axis("move_left", "move_right")
	
	
	# Flip animation.
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	
	# Play animations.
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	
	# Aplly movement.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	# Check if character is on floor.
	var was_on_floor = is_on_floor()

	move_and_slide()
	
	# Start coyote timer if character made a jump
	if was_on_floor and !is_on_floor() and !Input.is_action_pressed("jump"):
		coyote_timer.start()
