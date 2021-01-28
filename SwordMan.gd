extends KinematicBody2D

var motion = Vector2()
var velocity = Vector2.ZERO
var speed = 40
var life = 3
var exhaust = 0
var distance_to_player
var player_position

onready var animationPlayer = $AnimationPlayer
onready var hitbox = $Alive/SwordManAttack/CollisionShape2D
onready var player = $"/root/Global".player
var blood = preload("res://Krew.tscn")


func _process(delta):
	pass
func _ready():
	player_position = player.position
	distance_to_player = abs(player_position.x - position.x) + abs(player_position.y - position.y)
	print(distance_to_player)
func _physics_process(delta):
	
	#var player = get_parent().get_pawdrent().get_node("Player")
	hitbox.disabled = 1
	exhaust -=delta
	player_position = player.position
	distance_to_player = abs(player_position.x - position.x) + abs(player_position.y - position.y)
	
	animationPlayer.play("Atak")
	
	if   distance_to_player <250 :
		if $Breath.playing == false:
			$Breath.play()
		velocity = (player_position - position).normalized() * speed
		velocity = move_and_slide(velocity)
		look_at(player_position)
		move_and_collide(motion)
	if distance_to_player < 17 and exhaust < 0:
		hitbox.disabled = 0
		exhaust = 2
		
		
		
		#Smierc
	if life <= 0:
		$Dead.visible = true
		$Alive.visible = false
		$Breath.stop()
		animationPlayer.play("Dead")
		$CollisionShape2D.set_deferred("disabled", true)
		$SwordmanBody/CollisionShape2D.set_deferred("disabled", true)
		$Alive/SwordManAttack/CollisionShape2D.set_deferred("disabled",true)
		set_process(false)
		set_physics_process(false)
		#yield(get_tree().create_timer(30),"timeout")
		#queue_free()



func _on_Area2D_body_entered(body):
	
	if "Pocisk" in body.name:
		life -=2
		$GetHit.play()
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
func _on_SwordmanBody_area_entered(area):
	if "Hitbox" in area.name:
		
		life-=1
		$GetHit.play()
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
	
