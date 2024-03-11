extends CharacterBody2D

enum {IDLE, CHASE, ATTACK, TAKING_HIT, DEATH, RECOVER}

@onready var animation_tree = $AnimationNode/AnimationTree
@onready var mob_health = $MobHealth

var direction : Vector2
var move_speed : float = 30.0
var player : Vector2
var state = IDLE
var damage = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	change_state(CHASE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_state(state)


func _physics_process(delta):
	player = Global.player_pos
	
	move_and_slide()
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			idle_state()
		CHASE:
			chase_state()
		ATTACK:
			pass
		TAKING_HIT:
			pass
		DEATH:
			pass
		RECOVER:
			pass
	

		
	

func idle_state():
	animation_tree["parameters/conditions/is_idle"] = true
	animation_tree["parameters/conditions/is_attack"] = false
	animation_tree["parameters/conditions/is_taking_hit"] = false
	animation_tree["parameters/conditions/is_moving"] = false
	animation_tree["parameters/conditions/is_recovery"] = false
	state = CHASE

func chase_state():
	animation_tree["parameters/conditions/is_moving"] = true
	animation_tree["parameters/conditions/is_idle"] = false
	#animation_tree["parameters/conditions/is_taking_hit"] = false
	direction = (player - self.position).normalized()
	velocity = direction * move_speed

#func attack_state():
	#velocity = Vector2.ZERO
	#animation_tree["parameters/conditions/is_attack"] = true
	#animation_tree["parameters/conditions/is_moving"] = false
	#state = RECOVER

#func taking_hit_state():
	#velocity = Vector2.ZERO
	#animation_tree["parameters/conditions/is_taking_hit"] = true
	#animation_tree["parameters/conditions/is_moving"] = false
	#animation_tree["parameters/conditions/is_recovery"] = false
	#animation_tree["parameters/conditions/is_attack"] = false
	#state = IDLE
	
#func death_state():
	#velocity = Vector2.ZERO
	#animation_tree["parameters/conditions/is_died"] = true
	#animation_tree["parameters/conditions/is_taking_hit"] = false

#func recovery_state():
	#velocity = Vector2.ZERO
	#animation_tree["parameters/conditions/is_recovery"] = true
	##animation_tree["parameters/conditions/is_attack"] = false
	#state = IDLE
	
#func _on_mob_health_damage_received():
	#state = TAKING_HIT
#
#
#func _on_mob_health_no_health():
	#state = DEATH
#
#
#func _on_attack_range_body_entered(body):
	#state = ATTACK


func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)
	print("cool")
