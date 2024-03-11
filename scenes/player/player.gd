extends CharacterBody2D

enum {IDLE, MOVE, ATTACK, TAKING_HIT, DEATH}

@export var move_speed : float = 150.0
@export var accel : float = 10.0

@onready var body_tree = $AnimationsNode/BodyAnimations/BodyTree
@onready var body_sprites = $AnimationsNode/BodyAnimations/BodySprites
@onready var hand_tree = $AnimationsNode/HandAnimations/HandTree

var direction : Vector2
var state = IDLE
var current_damage : int
var health = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	current_damage = 25
	body_tree.active = true
	hand_tree.active = true
	$DamageBox/HitBox/HitBoxCollision.disabled = true
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	print(health)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_direction(direction)
	change_state(state)
	
	Global.player_damage = current_damage

func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	velocity.x = move_toward(velocity.x, move_speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, move_speed * direction.y, accel)
	
	Global.player_pos = position
	
	move_and_slide()
	
func change_direction(_direction):
	direction = _direction
	var last_direction : Vector2
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
	elif _direction.x < 0:
		body_sprites.flip_h = false

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
		
	if velocity == Vector2.ZERO:
		state = IDLE
	elif velocity != Vector2.ZERO:
		state = MOVE
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

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
	velocity.x = 0
	velocity.y = 0
	body_tree["parameters/conditions/is_taking_hit"] = true
	await body_tree.animation_finished
	#body_tree["parameters/conditions/is_taking_hit"] = false
	#state = IDLE

func death_state():
	velocity = Vector2.ZERO
	body_tree["parameters/conditions/is_died"] = true
	#body_tree["parameters/conditions/is_taking_hit"] = false
	hand_tree["parameters/conditions/is_moving"] = false
	hand_tree["parameters/conditions/is_idle"] = false

func _on_damage_received(enemy_damage):
	health -= enemy_damage
	if health <= 0:
		health = 0
		state = DEATH
	print(health)
	


func _on_hurt_box_area_entered(area):
	state = TAKING_HIT
