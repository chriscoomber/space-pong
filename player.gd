extends AnimatableBody2D

const SCREEN_HEIGHT: int = 648

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
	if (GlobalConstants.wraparound):
		$CollisionAbove.set_deferred("disabled", false)
		$CollisionBelow.set_deferred("disabled", false)
		$SpriteAbove.show()
		$SpriteBelow.show()
		$TopWound/Above.show()
		$TopWound/Below.show()
		$MiddleWound/Above.show()
		$MiddleWound/Below.show()
		$BottomWound/Above.show()
		$BottomWound/Below.show()
	else:
		$CollisionAbove.set_deferred("disabled", true)
		$CollisionBelow.set_deferred("disabled", true)
		$SpriteAbove.hide()
		$SpriteBelow.hide()
		$TopWound/Above.hide()
		$TopWound/Below.hide()
		$MiddleWound/Above.hide()
		$MiddleWound/Below.hide()
		$BottomWound/Above.hide()
		$BottomWound/Below.hide()
		
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
	
	position.y = position.y + delta * speed
	
	if GlobalConstants.wraparound:
		# Wrap at the top and bottom
		if (position.y > SCREEN_HEIGHT/2):
			position.y -= SCREEN_HEIGHT
		if (position.y < -SCREEN_HEIGHT/2):
			position.y += SCREEN_HEIGHT
	else:
		position.y = clampf(position.y + delta * speed, -GlobalConstants.MAX_Y, GlobalConstants.MAX_Y)
