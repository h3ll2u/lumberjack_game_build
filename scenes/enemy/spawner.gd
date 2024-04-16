extends Node2D

@export var huorn_scene : PackedScene
@export var new_state : int

@onready var mobs = $"../Enemies"
@onready var animation_player = $AnimationPlayer

var boolians : bool
var spawn_count : int
var vawe_active : bool

func _ready():
	Signals.connect("day_time", Callable(self, "_vawe_on_night_time"))


func _process(delta):
	pass


func spawn_enemy():
	var huorn = huorn_scene.instantiate()
	
	var enemy_spawn_location = get_node("Path2D/PathFollow2D")
	enemy_spawn_location.progress_ratio = randf()
	
	huorn.position = enemy_spawn_location.position
	
	mobs.add_child(huorn)


func _vawe_on_night_time(state, day_count):
	new_state = state
	spawn_count = 0
	var rng = randi_range(1, 3)
	vawe_active = true
	if state == 3:
		for spawn in 5:
			animation_player.play("spawn")
			await animation_player.animation_finished
			spawn_count += 1
			print(state)
			
	if spawn_count >= 5:
		vawe_active = false
		animation_player.play("idle")

