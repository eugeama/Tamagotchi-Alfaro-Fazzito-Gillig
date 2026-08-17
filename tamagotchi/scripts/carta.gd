class_name Carta
extends Node2D

var elegido = false
var numero_pareja = -1
static var bloqueado = false

signal volteo_completado

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
	$AnimationPlayer.play("dar_vuelta")
	await $AnimationPlayer.animation_finished
	volteo_completado.emit()
	
func devolver() -> void:
	elegido = false
	$AnimationPlayer.play("devolver")
