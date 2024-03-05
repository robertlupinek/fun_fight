extends Camera2D

@export var lerp_speed: float = 0.3
@export var player: Node

var last_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# _move_camera()
	pass
	
func move_camera(delta: float) -> void:
	offset = offset.lerp(player.velocity, delta * lerp_speed)
