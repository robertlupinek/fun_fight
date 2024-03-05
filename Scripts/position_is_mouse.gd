extends StaticBody2D

var s_block
var s_block_bounce



# Called when the node enters the scene tree for the first time.
func _ready():
	s_block = preload("res://GameObjects/Blocks/block_test.tscn")
	s_block_bounce = preload("res://GameObjects/Blocks/bouncy_block.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("mouse_left"):
		var new_block = s_block.instantiate()
		new_block.position = get_global_mouse_position()
		owner.add_child(new_block)
		# How to quit the game :)
		# get_tree().quit()
	if Input.is_action_just_pressed("mouse_right"):
		var new_block_bounce = s_block_bounce.instantiate()
		new_block_bounce.position = get_global_mouse_position()
		#get_tree().get_root().add_child(new_block_bounce)
		owner.add_child(new_block_bounce)
