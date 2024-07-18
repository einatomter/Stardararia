class_name Pickaxe

extends ItemUseable

@export var world: BuildableWorld
@export_range(0, 50) var max_range: int = 10 # blocks

@onready var animation_player: AnimationPlayer = $AnimationPickaxe
@onready var pivot_point: Marker2D = $PivotPoint

func is_within_range(input_pos: Vector2i) -> bool:
	var tool_pos_grid := world.global_to_grid(global_position)
	#print("Input position: ", input_pos)
	#print("Tool position: ", tool_pos_grid)
	var distance := int((input_pos - tool_pos_grid).length())
	#print("Range calculation: ", distance)
	return distance <= max_range

func _on_item_state_updated(new_item_state: ItemUseable.ITEM_STATE) -> void:
	match new_item_state:
		ItemUseable.ITEM_STATE.READY:
			pivot_point.rotation = 0
		ItemUseable.ITEM_STATE.STARTUP:
			pass
		ItemUseable.ITEM_STATE.ACTIVE:
			# Get mouse position relative to the world grid
			var mouse_pos_global := get_global_mouse_position()
			var mouse_pos_grid := world.global_to_grid(mouse_pos_global)
			# If within range, activate
			if is_within_range(mouse_pos_grid):
				# Assuming animation is 1 second
				var animation_speed_multiplier := speed_multiplier/time_active
				animation_player.play("mine", -1, animation_speed_multiplier)
				world.erase_block_in_world(mouse_pos_grid)
		ItemUseable.ITEM_STATE.ACTIVE_ALT:
			# Get mouse position relative to the world grid
			var mouse_pos_global := get_global_mouse_position()
			var mouse_pos_grid := world.global_to_grid(mouse_pos_global)
			# If within range, activate
			if is_within_range(mouse_pos_grid):
				world.add_block_in_world(mouse_pos_grid)
		ItemUseable.ITEM_STATE.COOLDOWN:
			pass
