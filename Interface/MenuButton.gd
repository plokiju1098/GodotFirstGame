extends Button

export var reference_path = ""

func _ready():
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("pressed",self,"_on_Button_pressed")

func _on_Button_pressed():
	if (reference_path != ""):
		get_tree().change_scene(reference_path)
	else:
		get_tree().quit()


func _on_Button_focus_entered():
	grab_focus()
