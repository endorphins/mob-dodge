extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func game_over():
	show_message("Game over")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$ExitButton.show()
	$MessageLabel.text = "Try again?"
	$MessageLabel.show()

func update_score(score):
	$ScoreLabel.text = str(floor(score))

func update_runtime(runtimeMillis):
	var runtimeMillisAsInt = int(runtimeMillis)
	var hours = "%02d" % [runtimeMillisAsInt / 3600000]
	runtimeMillisAsInt = runtimeMillisAsInt % 3600000
	var minutes = "%02d" % [runtimeMillisAsInt / 60000]
	runtimeMillisAsInt = runtimeMillisAsInt % 60000
	var seconds = "%02d" % [runtimeMillisAsInt / 1000]
	var millis = "%03d" % [runtimeMillisAsInt % 1000]
	var runtimeText = str(hours) + ":" + str(minutes) + ":" + str(seconds) + "." + str(millis)
	$RuntimeLabel.text = runtimeText

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$ExitButton.hide()
	emit_signal("start_game")

func _on_ExitButton_pressed():
	get_tree().quit()
