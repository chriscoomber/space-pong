extends Node2D

signal win
signal lose

@export var autostart: bool = false

func start():
	$Player.health = 3
	$Opponent.health = 3
	$Player.start()
	$Opponent.start()
	_new_round()
	
func _new_round():
	ParallaxConstants.reference_frame_speed = 100.0
	$Ball.start()
	$Opponent.targetY = 0.0
	
func stop():
	$Player.stop()
	$Opponent.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	if (autostart): start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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

