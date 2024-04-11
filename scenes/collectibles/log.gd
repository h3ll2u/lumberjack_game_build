extends Area2D

@onready var trigger = $Trigger
@onready var log_light = $Light/LogLight
@onready var log_border_sprite = $LogBorderSprite

var log_pos : Vector2 = position
# Called when the node enters the scene tree for the first time.
func _ready():
	log_light.visible = false
	log_border_sprite.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	Global.player_in_logs_range = true
	log_light.visible = true
	log_border_sprite.visible = true


func _on_area_exited(area):
	Global.player_in_logs_range = false
	log_light.visible = false
	log_border_sprite.visible = false
