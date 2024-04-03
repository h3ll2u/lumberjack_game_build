extends Node2D

#@onready var enemy = $Enemy
@onready var player = $Player
@export var enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_button"):
		#print(enemy.state)
		#print("Enemy health = ", enemy.mob_health.health)
		pass


func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = get_node("EnemyPath/SpawnPath")
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	
	$Enemies.add_child(enemy)
