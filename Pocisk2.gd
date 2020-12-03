extends RigidBody2D

var explosion = preload("res://World/Eksplozja.tscn")
var blood = preload("res://Krew.tscn")

func _on_RigidBody2D_body_entered(body):
	if body.is_in_group("enemy"):
		var blood_instance = blood.instance()
		blood_instance.position = get_position()
		get_tree().get_root().add_child(blood_instance)
		queue_free()
	if !body.is_in_group("player") and !body.is_in_group("enemy") and !body.is_in_group("pocisk"):
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
	
	

