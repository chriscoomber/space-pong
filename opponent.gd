extends AnimatableBody2D

var _started: bool = false

func start():
	_started = true
	position.y = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (not _started):
		return
		
	position.y = %Ball.position.y

