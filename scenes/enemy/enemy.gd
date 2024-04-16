extends CharacterBody2D

enum {
	IDLE, 
	CHASE, 
	ATTACK, 
	TAKING_HIT, 
	DEATH, 
	}

@onready var animation_tree = $AnimationNode/AnimationTree
@onready var mob_health = $MobHealth
@onready var damage_timer = $DamageTimer
@onready var attack_cooldown = $AttackCooldown
@onready var enemy_sprite_2d = $AnimationNode/EnemySprite2D

var direction : Vector2
var move_speed : float = 30.0
var player : Vector2
var state = IDLE
var damage = 20
var recovery = false
var damage_cooldown = false
var attack_recover = false


func _ready():
	animation_tree.active = true
	change_state(CHASE)


func _physics_process(delta):
	player = Global.player_pos
	Global.enemy_pos = position
	
	move_and_slide()
	change_state(state)
	change_direction(direction)
	
	
func change_direction(_direction):
	direction = _direction
	if (velocity != Vector2.ZERO):
		animation_tree["parameters/Attack/blend_position"] = direction

	
	if direction.x > 0:
		$DamageBox/HitBox.rotation_degrees = 270
		enemy_sprite_2d.flip_h = true
	elif direction.x < 0:
		$DamageBox/HitBox.rotation_degrees = 90
		enemy_sprite_2d.flip_h = false
	
	if direction.y > 0 and direction.y > direction.x:
		$DamageBox/HitBox.rotation_degrees = 0
	elif direction.y < 0 and direction.y < direction.x:
		$DamageBox/HitBox.rotation_degrees = 180
	
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			idle_state()
		CHASE:
			chase_state()
		ATTACK:
			attack_state()
		TAKING_HIT:
			taking_hit_state()
		DEATH:
			death_state()
	

func idle_state():
	animation_tree["parameters/conditions/is_idle"] = true
	animation_tree["parameters/conditions/is_attack"] = false
	animation_tree["parameters/conditions/is_taking_hit"] = false
	animation_tree["parameters/conditions/is_moving"] = false
	animation_tree["parameters/conditions/is_recovery"] = false
	animation_tree["parameters/conditions/is_died"] = false
	state = CHASE


func chase_state():
	animation_tree["parameters/conditions/is_moving"] = true
	animation_tree["parameters/conditions/is_idle"] = false
	animation_tree["parameters/conditions/is_taking_hit"] = false
	animation_tree["parameters/conditions/is_attack"] = false
	direction = (player - self.position).normalized()
	velocity = direction * move_speed


func attack_state():
	if attack_recover != true:
		velocity = Vector2.ZERO
		animation_tree["parameters/conditions/is_attack"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		attack_recover = true
		attack_cooldown.start()
		#await animation_tree.animation_finished
		state = CHASE


func taking_hit_state():
	if damage_cooldown == false:
		damage_anim()
		damage_cooldown = true
		damage_timer.start()
		animation_tree["parameters/conditions/is_taking_hit"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/is_attack"] = false
		state = CHASE


func death_state():
	velocity = Vector2.ZERO
	animation_tree["parameters/conditions/is_died"] = true
	animation_tree["parameters/conditions/is_taking_hit"] = false
	animation_tree["parameters/conditions/is_moving"] = false
	animation_tree["parameters/conditions/is_idle"] = false
	velocity.x = 0
	velocity.y = 0
	state = DEATH

	
func _on_mob_health_damage_received():
	state = TAKING_HIT


func _on_mob_health_no_health():
	Global.score += 1
	state = DEATH
	await animation_tree.animation_finished
	Signals.emit_signal("enemy_died", position, state)
	queue_free()
	


func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		state = ATTACK


func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)


func damage_anim():
	velocity = Vector2.ZERO
	direction = (player - self.position).normalized()
	if direction.x < 0:
		velocity.x += 100
	elif direction.x > 0:
		velocity.x -= 100
	if direction.y < 0:
		velocity.y += 100
	elif direction.y > 0:
		velocity.y -= 100
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.5)


func _on_damage_timer_timeout():
	damage_cooldown = false


func _on_attack_cooldown_timeout():
	attack_recover = false
