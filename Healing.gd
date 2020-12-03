extends AnimatedSprite



func _on_Healing_animation_finished():
	queue_free()
