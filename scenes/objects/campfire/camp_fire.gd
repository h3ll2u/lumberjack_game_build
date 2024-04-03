extends StaticBody2D

enum {
	FULL_POWER,
	HIGH_POWER,
	MID_POWER,
	LOW_POWER,
	EXTINGUISHED,
}

@onready var regen_collision = $RegenArea/RegenCollision
@onready var animated_sprite_2d = $Fire/AnimatedSprite2D

var max_fire_power = 100
var state = FULL_POWER

var fire_power:
	set(value):
		fire_power = clamp(value, 0, max_fire_power)

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_power = max_fire_power


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_state(state)


func _on_timer_timeout():
	fire_power -= 1
	print(fire_power)


func _on_player_trigger_body_entered(body):
	if body.is_in_group("player") and Global.player_take_logs:
		Global.player_take_logs = false
		fire_power += randi_range(5, 15)
		Global.score += 5
		$LogInBonFireSound.play()

func change_state(new_state):
	state = new_state
	match state:
		FULL_POWER:
			animated_sprite_2d.play("full")
			regen_collision.shape.radius = 31
		HIGH_POWER:
			animated_sprite_2d.play("high")
			regen_collision.shape.radius = 25
		MID_POWER:
			animated_sprite_2d.play("medium")
			regen_collision.shape.radius = 20
		LOW_POWER:
			animated_sprite_2d.play("small")
			regen_collision.shape.radius = 15
		EXTINGUISHED:
			animated_sprite_2d.play("extinguished")
	if fire_power >= 85:
		state = FULL_POWER
	elif fire_power >= 65:
		state = HIGH_POWER
	elif fire_power >= 45:
		state = MID_POWER
	elif fire_power >= 1:
		state = LOW_POWER
	elif fire_power <= 0:
		state = EXTINGUISHED
	
	Signals.emit_signal("campfire_state", state)
