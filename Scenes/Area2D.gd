extends Area2D

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			body.interact_alert_on()
		if body.name == "Player" and Input.is_action_just_pressed("interact"):
			body.change_scene()
			
func _on_Area2D_body_exited(body):
	if body.name == "Player":
		body.interact_alert_off()
