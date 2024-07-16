class_name Pickaxe

extends ItemUseable

@export var world: BuildableWorld

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot_point: Marker2D = $PivotPoint

# TODO list:
# move animation to player character

func _activate() -> bool:
	# Override item cooldown to take into account animation play time
	animation_player.current_animation = "mine"
	var animation_length:= animation_player.current_animation_length
	time_cooldown_current = (time_cooldown + animation_length)/speed_multiplier

	# Get mouse position relative to the world grid
	var mouse_pos_global := get_global_mouse_position()
	var mouse_pos_grid := world.global_to_grid(mouse_pos_global)
	# If within range, activate
	if is_within_range(mouse_pos_grid):
		animation_player.play("mine", -1, speed_multiplier)
		world.erase_block_in_world(mouse_pos_grid)
		return true

	return false

func _activate_alt() -> bool:
	# Get mouse position relative to the world grid
	var mouse_pos_global := get_global_mouse_position()
	var mouse_pos_grid := world.global_to_grid(mouse_pos_global)
	# If within range, activate
	if is_within_range(mouse_pos_grid):
		world.add_block_in_world(mouse_pos_grid)
		return true

	return false

func is_within_range(input_pos: Vector2i) -> bool:
	var tool_pos_grid := world.global_to_grid(global_position)
	#print("Input position: ", input_pos)
	#print("Tool position: ", tool_pos_grid)
	var distance := int((input_pos - tool_pos_grid).length())
	#print("Range calculation: ", distance)
	return distance <= max_range

func _reset() -> void:
	pivot_point.rotation = 0
