extends StaticBody2D

@onready var animated_sprite_2d = $Fire/AnimatedSprite2D

var max_fire_power = 100

var fire_power:
	set(value):
		fire_power = clamp(value, 0, max_fire_power)

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_power = max_fire_power


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_fire_power()


func _on_timer_timeout():
	fire_power -= 1
	print(fire_power)


func _on_player_trigger_body_entered(body):
	if body.is_in_group("player") and Global.player_take_logs:
		Global.player_take_logs = false
		fire_power += randi_range(5, 15)


func change_fire_power():
	if fire_power >= 85:
		animated_sprite_2d.play("full")
	elif fire_power >= 65:
		animated_sprite_2d.play("high")
	elif fire_power >= 45:
		animated_sprite_2d.play("medium")
	elif fire_power >= 1:
		animated_sprite_2d.play("small")
	elif fire_power <= 0:
		animated_sprite_2d.play("extinguished")
		
