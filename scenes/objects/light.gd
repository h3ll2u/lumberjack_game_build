extends Node2D

@onready var timer = $Timer
@onready var point_light_2d = $PointLight2D

var campfire_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("campfire_state", Callable(self, "_on_campfire_power_change"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_campfire_power_change(state):
	campfire_state = state


func _on_timer_timeout():
	var rng
	var rng_texture 
	var tween = get_tree().create_tween()
	timer.wait_time = randf_range(0.4, 0.8)
	if campfire_state == 0:
		rng = randf_range(1.5, 1.7)
		rng_texture = randf_range(0.3, 0.35)
		tween.parallel().tween_property(point_light_2d, "texture_scale", rng_texture, timer.wait_time)
		tween.parallel().tween_property(point_light_2d, "energy", rng, timer.wait_time)
	elif campfire_state == 1:
		rng = randf_range(1.2, 1.5)
		rng_texture = randf_range(0.25, 0.3)
		tween.parallel().tween_property(point_light_2d, "texture_scale", rng_texture, timer.wait_time)
		tween.parallel().tween_property(point_light_2d, "energy", rng, timer.wait_time)
	elif campfire_state == 2:
		rng = randf_range(1, 1.2)
		rng_texture = randf_range(0.2, 0.25)
		tween.parallel().tween_property(point_light_2d, "texture_scale", rng_texture, timer.wait_time)
		tween.parallel().tween_property(point_light_2d, "energy", rng, timer.wait_time)
	elif campfire_state == 3:
		rng = randf_range(0.8, 1)
		rng_texture = randf_range(0.15, 0.20)
		tween.parallel().tween_property(point_light_2d, "texture_scale", rng_texture, timer.wait_time)
		tween.parallel().tween_property(point_light_2d, "energy", rng, timer.wait_time)
	elif campfire_state == 4:
		rng = randf_range(0.5, 0.8)
		rng_texture = randf_range(0.1, 0.15)
		tween.parallel().tween_property(point_light_2d, "texture_scale", rng_texture, timer.wait_time)
		tween.parallel().tween_property(point_light_2d, "energy", rng, timer.wait_time)

