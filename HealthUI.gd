extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var mana = 4 setget set_hearts
var max_mana = 4 setget set_max_mana

onready var HealthLabel = $HealthAmount
onready var HealthBar = $HealthBar
onready var ArrowLabel = $ArrowLabel
onready var ManaLabel = $ManaAmount
onready var ManaBar = $ManaBar
onready var HpotionLabel =$HPotion
onready var MpotionLabel =$MPotion
onready var player = get_parent().get_parent().get_node("YSort/Player")

func set_arrows(value):
	ArrowLabel.text = "x"+ str(value)
func set_hpotion(value):
	HpotionLabel.text = str( int(HpotionLabel.text) + value)
func set_mpotion(value):
	MpotionLabel.text = str(value)
	
func set_mana(value):
	mana = clamp(value,0,max_mana)
	if ManaLabel != null:
		ManaLabel.text = str(mana) + "MP"
	ManaBar.value = int(mana)
	
	
func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	if HealthLabel != null:
		HealthLabel.text = str(hearts) + "HP"
	HealthBar.value = int(hearts)
	
#settery max
func set_max_hearts(value):
	max_hearts = max(value,1)
func set_max_mana(value):
	max_mana = max(value,1)
	
func _ready():
	self.max_hearts = player.max_life
	self.hearts = player.life
	self.mana = player.mana
	self.max_mana = player.max_mana
	player.connect("health_changed",self,"set_hearts")
	player.connect("arrows_changed",self,"set_arrows")
	player.connect("mana_changed",self,"set_mana")
	player.connect("hpotion_changed",self,"set_hpotion")
	player.connect("mpotion_changed",self,"set_mpotion")

