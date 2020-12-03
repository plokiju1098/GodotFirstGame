extends StaticBody2D



func _ready():
	pass # Replace with function body.

signal hpotion_changed(value)
func _on_Area2D_body_entered(body):
	emit_signal("hpotion_changed")
