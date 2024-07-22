extends AnimatableBody2D

var speed: float = 0.0

var health: int = 3:
	get:
		return health
	set(new_health):
		health = new_health
		if (new_health < 3):
			$TopWound.show()
		else:
			$TopWound.hide()
		if (new_health < 2): 
			$MiddleWound.show()
		else:
			$MiddleWound.hide()
		if (new_health < 1):
			$BottomWound.show()
		else:
			$BottomWound.hide()

var _started: bool = false

func start():
	print('player start')
	_started = true
	position.y = 0.0
	speed = 0.0
	
func stop():
	position.y = 0.0
	speed = 0.0
	_started = false

func _physics_process(delta):
	if (not _started):
		return
	
	if (is_equal_approx(position.y, GlobalConstants.MAX_Y) or is_equal_approx(position.y, -GlobalConstants.MAX_Y)):
		speed = 0
	
	if Input.is_action_pressed("thrust"):
		speed = clampf(speed + delta * GlobalConstants.MAX_ACCELERATION, -GlobalConstants.MAX_SPEED, GlobalConstants.MAX_SPEED)
	else:
		speed = clampf(speed + delta * GlobalConstants.GRAVITY, -GlobalConstants.MAX_SPEED, GlobalConstants.MAX_SPEED)
	
	position.y = clampf(position.y + delta * speed, -GlobalConstants.MAX_Y, GlobalConstants.MAX_Y)
