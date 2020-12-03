extends KinematicBody2D
const speed = 100
const bullet_speed = 500
const fireball_speed = 200
export var life = 10
export var max_life = 10
export var mana = 10
export var max_mana = 10
var reload_time = 0
var mana_regen_time = 0
var mode=1   # 1- melee, 2 - bow
var arrows = 10
enum{
	MOVE,
	ATTACK,
	SHOT
}
export var state = MOVE
onready var animationPlayer = $AnimationPlayer
var bullet = preload("res://Pocisk2.tscn")
var fireball = preload("res://Fireball.tscn")
var healing_animation = preload("res://Healing.tscn")


#Sygnaly
signal mana_changed(value)
signal health_changed(value)
signal arrows_changed(value)

signal hpotion_changed(value)
signal mpotion_changed(value)

func _ready():
	pass
	



func _process(delta):
	#Smierc
	if life == 0:
		get_tree().reload_current_scene()	
	#Tryb broni
	if Input.is_action_just_pressed("melee"):
		mode = 1
		$Sprite.set_frame(5)
		$Sprite.set_rotation_degrees(90)
	if Input.is_action_just_pressed("bow"):
		mode = 2
		$Sprite.set_frame(0)
		$Sprite.set_rotation_degrees(130)
		
	#Mana regen
	mana_regen_time -=delta
	if mana_regen_time <0:
		mana_regen()
		mana_regen_time = 3
	
	#Strzal z luku delay
	reload_time -= delta
	#Obracanie sie
	look_at(get_global_mouse_position())

	
	#Fireball
	if Input.is_action_just_pressed("fireball") and mana>=1:
		fireball()
	#Healing
	if Input.is_action_just_pressed("healing") and mana >=5:
		healing()	
	


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		SHOT: 
			pass


# STANY #
#Chodzenie
func move_state(delta):
	
	var direction = Vector2()
	if Input.is_action_pressed("move_up"):
		direction += Vector2(0,-1)
	if Input.is_action_pressed("move_down"):
		direction += Vector2(0,1)
	if Input.is_action_pressed("move_left"):
		direction += Vector2(-1,0)
	if Input.is_action_pressed("move_right"):
		direction += Vector2(1,0)
	direction = direction.normalized()
	move_and_slide(direction * speed)
	 
	# Atak
	if Input.is_action_just_pressed("fire") and mode==1:
		animationPlayer.play("Atak")
	# Strzal z luku
	if mode==2 and Input.is_action_pressed("fire") and reload_time < 0 and arrows>0 :
		bow_shot()
	
func attack_state(delta):
	pass
	
	
	
	
#Funkcje 
func change_state_attack():
	state=ATTACK
func change_state_move():
	state=MOVE
func mana_regen():
	if mana < 10:
		mana+=0.5
		emit_signal("mana_changed",mana)
func healing():
	life +=5
	mana -=5
	emit_signal("health_changed",life)
	emit_signal("mana_changed",mana)
	var healing_instance = healing_animation.instance()
	healing_instance.position = get_position()
	get_tree().get_root().add_child(healing_instance)
func fireball():
	mana -=1
	var fireball_instance = fireball.instance()
	fireball_instance.position = $FireballPoint.get_global_position()
	fireball_instance.rotation_degrees = rotation_degrees
	fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed,0).rotated(rotation))
	get_tree().get_root().add_child(fireball_instance)
	emit_signal("mana_changed",mana)
func bow_shot():
	reload_time = 0.9
	animationPlayer.play("Strzal")
	yield(get_tree().create_timer(0.4),"timeout")
	var bullet_instance = bullet.instance()
	bullet_instance.position = $BulletPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(rotation))
	get_tree().get_root().add_child(bullet_instance)
	arrows -=1
	emit_signal("arrows_changed",arrows)
	

		
	
#                  Otrzymane obrazenia
# Z kuszy
func _on_Area2D_body_entered(body):
	if "EnemyBullet" in body.name:
		life -=1
		emit_signal("health_changed",life)
# Od swordmana


func _on_Area2D_area_entered(area):
	if "SwordManAttack" in area.name:
		life-=1
		emit_signal("health_changed",life)
	
