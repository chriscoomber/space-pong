extends AnimatableBody2D

var speed: float = 0.0

var _started: bool = false

func start():
	_started = true
	position.y = 0.0

func _physics_process(delta):
	if (not _started):
		return
	
	if (is_equal_approx(position.y, GlobalConstants.MAX_Y) or is_equal_approx(position.y, -GlobalConstants.MAX_Y)):
		speed = 0
	
	if Input.is_action_pressed("thrust"):
		speed = clampf(speed + delta * GlobalConstants.ACCELERATION, -GlobalConstants.MAX_SPEED, GlobalConstants.MAX_SPEED)
	else:
		speed = clampf(speed + delta * -GlobalConstants.ACCELERATION, -GlobalConstants.MAX_SPEED, GlobalConstants.MAX_SPEED)
	
	position.y = clampf(position.y + delta * speed, -GlobalConstants.MAX_Y, GlobalConstants.MAX_Y)
