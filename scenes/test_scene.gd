extends Node2D

#@onready var enemy = $Enemy
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_button"):
		#print(enemy.state)
		#print("Enemy health = ", enemy.mob_health.health)
		pass
