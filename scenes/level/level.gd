extends Node2D

@export var enemy_scene : PackedScene

@onready var camp_fire = $CampFire
@onready var player = $Player

var playing = false
var score = 0


func _ready():
	var rng = randi_range(2, 4)
	for i in rng:
		spawn_enemy()
	$Sound/Music.playing = true


func _process(delta):
	if Global.player_died or camp_fire.fire_power <= 0 or Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = get_node("Path2D/PathFollow2D")
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	
	$Enemies.add_child(enemy)
	

func _on_enemy_timer_timeout():
	var rng = randi_range(1, 5)
	for i in rng:
		spawn_enemy()


func _on_difficult_timer_timeout():
	$EnemyTimer.wait_time -= 0.5
