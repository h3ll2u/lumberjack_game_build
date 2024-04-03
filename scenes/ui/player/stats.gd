extends CanvasLayer

signal no_stamina

@onready var stamina_bar = $StaminaBar
@onready var health_bar = $HealthBar
@onready var health_regen = $HealthRegen
@onready var player = $".."
@onready var score_label = $ScoreLabel
@onready var in_battle_timer = $"../InBattleTimer"
@onready var no_regen_time = $AlertNoRegen/NoRegenTime
@onready var alert_no_regen = $AlertNoRegen
@onready var health_text = $"../HealthText"
@onready var health_anim = $"../HealthAnim"

var max_health = 120
var old_health = max_health

var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var difference = health - old_health
		health_text.text = str(abs(difference))
		old_health = health
		if difference < 0:
			health_anim.play("damage_received")
		elif difference > 0:
			health_anim.play("health_received")

func _ready():
	health_text.modulate.a = 0
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
	alert_no_regen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.text = str(Global.score)
	no_regen_time.text = str(in_battle_timer.time_left).pad_decimals(1)


func _on_health_regen_timeout():
	if Global.in_regen_aura == true and player.in_battle == false:
		health += 3


func update_score(value):
	score_label.text = str(value)


func no_regen_alert_show():
	alert_no_regen.show()
	no_regen_time.text = str(in_battle_timer.wait_time)

func no_regen_alert_hide():
	alert_no_regen.hide()
