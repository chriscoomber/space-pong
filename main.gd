extends Node

var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ParallaxConstants.reference_frame_speed = 100.0
	$Game.hide()
	
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

func _on_game_lose():
	$Game.stop()
	$Game.hide()
	$UI.last_game_was_won = false
	$UI.state = $UI.State.PLAY_RETRY

func _on_game_win():
	$Game.stop()
	$Game.hide()
	$UI.last_game_was_won = true
	$UI.state = $UI.State.PLAY_RETRY

func _on_ui_exit_game():
	$Game.stop()
	$Game.hide()
	$UI.last_game_was_won = false
	$UI.state = $UI.State.PLAY_INITIAL
