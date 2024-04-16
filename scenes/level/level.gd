extends Node2D

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

@onready var camp_fire = $CampFire
@onready var player = $Player
@onready var animation_player = $AnimationPlayer

var playing = false
var score = 0
var state = NIGHT
var day_count


func _ready():
	var rng = randi_range(2, 4)
	$Sound/Music.playing = true
	day_count = 1
	
	
func _process(delta):
	if Global.player_died or camp_fire.fire_power <= 0 or Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	change_state(state)

func change_state(new_state):
	state = new_state
	match state:
		MORNING:
			morning_state()
		DAY:
			day_state()
		EVENING:
			evening_state()
		NIGHT:
			night_state()
	
	Signals.emit_signal("day_time", state, day_count)
	
	
func morning_state():
	animation_player.play("sunshine")
	await animation_player.animation_finished
	state = DAY
	
	
func day_state():
	await get_tree().create_timer(5).timeout
	state = EVENING
	
	
func evening_state():
	animation_player.play("sunshine")
	await animation_player.animation_finished
	state = NIGHT
	
	
func night_state():
	pass
	#if $Enemies.get_child_count(int()) <= 0:
		#state = MORNING




#func _on_enemy_timer_timeout():
	#var rng = randi_range(1, 5)
	#for i in rng:
		#spawn_enemy()


#func _on_difficult_timer_timeout():
	#$EnemyTimer.wait_time -= 0.5
