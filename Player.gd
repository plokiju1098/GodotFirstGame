extends KinematicBody2D
var speed
var bullet_speed 
var fireball_speed 
export var life = 3
export var max_life = 3
var ready 
var reload_time 
var attack_time 
var mode  # 1- melee, 2 - bow
var ammunition 

var bat_status 
var pistol_status 
var medicine_status 
var paused 
var in_hospital 
var outside 
var inside_position
var outside_position
var hospital_0_enter
var hospital_outside
var hospital_0_stairs
var hospital_1_stairs

enum{
	MOVE,
	ATTACK,
	SHOT
}
export var state = MOVE
onready var animationPlayer = $AnimationPlayer
#onready var ammo_box = get_parent().get_node("Pickable/ammo_box")

var bullet = preload("res://Pocisk2.tscn")

#Sygnaly
signal health_changed(value)
signal ammo_changed(value)
signal bottom_alert(value)
signal snow_status(value)
signal interact_alert(value)
signal set_objective(value)
signal show_ammunition()


func _ready():
	speed = 50
	bullet_speed = 500
	fireball_speed = 200
	life = 3
	max_life = 3
	ready = 1
	reload_time = 0
	attack_time = 0
	mode=0   # 1- melee, 2 - bow
	ammunition = [0,13]
	bat_status = 0
	pistol_status = 0
	medicine_status = 0
	paused = 0
	in_hospital = 0
	outside = 0
	Global.in_house = 1
	inside_position = get_node("../Positions/InsideHouse")
	outside_position = get_node("../Positions/OutsideHouse")
	hospital_outside = get_node("../Positions/HospitalOutside")
	hospital_0_enter = get_node("../Positions/Hospital0Enter")
	hospital_0_stairs = get_node("../Positions/Hospital0Stairs")
	hospital_1_stairs = get_node("../Positions/Hospital1Stairs")
	
	$"/root/Global".add_player(self)
	
	$Flashlight.visible = 0
	position = Global.spawn_position
	
	emit_signal("ammo_changed",ammunition) #wystwietlenie amunicji
	emit_signal("set_objective","Find hospital")
	
#instancjonowanie

func _process(delta):
	
	#Smierc
	if life == 0:
		get_tree().change_scene("res://Interface/DeadScreen.tscn")
	#Tryb broni
	if Input.is_action_just_pressed("bat") and bat_status==1:
		mode = 1
		$Sprite.set_frame(12)
	if Input.is_action_just_pressed("pistol") and pistol_status==1:
		mode = 2
		$Sprite.set_frame(0)

	
	#Strzal z pistoletu delay
	reload_time -= delta
	#Udzerzenie kijem dealay
	attack_time -= delta
	#Obracanie sie
	look_at(get_global_mouse_position())

	#F-button
	if Input.is_action_just_pressed("fireball") :
		pass
	


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
		if $HospitalWalking.playing == false and in_hospital and ready:
			$HospitalWalking.play()
		if $HomeWalking.playing == false and Global.in_house and ready:
			$HomeWalking.play()
		if $OutsideWalking.playing == false and outside and ready:
			$OutsideWalking.play()
	if Input.is_action_pressed("move_down"):
		direction += Vector2(0,1)
		if $HospitalWalking.playing == false and in_hospital and ready:
			$HospitalWalking.play()
		if $HomeWalking.playing == false and Global.in_house and ready:
			$HomeWalking.play()
		if $OutsideWalking.playing == false and outside and ready:
			$OutsideWalking.play()
	if Input.is_action_pressed("move_left"):
		direction += Vector2(-1,0)
		if $HospitalWalking.playing == false and in_hospital and ready:
			$HospitalWalking.play()
		if $HomeWalking.playing == false and Global.in_house and ready:
			$HomeWalking.play()
		if $OutsideWalking.playing == false and outside and ready:
			$OutsideWalking.play()
	if Input.is_action_pressed("move_right"):
		if $HospitalWalking.playing == false and in_hospital and ready:
			$HospitalWalking.play()
		if $HomeWalking.playing == false and Global.in_house and ready:
			$HomeWalking.play()
		if $OutsideWalking.playing == false and outside and ready:
			$OutsideWalking.play()
		direction += Vector2(1,0)
	direction = direction.normalized()
	move_and_slide(direction * speed)
	
	
	
	if Input.is_action_pressed("run"):
		speed = 80
		ready = 0
		if direction.x != 0 || direction.y != 0 :
			animationPlayer.play("Run")
			if $HospitalRunning.playing == false and in_hospital:
				$HospitalRunning.play()
			if $HomeRunning.playing == false and Global.in_house:
				$HomeRunning.play()
			if $OutsideRunning.playing == false and outside:
				$OutsideRunning.play()
	if Input.is_action_just_released("run"):
		speed = 50
		ready = 1
		animationPlayer.stop()
		if mode==0:
			$Sprite.set_frame(15)
		if mode==1:
			$Sprite.set_frame(12)
		if mode==2:
			$Sprite.set_frame(0)
		
			
	if Input.is_action_just_pressed("reload") and ammunition[1]<13 and ammunition[0]>0 and ready and mode==2:
		$Reload.play()
		reload()
	if Input.is_action_pressed("fire") and reload_time < 0 and ammunition[1]>0 and ready and mode==2:
		gun_shot()
	if Input.is_action_just_pressed("fire") and mode == 1 and attack_time < 0 and ready:
		attack_time= 0.3
		$BatSwing.play()
		animationPlayer.play("Attack_Bat")
	if ammunition[1]==0:
		emit_signal("bottom_alert","press R to reload")
	
	
