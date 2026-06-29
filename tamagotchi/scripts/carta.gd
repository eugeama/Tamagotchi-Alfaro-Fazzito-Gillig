extends Node2D

var elegido = false

func _on_touch_screen_button_pressed() -> void:
	elegido = !elegido
	$frente.visible = elegido
	$atras.visible = !elegido
	$AnimationPlayer.play("dar_vuelta")
