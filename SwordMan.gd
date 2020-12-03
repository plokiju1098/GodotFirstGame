extends KinematicBody2D

var motion = Vector2()
var velocity = Vector2.ZERO
var speed = 60
var life = 4
var exhaust = 0


onready var animationPlayer = $AnimationPlayer
var blood = preload("res://Krew.tscn")


func _process(delta):
	pass

func _physics_process(delta):
	

	
	exhaust -=delta
	var player = get_parent().get_parent().get_node("Player")
	var distance_to_player = abs(player.position.x - position.x) + abs(player.position.y - position.y)
	
	
	if   distance_to_player <200 :
		velocity = (player.position - position).normalized() * speed
		velocity = move_and_slide(velocity)
		look_at(player.position)
		move_and_collide(motion)
	if distance_to_player < 17 and exhaust < 0:
		exhaust = 2
		animationPlayer.play("Atak")
		
		
		#Smierc
	if life <= 0:
		$Dead.visible = true
		$Alive.visible = false
		animationPlayer.play("Dead")
		$CollisionShape2D.set_deferred("disabled", true)
		$SwordmanBody/CollisionShape2D.set_deferred("disabled", true)
		set_process(false)
		set_physics_process(false)
		yield(get_tree().create_timer(30),"timeout")
		queue_free()



func _on_Area2D_body_entered(body):
	
	if "Pocisk" in body.name:
		life -=1
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
	if  "Fireball" in body.name:
		life -=2
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
func _on_SwordmanBody_area_entered(area):
	if "Hitbox" in area.name:
		life-=1
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
	
