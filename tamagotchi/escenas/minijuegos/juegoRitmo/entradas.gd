extends Sprite2D
@export var tecla:String=""
@onready var flecha=preload("res://escenas/minijuegos/juegoRitmo/flechas.tscn")
var listaFlechas=[]
func inicio():
	set_process(false)
func _process(delta: float) -> void:
	if !listaFlechas.is_empty():
		if listaFlechas.front().fuera:
			listaFlechas.pop_front()
		if Input.is_action_just_pressed(tecla):
			var flechaHit=listaFlechas.front()
			var distancia=abs(global_position.y-flechaHit.global_position.y)
			var margen=40.0
			if distancia<=margen:
				listaFlechas.pop_front()
				Seniales.aumentarPuntaje.emit(100)
				flechaHit.queue_free()
func generarFlecha():
	var nuevaFlecha=flecha.instantiate()
	get_tree().get_root().call_deferred("add_child",nuevaFlecha)
	nuevaFlecha.Setup(position.x,frame+4)
	listaFlechas.push_back(nuevaFlecha)


func _on_aparicion_flechas_timeout() -> void:
	generarFlecha()
	$aparicionFlechas.wait_time=randf_range(1.5,3)
	$aparicionFlechas.start()
