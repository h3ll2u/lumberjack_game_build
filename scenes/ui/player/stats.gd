extends CanvasLayer

signal no_stamina

@onready var stamina_bar = $StaminaBar
@onready var health_bar = $HealthBar
@onready var health_regen = $HealthRegen

var max_health = 120
var old_health = max_health

var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var difference = health - old_health
		old_health = health
		

func _ready():
	health = max_health
	health_bar.max_value = health
	health_bar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_health_regen_timeout():
	health += 10
