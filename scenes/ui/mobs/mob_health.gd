extends Node2D

signal no_health
signal damage_received

@onready var health_bar = $HealthBar

@export var max_health = 100

var health : int = 100:
	set(value):
		health = value
		health_bar.value = health
		if health <= 0:
			health_bar.visible = false
		else:
			health_bar.visible = true

func _ready():
	health_bar["max_value"] = max_health
	health = max_health
	health_bar.visible = false
	
func _process(delta):
	pass

func _on_hurt_box_area_entered(area):
	await get_tree().create_timer(0.05).timeout
	health -= Global.player_damage
	if health <= 0:
		no_health.emit()
	else:
		damage_received.emit()
