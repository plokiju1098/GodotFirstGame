extends RigidBody2D

var explosion = preload("res://FireballExplosion.tscn")

func _on_Fireball_body_entered(body):
	if !body.is_in_group("player"):
		
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
