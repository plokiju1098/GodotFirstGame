extends KinematicBody2D

var motion = Vector2()
var velocity = Vector2.ZERO
var speed = 60
var life = 4

onready var animationPlayer = $AnimationPlayer

#strzelanie
const bullet_speed = 500
var reload_time = 0
var can_fire = true

var bullet = preload("res://PociskWroga.tscn")
var blood = preload("res://Krew.tscn")
func _process(delta):
	var player = get_parent().get_parent().get_node("Player")
	reload_time -= delta
	# Zmienia kierunek strzalu (celnosc)
	var look_direction = Vector2(player.position.x + (randi()%40-20) , player.position.y + (randi()%40-20) )
	
	
	if  reload_time < 0 and (abs(player.position.x - position.x) + abs(player.position.y - position.y) <300):
		reload_time = 0.9
		look_at(look_direction)
		animationPlayer.play("EnemyShot")
		yield(get_tree().create_timer(0.2),"timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPointEnemy.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		#timer
		




func _physics_process(delta):
	
	var player = get_parent().get_parent().get_node("Player")
	if  abs(player.position.x - position.x) + abs(player.position.y - position.y) <200 :
		velocity = (player.position - position).normalized() * speed
		velocity = move_and_slide(velocity)
		look_at(player.position)
		move_and_collide(motion)

#Smierc
		if life <= 0:
			$Dead.visible = true
			$Alive.visible = false
			$CollisionShape2D.set_deferred("disabled", true)
			$Area2D/CollisionShape2D.set_deferred("disabled", true)
			set_process(false)
			set_physics_process(false)
			animationPlayer.play("Dead")
			yield(get_tree().create_timer(30),"timeout")
			queue_free()

func _on_Area2D_body_entered(body):
	if "Pocisk" in body.name:
		life-=1
	if "Fireball" in body.name:
		life-=2
		
func _on_Area2D_area_entered(area):
	if "Hitbox" in area.name:
		life-=1
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
