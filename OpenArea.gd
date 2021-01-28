extends Area2D

onready var status = 0



func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and !status:
			$Position2D/AnimationPlayer.play("Open")
			status = 1
