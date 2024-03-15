extends CharacterBody2D

enum {
	IDLE, 
	MOVE, 
	ATTACK, 
	TAKING_HIT, 
	DEATH,
	}

@export var move_speed : float = 150.0
@export var accel : float = 10.0

@onready var body_tree = $AnimationsNode/BodyAnimations/BodyTree
@onready var body_sprites = $AnimationsNode/BodyAnimations/BodySprites
@onready var hand_tree = $AnimationsNode/HandAnimations/HandTree
@onready var damage_timer = $DamageTimer
@onready var stats = $Stats

var direction : Vector2
var state = IDLE
var current_damage : int
var damage_cooldown : bool = false
var enemy : Vector2
var axe_in_hand : bool
var logs


func _ready():
	current_damage = 25
	
	body_tree.active = true
	hand_tree.active = true
	
	$DamageBox/HitBox/HitBoxCollision.disabled = true
	
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	
	

func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	velocity.x = move_toward(velocity.x, move_speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, move_speed * direction.y, accel)
	
	Global.player_pos = position
	Global.player_damage = current_damage
	
	enemy = Global.enemy_pos
	
	move_and_slide()
	change_direction(direction)
	change_state(state)
	item_in_hand()

func change_direction(_direction):
	direction = _direction
	
	var last_direction : Vector2
	#var timer = get_tree().create_timer(0.3).timeout
		
	if(_direction != Vector2.ZERO):
		body_tree["parameters/Idle/blend_position"] = _direction
		body_tree["parameters/Move/blend_position"] = _direction
		last_direction = _direction
	
	if state == ATTACK:
		if velocity == Vector2.ZERO:
			last_direction = body_tree["parameters/Idle/blend_position"]
			hand_tree["parameters/AxeAttack/blend_position"] = last_direction
			
		elif velocity != Vector2.ZERO:
			last_direction = body_tree["parameters/Move/blend_position"]
			hand_tree["parameters/AxeAttack/blend_position"] = last_direction
	
	if _direction.x > 0:
		body_sprites.flip_h = true
		#await timer
		#$DamageBox/HitBox.rotation_degrees = 180
	elif _direction.x < 0:
		body_sprites.flip_h = false
		#await timer
		#$DamageBox/HitBox.rotation_degrees = 0
	

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()
		ATTACK: 
			attack_state()
		TAKING_HIT:
			taking_hit_state()
		DEATH:
			death_state()
		
	if velocity == Vector2.ZERO and state != DEATH:
		state = IDLE
	elif velocity != Vector2.ZERO and state != DEATH:
		state = MOVE
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("interact") and Global.player_take_logs != true and Global.player_in_logs_range == true:
		logs.queue_free()
		print("Test")
		Global.player_take_logs = true
	elif (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("attack")) and Global.player_take_logs:
		Global.player_take_logs = false
		Signals.logs_dropped.emit(self.position)


func idle_state():
	body_tree["parameters/conditions/is_idle"] = true
	body_tree["parameters/conditions/is_moving"] = false
	hand_tree["parameters/conditions/is_idle"] = true
	hand_tree["parameters/conditions/is_moving"] = false


func move_state():
	body_tree["parameters/conditions/is_moving"] = true
	body_tree["parameters/conditions/is_idle"] = false
	hand_tree["parameters/conditions/is_moving"] = true
	hand_tree["parameters/conditions/is_idle"] = false
	
	
func attack_state():
	hand_tree["parameters/conditions/is_attack"] = true
	move_speed /= 3
	await hand_tree.animation_finished
	move_speed = 150.0
	hand_tree["parameters/conditions/is_attack"] = false
	change_state(IDLE)


func taking_hit_state():
	damage_anim()
	body_tree["parameters/conditions/is_taking_hit"] = true
	await body_tree.animation_finished
	body_tree["parameters/conditions/is_taking_hit"] = false
	state = IDLE


func death_state():
	velocity = Vector2.ZERO
	body_tree["parameters/conditions/is_died"] = true
	#body_tree["parameters/conditions/is_taking_hit"] = false
	#hand_tree["parameters/conditions/is_moving"] = false
	#hand_tree["parameters/conditions/is_idle"] = false
	$AnimationsNode/HandAnimations.visible = false


func _on_damage_received(enemy_damage):
	if damage_cooldown == false:
		stats.health -= enemy_damage
		damage_timer.start()
		damage_cooldown = true
		if stats.health <= 0:
			stats.health = 0
			state = DEATH
	
	
func _on_hurt_box_area_entered(area):
	state = TAKING_HIT


func _on_damage_timer_timeout():
	damage_cooldown = false


func damage_anim():
	velocity = Vector2.ZERO
	var dir = (enemy - self.position).normalized()
	if dir.x < 0:
		velocity.x += 100
	elif dir.x > 0:
		velocity.x -= 100
	if dir.y < 0:
		velocity.y += 100
	elif dir.y > 0:
		velocity.y -= 100
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.5)


func item_in_hand():
	if Global.player_take_logs == true:
		axe_in_hand = false
		hand_tree["parameters/conditions/has_logs"] = true
		hand_tree["parameters/conditions/has_axe"] = false
	elif Global.player_take_logs == false:
		axe_in_hand = true
		hand_tree["parameters/conditions/has_axe"] = true
		hand_tree["parameters/conditions/has_logs"] = false


func _on_log_detector_area_entered(area):
	print("In Area")
	if area.is_in_group("logs"):
		logs = area
