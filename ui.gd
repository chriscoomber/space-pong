extends Control

signal play_clicked
signal countdown_finished
signal exit_game

var have_hidden_controls: bool = false
var last_game_was_won: bool = false

@export var state: State = State.HIDDEN:
	get:
		return state
	set(newstate):
		state = newstate
		
		$Middle/InfoLabel.hide()
		$Middle/PlayButton.hide()
		$Middle/PlayAgainButton.hide()
		$Attributions.hide()
		$Countdown.hide()
		$Controls.hide()
		$Options.hide()
		
		match newstate:
			State.PLAY_INITIAL:
				$Middle/InfoLabel.show()
				$Middle/InfoLabel.text = "New Game"
				$Middle/PlayButton.show()
				$Attributions.show()
				$Options.show()
			State.PLAY_RETRY:
				$Middle/InfoLabel.show()
				$Middle/InfoLabel.text = "You won!" if last_game_was_won else "You lose!"
				$Middle/PlayAgainButton.show()
				$Options.show()
			State.HIDDEN:
				pass
			State.COUNTDOWN:
				$Countdown.show()
				if (not have_hidden_controls): $Controls.show()
				$Countdown.start()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.PLAY_INITIAL
	GlobalConstants.ball_wraparound = $Options/BallWraparoundToggle.button_pressed
	GlobalConstants.wraparound = $Options/WraparoundToggle.button_pressed
	GlobalConstants.difficulty = int($Options/HBoxContainer/DifficultySlider.value)
	GlobalConstants.show_particles = $Options/ParticlesToggle.button_pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("thrust"):
		have_hidden_controls = true
		$Controls.hide()
	if get_tree().paused:
		$PauseMenu.show()
	else:
		$PauseMenu.hide()

func _on_play_button_pressed():
	emit_signal("play_clicked")
	
func _on_countdown_go():
	emit_signal("countdown_finished")

# One of:
# - PLAY_INITIAL: first started up
# - PLAY_RETRY: game over, play to retry
# - HIDDEN: no UI
enum State {PLAY_INITIAL, PLAY_RETRY, HIDDEN, COUNTDOWN}


func _on_wraparound_toggle_toggled(toggled_on):
	GlobalConstants.wraparound = toggled_on
	print('Changed wraparound: ', GlobalConstants.wraparound)

func _on_difficulty_slider_value_changed(value):
	GlobalConstants.difficulty = int(value)
	print('Changed difficulty: ', GlobalConstants.difficulty)

func _on_button_pressed():
	get_tree().paused = false
	emit_signal("exit_game")

func _on_ball_wraparound_toggle_toggled(toggled_on):
	GlobalConstants.ball_wraparound = toggled_on
	print('Changed ball wraparound: ', GlobalConstants.ball_wraparound)

func _on_particles_toggle_toggled(toggled_on):
	GlobalConstants.show_particles = toggled_on
	print('Changed show_particles: ', GlobalConstants.show_particles)
