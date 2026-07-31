extends Sprite2D
@export var velocidadCaida:float=3.0
@export var posicionInicialY:float=-360.0
func _process(delta: float) -> void:
	global_position+=Vector2(0,velocidadCaida)
	if global_position.y>200.0 and not $Timer.is_stopped():
		print($Timer.wait_time-$Timer.time_left)
		$Timer.stop()
	#para saber cuanto tiempo le toma a la flecha caer hasta la teclaa
func Setup(objetivoX:float, targetFrame:int):
	global_position=Vector2(objetivoX,posicionInicialY)
	frame=targetFrame
	set_process(true)


func _on_eliminar_timer_timeout() -> void:
	queue_free()
