extends Area2D

@onready var trigger = $Trigger

var log_pos : Vector2 = position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	Global.player_in_logs_range = true
	print("In log body")


func _on_body_exited(body):
	Global.player_in_logs_range = false
