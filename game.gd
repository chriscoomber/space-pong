extends Node2D

signal win
signal lose

@export var autostart: bool = false
var started: bool = false

func start():
	started = true
	$Player.health = 3
	$Opponent.health = 3
	$Player.start()
	$Opponent.start()
	
	if GlobalConstants.ball_wraparound:
		$TopAndBottomCollision/Top.disabled = true
		$TopAndBottomCollision/Bottom.disabled = true
	else:
		$TopAndBottomCollision/Top.disabled = false
		$TopAndBottomCollision/Bottom.disabled = false
	
	# This isn't really the right place for this but I got lazy
	match (GlobalConstants.difficulty):
		1:
			# Faster acceleration so more time at lower top speed
			GlobalConstants.MAX_ACCELERATION = -9000.0
			GlobalConstants.GRAVITY = 9000.0
			GlobalConstants.MAX_SPEED = 500.0
			# Less speed growth
			GlobalConstants.BALL_X_GROWTH = 0.1
			GlobalConstants.BALL_Y_GROWTH = 0.5
			# Dumb AI
			GlobalConstants.THINKING_TIME = 0.2
			GlobalConstants.INACCURACY = 0.4
		2:
			GlobalConstants.MAX_ACCELERATION = -3000.0
			GlobalConstants.GRAVITY = 2000.0
			GlobalConstants.MAX_SPEED = 750.0
			GlobalConstants.BALL_X_GROWTH = 0.2
			GlobalConstants.BALL_Y_GROWTH = 0.75
			# Medium AI
			GlobalConstants.THINKING_TIME = 0.15
			GlobalConstants.INACCURACY = 0.2
		3:
			GlobalConstants.MAX_ACCELERATION = -3000.0
			GlobalConstants.GRAVITY = 2000.0
			GlobalConstants.MAX_SPEED = 750.0
			GlobalConstants.BALL_X_GROWTH = 0.2
			GlobalConstants.BALL_Y_GROWTH = 0.75
			# Smart AI
			GlobalConstants.THINKING_TIME = 0.1
			GlobalConstants.INACCURACY = 0.1

	_new_round()
	
func _new_round():
	ParallaxConstants.reference_frame_speed = 100.0
	$Ball.start()
	$Opponent.targetY = 0.0
	
func stop():
	started = false
	$Player.stop()
	$Opponent.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	if (autostart): start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause") and started:
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
	

func _physics_process(delta):
	ParallaxConstants.reference_frame_speed += delta * ParallaxConstants.REFERENCE_FRAME_ACCELERATION

func _on_you_lose_body_entered(_body):
	$Player.health -= 1
	$Ball.explode()
	await get_tree().create_timer(2).timeout
	if $Player.health == 0:
		emit_signal("lose")
	else:
		_new_round()

func _on_you_win_body_entered(_body):
	$Opponent.health -= 1
	$Ball.explode()
	await get_tree().create_timer(2).timeout
	if $Opponent.health == 0:
		emit_signal("win")
	else:
		_new_round()
