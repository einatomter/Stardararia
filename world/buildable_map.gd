extends TileMap

class_name BuildableWorld

const DEBUG: bool = false

func global_to_grid(global_coord: Vector2) -> Vector2i:
	var cell_global_coord = global_coord - global_position
	return local_to_map(cell_global_coord)

func grid_to_global(block_pos: Vector2i) -> Vector2:
	return map_to_local(block_pos) + global_position

func erase_block_in_world(point: Vector2i) -> bool:
	# Only erase block if cell is not empty
	if get_cell_atlas_coords(1, point) == Vector2i(-1, -1):
		return false
	if DEBUG:
		print_debug("Removing cell at ", point)

	erase_cell(1, point)
	#var cell_array: Array[Vector2i] = [point]
	#set_cells_terrain_connect(1, cell_array, 0, -1)
	return true

func add_block_in_world(point: Vector2i) -> bool:
	# Only add block if cell is empty
	if get_cell_atlas_coords(1, point) != Vector2i(-1, -1):
		return false
	if DEBUG:
		print_debug("Adding cell at ", point)

	set_cell(1, point, 0, Vector2i(4, 1))
	#var cell_array: Array[Vector2i] = [point]
	#set_cells_terrain_connect(1, cell_array, 0, 0)
	return true
