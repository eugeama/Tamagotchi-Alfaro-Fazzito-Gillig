extends Control

func _ready() -> void:
	get_tree().paused=false

func _on_texture_button_pressed() -> void:
	esconderMenu()
	
func esconderMenu():
	$AnimationPlayer.play("desaparecer")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().paused=true
