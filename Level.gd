extends CanvasLayer


signal level_changed(level_name)

export (String) var level_name = "level"

var level_parameters := {
	"clicks": 0
}


func load_level_parameters(new_level_parameters: Dictionary):
	level_parameters = new_level_parameters
	$ClickLabel.text = "Clicks: " + str(level_parameters.clicks)


func play_loaded_sound() -> void:
	$LevelLoadedSound.play()
	$ChangeSceneButton.disabled = false


func cleanup():
	if $ButtonClickedSound.playing:
		yield($ButtonClickedSound, "finished")
	queue_free()


func set_clicks(new_click_amount: int):
	level_parameters.clicks = new_click_amount
	$ClickLabel.text = "Clicks: " + str(level_parameters.clicks)


func _on_ChangeSceneButton_pressed() -> void:
	$ButtonClickedSound.play()
	$ChangeSceneButton.disabled = true
	emit_signal("level_changed", level_name)


func _on_ClickButton_pressed() -> void:
	set_clicks(level_parameters.clicks + 1)
