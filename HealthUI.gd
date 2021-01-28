extends Control

var hearts = 3 setget set_hearts
var max_hearts = 3 setget set_max_hearts


onready var Snow = $Snow
onready var HealthBar = $HealthBar
onready var AmmoLabel = $Ammo.get_child(0)
onready var BottomAlertLabel = $BottomAlert
onready var ObjectiveLabel = $Objective
onready var player = get_parent().get_parent().get_node("YSort/Player")

func set_ammo(value):
	AmmoLabel.text = str(value[1]) + "/" + str(value[0])
	
	
func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	HealthBar.value = int(hearts)

func set_bottom_alert(value):
	BottomAlertLabel.text = str(value)
func set_objective_text(value):
	ObjectiveLabel.text = str(value)

func snow(value):
	$Snow.visible = value
	
func show_ammo():
	$Ammo.visible = 1

func interact_message(value):
	$Interact.visible = value
#settery max
func set_max_hearts(value):
	max_hearts = max(value,1)

func _ready():
	self.max_hearts = player.max_life
	self.hearts = player.life
	
	player.connect("health_changed",self,"set_hearts")
	player.connect("ammo_changed",self,"set_ammo")
	player.connect("bottom_alert",self,"set_bottom_alert")
	player.connect("snow_status",self,"snow")
	player.connect("interact_alert",self,"interact_message")
	player.connect("set_objective",self,"set_objective_text")
	player.connect("show_ammunition",self,"show_ammo")
