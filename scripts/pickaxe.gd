class_name Pickaxe

extends Area2D

@export var world: BuildableWorld
@export_range(0, 50) var max_range: int = 10 # blocks
@export_range(-1, 5) var speed_multiplier: float = 1
@export_range(-1, 5) var item_cooldown: float = 0.1

@onready var pivot_point: Marker2D = $PivotPoint
@onready var timer_reset_state: Timer = $TimerResetState

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation_playing: bool = false

const RAD2: float = 3.14 * 2
var rot_rad: float = -RAD2 * 4 # clockwise rotation
var item_cooldown_current: float = item_cooldown

enum ENUM_ITEM_STATE {READY, ACTIVE, ACTIVE_ALT, COOLDOWN}
var item_state: ENUM_ITEM_STATE

func equip():
	print("Pickaxe equipped!")

func unequip():
	print("Pickaxe unequipped!")

func activate() -> bool:
	if item_state != ENUM_ITEM_STATE.READY:
		return false
	#print("activate function")
	item_state = ENUM_ITEM_STATE.ACTIVE
	item_cooldown_current = item_cooldown/speed_multiplier
	animation_player.play("mine", -1, speed_multiplier)
	var mouse_pos_global := get_global_mouse_position()
	var mouse_pos_grid := world.global_to_grid(mouse_pos_global)
	if is_within_range(mouse_pos_grid):
		world.erase_block_in_world(mouse_pos_grid)
		return true

	return false


func activate_alt() -> bool:
	if item_state != ENUM_ITEM_STATE.READY:
		return false

	print("activate alt")
	#print("activate alt function")
	var mouse_pos_global := get_global_mouse_position()
	var mouse_pos_grid := world.global_to_grid(mouse_pos_global)
	if is_within_range(mouse_pos_grid):
		item_state = ENUM_ITEM_STATE.ACTIVE_ALT
		item_cooldown_current = item_cooldown/speed_multiplier # TODO: separate cooldown for ALT usage?
		world.add_block_in_world(mouse_pos_grid)
		item_state = ENUM_ITEM_STATE.COOLDOWN
		return true

	return false

# TODO: remove
func deactivate():
	return
	#item_state = ENUM_ITEM_STATE.READY
	#pivot_point.rotation = 0
	#item_cooldown_current = item_cooldown

func reset():
	pivot_point.rotation = 0
	item_state = ENUM_ITEM_STATE.READY

func is_within_range(input_pos: Vector2i) -> bool:
	var tool_pos_grid := world.global_to_grid(global_position)
	#print("Input position: ", input_pos)
	#print("Tool position: ", tool_pos_grid)
	var distance := int((input_pos - tool_pos_grid).length())
	#print("Range calculation: ", distance)
	return distance <= max_range

func _process(delta):
	if item_state == ENUM_ITEM_STATE.COOLDOWN:
		if item_cooldown_current <= 0:
			reset()
		else:
			item_cooldown_current -= delta

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "mine":
		#print("mining finished")
		# Set timer to reset state
		#timer_reset_state.start()
		item_state = ENUM_ITEM_STATE.COOLDOWN

func _on_timer_reset_state_timeout() -> void:
	# Reset pickaxe
	reset()
