extends Node2D

var simulation

@export var droplet_radius := 15
@export var gravitation_force := 1000.0

var positions: Array[Vector2] = []

func _ready():
	var simulationScript = preload("res://simulation.gd")
	simulation = simulationScript.new()
	
	positions = simulation.get_positions(10, 10, get_default_position())

func _draw():
	draw_debug_lines()
	for p in positions:
		draw_droplet(p)

func _process(delta):
	simulation.simulate(
		positions, 
		droplet_radius,
		get_viewport_rect().size,
		delta, 
		gravitation_force
	)
	queue_redraw()

func get_default_position() -> Vector2:
	return get_viewport_rect().size / 2

func draw_droplet(pos, color := Color(0.3, 0.75, 1)):
	draw_circle(pos, droplet_radius, color)

func draw_debug_lines():
	draw_line(
		Vector2(get_default_position().x, 0), 
		Vector2(get_default_position().x, get_viewport_rect().size.y),
		Color(1, 1, 1))
	draw_line(
		Vector2(0, get_default_position().y),
		Vector2(get_viewport_rect().size.x, get_default_position().y), 
		Color(1, 1, 1))
