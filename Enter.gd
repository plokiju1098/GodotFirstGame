extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			body.interact_alert_on()
		if body.name == "Player" and Input.is_action_just_pressed("interact"):
			body.enter_hospital()
			


func _on_Enter_body_exited(body):
	if body.name == "Player":
		body.interact_alert_off()
