extends StaticBody2D





func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.change_ammo()
		queue_free()
	

