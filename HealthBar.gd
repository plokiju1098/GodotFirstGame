extends Control


onready var health_bar = $Health

func on_health_updated(life,amount):
	health_bar.value = life

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
