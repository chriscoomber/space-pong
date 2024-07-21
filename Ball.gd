extends CharacterBody2D

var _started: bool = false

const INITIAL_BALL_SPEED: float = 400.0
const BALL_HEIGHT: int = 0
const SCREEN_HEIGHT: int = 648

func start():
	_started = true
	position = Vector2.ZERO
	velocity = Vector2(INITIAL_BALL_SPEED, 0)

func _physics_process(delta):
	if (not _started):
		return

	# Wrap at the top and bottom
	if (position.y > SCREEN_HEIGHT/2-BALL_HEIGHT):
		position.y -= SCREEN_HEIGHT
	if (position.y < -SCREEN_HEIGHT/2+BALL_HEIGHT):
		position.y += SCREEN_HEIGHT
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		
		var speed: float = collider.speed if "speed" in collider else 0.0
		
		velocity = velocity.bounce(collision.get_normal())
		velocity = velocity + Vector2(0.0, speed * 0.75) + absf(speed) * 0.2 * normal
		
