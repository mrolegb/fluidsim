extends Resource

func get_positions(cols: int, rows: int, center: Vector2) -> Array[Vector2]:
	var cell_size = 35
	var x_offset: float = center.x - (cols * cell_size - cell_size) / 2.0
	var y_offset: float = center.y - (rows * cell_size - cell_size) / 2.0
	var pos: Array[Vector2] = []
	for r in range(rows):
		for c in range(cols):
			pos.append(
				Vector2(cell_size * c + x_offset, cell_size * r + y_offset)
			)
	return pos

func apply_gravity(
	current_pos: Vector2,
	radius: float,
	force: float, 
	delta: float, 
	viewport: Vector2
) -> Vector2:
	if current_pos.y >= viewport.y - radius * 2:
		return current_pos
	var new_position = Vector2(current_pos.x, current_pos.y + 1.0 * force * delta)
	return new_position

func simulate(
	positions: Array[Vector2],
	droplet_radius: float,
	viewport: Vector2,
	delta: float,
	gravity_force: float
):
	for i in positions.size():
		for n in positions.size():
			if n == i:
				continue
			if abs(abs(positions[i].x) - abs(positions[n].x)) <= (droplet_radius * 2 + 20):
				positions[i].x = positions[i].x + droplet_radius * gravity_force / 10 * signf(
					positions[n].x - positions[i].x
				) * delta
			if abs(abs(positions[i].y) - abs(positions[n].y)) <= (droplet_radius * 2 + 20):
				positions[i].y = positions[i].y + droplet_radius * gravity_force / 10 * signf(
					positions[i].y - positions[n].y
				) * delta
		
		# BOUNDRIES
		if positions[i].x <= 0.0:
			positions[i].x = positions[i].x + droplet_radius / 2.0 * delta
		if positions[i].x >= viewport.x:
			positions[i].x = viewport.x - droplet_radius / 2.0 * delta
			
		# GRAVITY	
		positions[i] = apply_gravity(positions[i], droplet_radius, gravity_force, delta, viewport)
