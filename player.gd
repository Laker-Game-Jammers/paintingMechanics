extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var _animated_sprite = $AnimatedSprite2D
var previously_moving_left

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal paint(initiate_paint, player_position)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
	else:
		velocity.x = 0
		
	# Handle painting
	if Input.is_action_just_pressed("paint"):
		paint.emit(true, global_position)
	
	if Input.is_action_pressed("paint"):
		paint.emit(false, global_position)		
	
	if velocity.x != 0 && velocity.y != 0:
		_animated_sprite.play("jump")
	elif velocity.y != 0 && velocity.x == 0:
		_animated_sprite.play("jump")
	elif velocity.length() > 0 && Input.is_action_pressed("crouch"):
		$CrouchingCollision2D.disabled = false
		$StandingCollision2D.disabled = true
		_animated_sprite.play("slide")
	elif velocity.length() > 0:
		$CrouchingCollision2D.disabled = true
		$StandingCollision2D.disabled = false
		_animated_sprite.play("run")
	elif Input.is_action_pressed("crouch"):
		$CrouchingCollision2D.disabled = false
		$StandingCollision2D.disabled = true
		_animated_sprite.play("crouch")
	else:
		$CrouchingCollision2D.disabled = true
		$StandingCollision2D.disabled = false
		_animated_sprite.play("idle")
	
	_animated_sprite.flip_h = velocity.x < 0 || previously_moving_left
	if velocity.x < 0:
		previously_moving_left = true
	elif velocity.x > 0:
		previously_moving_left = false


	move_and_slide()
