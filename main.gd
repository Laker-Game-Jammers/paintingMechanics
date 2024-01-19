extends Node

var cur_line:Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hanle_paint_signal(initiate_paint, player_position):
	if initiate_paint:
		cur_line = Line2D.new()
		cur_line.default_color = Color(255,0,0,.25)
		cur_line.width = 20
		$World.add_child(cur_line)
		cur_line.add_point(player_position)
	else:
		cur_line.add_point(player_position)
		