func attack_state(delta):
	pass
	
	
	
	
#Funkcje 
func get_pos():
	return self.position
func get_bat():
	bat_status = 1
	emit_signal("bottom_alert","press 1 to equip bat")
	yield(get_tree().create_timer(5.0), "timeout")
	emit_signal("bottom_alert","")
func get_pistol():
	pistol_status = 1
	emit_signal("show_ammunition")
	emit_signal("bottom_alert","press 2 to equip pistol")
	yield(get_tree().create_timer(5.0), "timeout")
	emit_signal("bottom_alert","")
func change_scene():
	if Global.in_house==1:
		position = outside_position.position
		Global.in_house=0
		outside = 1
		emit_signal("snow_status",1)
		$Flashlight.visible = 1
	else:
		position = inside_position.position
		Global.in_house=1
		outside = 0
		emit_signal("snow_status",0)
		$Flashlight.visible = 0
		
		
func interact_alert_on():
	emit_signal("interact_alert",1)
func interact_alert_off():
	emit_signal("interact_alert",0)	
		
func enter_hospital():
	in_hospital = 1
	outside = 0 
	position = hospital_0_enter.position
	emit_signal("snow_status",0)
	emit_signal("set_objective","Find medicine")
func leave_hospital():
	in_hospital = 0
	outside = 1
	position = hospital_outside.position
	emit_signal("snow_status",1)
func enter_second_floor():
	position = hospital_1_stairs.position
func enter_first_floor():
	position = hospital_0_stairs.position
func reload():
	ready = 0
	var magazine_left = 13-ammunition[1]
	animationPlayer.play("Reload")
	yield(get_tree().create_timer(1),"timeout")
	if ammunition[0]<magazine_left:
		ammunition[1] += ammunition[0]
		ammunition[0] = 0
	else:
		ammunition[1] +=magazine_left
		ammunition[0] -=magazine_left
		
	emit_signal("bottom_alert","")
	emit_signal("ammo_changed",ammunition)
	ready =1

func change_ammo():
	ammunition[0] +=6
	emit_signal("ammo_changed",ammunition)
func get_medicine():
	emit_signal("set_objective","Back to home")
	medicine_status = 1


func change_state_attack():
	state=ATTACK
func change_state_move():
	state=MOVE


func gun_shot():
	reload_time = 0.4
	animationPlayer.play("Shot")
	$GunShot.play()
	var bullet_instance = bullet.instance()
	bullet_instance.position = $BulletPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(rotation))
	get_tree().get_root().add_child(bullet_instance)
	ammunition[1] -=1
	emit_signal("ammo_changed",ammunition)
	

	
#                  Otrzymane obrazenia

# Od swordmana
func _on_Area2D_area_entered(area):
	if "SwordManAttack" in area.name:
		life-=1
		$PlayerHurt.play()
		emit_signal("health_changed",life)
	
