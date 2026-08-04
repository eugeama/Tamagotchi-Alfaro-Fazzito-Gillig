extends Sprite2D
@export var tecla:String=""
@onready var flecha=preload("res://escenas/minijuegos/juegoRitmo/flechas.tscn")
var listaFlechas=[]
var distPerfecto:float=30
var distGenial:float=40
var distBien:float=50
var distOk: float=60

var perfectoScr:int=300
var genialScr:int=200
var bienScr:int=100
var okScr:int=50

func inicio():
	set_process(false)
func _process(delta: float) -> void:
	if !listaFlechas.is_empty():
		if listaFlechas.front().fuera:
			listaFlechas.pop_front()
		if Input.is_action_just_pressed(tecla):
			var flechaHit=listaFlechas.front()
			var distancia=abs(global_position.y-flechaHit.global_position.y)
			if distancia<distPerfecto:
				Seniales.aumentarPuntaje.emit(perfectoScr)
				listaFlechas.pop_front()
				flechaHit.queue_free()
			elif distancia<distGenial:
				Seniales.aumentarPuntaje.emit(genialScr)
				listaFlechas.pop_front()
				flechaHit.queue_free()
			elif distancia<distBien:
				Seniales.aumentarPuntaje.emit(bienScr)
				listaFlechas.pop_front()
				flechaHit.queue_free()
			elif distancia<distOk:
				Seniales.aumentarPuntaje.emit(okScr)
				listaFlechas.pop_front()
				flechaHit.queue_free()
			else:
				pass
				
func generarFlecha():
	var nuevaFlecha=flecha.instantiate()
	get_tree().get_root().call_deferred("add_child",nuevaFlecha)
	nuevaFlecha.Setup(position.x,frame+4)
	listaFlechas.push_back(nuevaFlecha)


func _on_aparicion_flechas_timeout() -> void:
	generarFlecha()
	$aparicionFlechas.wait_time=randf_range(1.5,3)
	$aparicionFlechas.start()
