extends Control

signal go

func start():
	$Label.text = "3"
	$AnimationPlayer.play("fade out")
	await $AnimationPlayer.animation_finished
	$Label.text = "2"
	$AnimationPlayer.play("fade out")
	await $AnimationPlayer.animation_finished
	$Label.text = "1"
	$AnimationPlayer.play("fade out")
	await $AnimationPlayer.animation_finished
	emit_signal('go')
	$Label.text = "Go!"
	$AnimationPlayer.play("fade out")
	await $AnimationPlayer.animation_finished
	hide()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
