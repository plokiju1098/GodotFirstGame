extends Node

var in_house 
var spawn_position
var player

func _ready():
	in_house = 1
	spawn_position = Vector2(2476,1061)
	
func add_player(player_in):
	player = player_in
