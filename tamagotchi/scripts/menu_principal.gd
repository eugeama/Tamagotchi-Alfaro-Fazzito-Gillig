extends CanvasLayer


func esconderMenu():
	$AnimationPlayer.play("desaparecer")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="desaparecer":
		visible=false


func _on_boton_start_pressed() -> void:
	esconderMenu()
