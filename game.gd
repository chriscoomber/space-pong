extends Node2D

@export var autostart: bool = false
var player_speed: float = 0.0
var opponent_speed: float = 0.0
var ball_velocity: Vector2

func start():
	$Player.start()
	$Opponent.start()
	$Ball.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	if (autostart): start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	ParallaxConstants.reference_frame_speed += delta * ParallaxConstants.REFERENCE_FRAME_ACCELERATION

func _on_you_lose_body_entered(body):
	print('You lose')
	start()

func _on_you_win_body_entered(body):
	print('You win')
	start()
