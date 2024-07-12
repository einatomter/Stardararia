extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var hand = $Hand
@onready var item: Pickaxe = $Pickaxe

enum ENUM_ITEM_STATE {INACTIVE, ACTIVE, ACTIVE_ALT}
var item_state: ENUM_ITEM_STATE

func _ready():
	# Place tool at hand location
	item.position = hand.position

func _input(event):
	if event.is_action_pressed("left_click"):
		item.activate()
		item_state = ENUM_ITEM_STATE.ACTIVE
	elif event.is_action_pressed("right_click"):
		item.activate_alt()
		item_state = ENUM_ITEM_STATE.ACTIVE_ALT
	elif event.is_action_released("left_click") or event.is_action_released("right_click"):
		item.deactivate()
		item_state = ENUM_ITEM_STATE.INACTIVE

# Setting scale = -1 constantly flips the character, instead we keep track of state
var facing_right: bool = true

# TODO: Should not flip the whole character, could have unexpected consequences later
func flip_character(direction: int):
	'''
	Update character to face correct direction
	'''

	# Right
	if direction > 0:
		if not facing_right:
			scale.x = -scale.x
			facing_right = true
	# Left
	elif direction < 0:
		if facing_right:
			scale.x = -scale.x
			facing_right = false


func _physics_process(delta):
	# Handle item state
	if item_state == ENUM_ITEM_STATE.ACTIVE:
		item.activate()
	elif item_state == ENUM_ITEM_STATE.ACTIVE_ALT:
		item.activate_alt()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")

	# Which direction sprite faces
	flip_character(direction)

	### Play animations
	#if is_on_floor():
		#if direction == 0:
			#animated_sprite.play("idle")
		#else:
			#animated_sprite.play("run")
	#else:
		#animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

