extends CharacterBody2D

signal ball_collided_with_player(position: Vector2, velocity: Vector2)

@export var explode_particle: PackedScene

@export var autostart: bool = false
var _started: bool = false

const INITIAL_BALL_SPEED: float = 400.0
const BALL_HEIGHT: int = 0
const SCREEN_HEIGHT: int = 648

func _ready():
	if (autostart): 
		start()
		await get_tree().create_timer(0.5).timeout
		explode()

func start():
	_started = true
	$Sprite2D.show()
	$UpperClone.show()
	$LowerClone.show()
	position = Vector2.ZERO
	velocity = Vector2(INITIAL_BALL_SPEED, 0)
	
func explode():
	$Sprite2D.hide()
	$UpperClone.hide()
	$LowerClone.hide()
	if GlobalConstants.show_particles:
		var particle = explode_particle.instantiate()
		add_child(particle)
		particle.emitting = true
		await particle.finished
		remove_child(particle)
		particle.queue_free()

func _physics_process(delta):
	if (not _started):
		return;

	if GlobalConstants.ball_wraparound:
		# Wrap at the top and bottom
		if (position.y > SCREEN_HEIGHT/2 - BALL_HEIGHT):
			position.y -= SCREEN_HEIGHT
		if (position.y < -SCREEN_HEIGHT/2 + BALL_HEIGHT):
			position.y += SCREEN_HEIGHT
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var normal = collision.get_normal()
		var position = collision.get_position()
		var collider = collision.get_collider()
		
		var speed: float = collider.speed if "speed" in collider else 0.0
		
		velocity = velocity.bounce(normal)
		velocity = velocity + Vector2(0.0, speed * GlobalConstants.BALL_Y_GROWTH) + absf(speed) * GlobalConstants.BALL_X_GROWTH * normal
		
		print(normal, position)
		if normal.distance_squared_to(Vector2(1.0, 0.0)) < 0.01 and position.x < 76:
			print("ball hit player paddle")
			emit_signal("ball_collided_with_player", position, velocity)
