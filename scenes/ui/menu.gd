extends Node2D

@onready var check_button = $UI/CanvasLayer/CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player_take_logs = false
	Global.screen_mode = true
	Global.player_died = false
	Global.score = 0
	if Global.screen_mode == true:
		check_button.button_pressed = true
	else:
		check_button.button_pressed = false
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/level/level.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_check_button_toggled(toggled_on):
	if toggled_on == true:
		Global.screen_mode = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Global.screen_mode = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

