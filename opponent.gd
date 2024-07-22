extends AnimatableBody2D

const PADDLE_SEPARATION = 1000
const THINKING_TIME: float = 0.15
const INACCURACY: float = 0.2

var _started: bool = false
var targetY: float = 0.0
var speed: float = 0.0
var thrust: bool = false
var thinking: bool = false

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

func start():
	_started = true
	position.y = 0.0
	
	
func stop():
	position.y = 0.0
	_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (not _started):
		return
		
	if (is_equal_approx(position.y, GlobalConstants.MAX_Y) or is_equal_approx(position.y, -GlobalConstants.MAX_Y)):
		speed = 0
		
	if not thinking:
		thinking = true
		get_tree().create_timer(randf() * THINKING_TIME).timeout.connect(func(): thinking = false)
		# Can calculate whether to thrust or not
		if speed < 0:
			# Going up. Where will I reach speed 0?
			var stationaryY = position.y - 0.5 * speed ** 2 / GlobalConstants.GRAVITY
			
			if (stationaryY < targetY):
				# Just freefall
				thrust = false
			else:
				thrust = true
				
		else:
			# Going down. Where will I reach speed 0?
			var stationaryY = position.y - 0.5 * speed ** 2 / GlobalConstants.MAX_ACCELERATION
			
			if (stationaryY < targetY):
				# Just freefall
				thrust = false
			else:
				thrust = true
			
	if thrust:
		# Accelerate up
		speed = clampf(speed + delta * GlobalConstants.MAX_ACCELERATION, -GlobalConstants.MAX_SPEED, GlobalConstants.MAX_SPEED)
	else:
		# Let gravity decellerate
		speed = clampf(speed + delta * GlobalConstants.GRAVITY, -GlobalConstants.MAX_SPEED, GlobalConstants.MAX_SPEED)
		
	position.y = clampf(position.y + delta * speed, -GlobalConstants.MAX_Y, GlobalConstants.MAX_Y)
		

func _on_ball_ball_collided_with_player(pos: Vector2, vel: Vector2):
	# Calculate where ball should end up
	targetY = pos.y + vel.y / vel.x * PADDLE_SEPARATION - 324
	targetY += randf() * INACCURACY * vel.y # some inaccuracy
	print(INACCURACY * vel.y)
	targetY = wrapf(targetY, -324, 324)
	
