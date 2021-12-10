extends Node


var next_level = null

onready var current_level = $GrassLevel
onready var anim = $AnimationPlayer


func _ready() -> void:
	current_level.connect("level_changed", self, "handle_level_changed")
	current_level.play_loaded_sound()


func handle_level_changed(current_level_name: String):
	var next_level_name: String

	match current_level_name:
		"grass":
			next_level_name = "Desert"
		"desert":
			next_level_name = "Grass"
		_:
			return

	next_level = load("res://" + next_level_name + "Level.tscn").instance()
	next_level.layer = -1
	add_child(next_level)
	anim.play("fade_in")
	next_level.connect("level_changed", self, "handle_level_changed")
	transfer_data_between_scenes(current_level, next_level)


func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.load_level_parameters(old_scene.level_parameters)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			current_level.cleanup()
			current_level = next_level
			current_level.layer = 1
			next_level = null
			anim.play("fade_out")
		"fade_out":
			current_level.play_loaded_sound()
