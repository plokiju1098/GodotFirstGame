extends Area2D

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$Label.visible = 0
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$Label.visible = 1
		if body.name == "Player" and Input.is_action_just_pressed("interact"):
			body.get_bat()
			queue_free()
