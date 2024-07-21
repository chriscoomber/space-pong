extends Control

signal play_clicked
signal countdown_finished

var have_hidden_controls: bool = false

@export var state: State = State.HIDDEN:
	get:
		return state
	set(newstate):
		state = newstate
		
		$PlayButton.hide()
		$PlayAgainButton.hide()
		$Attributions.hide()
		$Countdown.hide()
		$Controls.hide()
		
		match newstate:
			State.PLAY_INITIAL:
				$PlayButton.show()
				$Attributions.show()
			State.PLAY_RETRY:
				$PlayAgainButton.show()
			State.HIDDEN:
				pass
			State.COUNTDOWN:
				$Countdown.show()
				if (not have_hidden_controls): $Controls.show()
				$Countdown.start()
				
	
# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.PLAY_INITIAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("thrust"):
		have_hidden_controls = true
		$Controls.hide()


func _on_play_button_pressed():
	$PlayButton.hide()
	emit_signal("play_clicked")
	
func _on_countdown_go():
	emit_signal("countdown_finished")

# One of:
# - PLAY_INITIAL: first started up
# - PLAY_RETRY: game over, play to retry
# - HIDDEN: no UI
enum State {PLAY_INITIAL, PLAY_RETRY, HIDDEN, COUNTDOWN}

