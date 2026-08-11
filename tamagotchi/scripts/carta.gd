class_name Carta
extends Node2D

var elegido = false
static var bloqueado= false

func _on_touch_screen_button_pressed() -> void:
	if bloqueado or elegido:
		return
	
	var abiertas=0
	for c in get_parent().get_children():
		if c is Carta and c.elegido:
			abiertas += 1
	if abiertas>= 2:
		return
	
	elegido = !elegido
	$frente.visible = elegido
	$atras.visible = !elegido
	$AnimationPlayer.play("dar_vuelta")
