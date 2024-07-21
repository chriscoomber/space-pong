extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Game.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func start_game():
	print("start")

func _on_ui_play_clicked():
	$UI.state = $UI.State.HIDDEN
	$SpaceshipAnimation.show()
	$SpaceshipAnimation.play()
	await get_tree().create_timer(3).timeout
	$UI.state = $UI.State.COUNTDOWN
	await $UI.countdown_finished
	$SpaceshipAnimation.hide()
	$Game.show()
	$Game.start()
	ParallaxConstants.reference_frame_speed = 100.0
	
