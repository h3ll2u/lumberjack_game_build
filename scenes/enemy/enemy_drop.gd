extends Node2D

@export var logs_scene : PackedScene
var array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("enemy_died", Callable(self, "_on_enemy_died_position"))
	Signals.connect("logs_dropped", Callable(self, "_on_log_dropped_position"))

func _process(_delta):
	pass


func _on_enemy_died_position(enemy_position, state):
	if state != 5:
		logs_spawn(enemy_position)


func _on_log_dropped_position(player_position):
	logs_spawn(player_position)


func logs_spawn(pos):
	var count = 0
	var logs = logs_scene.instantiate()
	logs.position = pos
	call_deferred("add_child", logs)
	count = get_child_count(int())
	print(get_child_count(int()))
	if count > 4:
		var child_to_delet = get_child(0)
		child_to_delet.queue_free()
