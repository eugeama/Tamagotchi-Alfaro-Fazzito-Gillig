extends Sprite2D
@export var tecla:String=""
@onready var flecha=preload("res://escenas/minijuegos/juegoRitmo/flechas.tscn")
@onready var popUp=preload("res://escenas/minijuegos/juegoRitmo/scorePop.tscn")
var listaFlechas=[]
var distPerfecto:float=30
var distGenial:float=40
var distBien:float=50
var distOk: float=60

var perfectoScr:int=300
var genialScr:int=200
var bienScr:int=100
var okScr:int=50

func _ready():
	Seniales.generarFlecha.connect(generarFlecha)
func inicio():
	set_process(false)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(tecla):
		Seniales.teclaPresionada.emit(tecla, frame)
	
	if !listaFlechas.is_empty():
		if not is_instance_valid(listaFlechas.front()):
			listaFlechas.pop_front()
			return
		if listaFlechas.front().fuera:
			listaFlechas.pop_front()
			var popUpPuntaje=popUp.instantiate()
			get_tree().get_root().call_deferred("add_child", popUpPuntaje)
			popUpPuntaje.setInfoPuntaje("...")
			popUpPuntaje.global_position=global_position+Vector2(0,-20)
		if Input.is_action_just_pressed(tecla):
			var flechaHit=listaFlechas.front()
			var distancia=abs(global_position.y-flechaHit.global_position.y)
			var leyendaScore:String=" "
			if distancia<distPerfecto:
				Seniales.aumentarPuntaje.emit(perfectoScr)
				leyendaScore="PERFECTO"
				listaFlechas.pop_front()
				flechaHit.queue_free()
			elif distancia<distGenial:
				Seniales.aumentarPuntaje.emit(genialScr)
				leyendaScore="GENIAL"
				listaFlechas.pop_front()
				flechaHit.queue_free()
			elif distancia<distBien:
				Seniales.aumentarPuntaje.emit(bienScr)
				leyendaScore="BIEN"
				listaFlechas.pop_front()
				flechaHit.queue_free()
			elif distancia<distOk:
				Seniales.aumentarPuntaje.emit(okScr)
				leyendaScore="OK"
				listaFlechas.pop_front()
				flechaHit.queue_free()
			else:
				leyendaScore="..."
				
			var popUpPuntaje=popUp.instantiate()
			get_tree().get_root().call_deferred("add_child", popUpPuntaje)
			popUpPuntaje.setInfoPuntaje(leyendaScore)
			popUpPuntaje.global_position=global_position+Vector2(0,-20)
			
func generarFlecha(teclaInput:String):
	if teclaInput==tecla:
		var nuevaFlecha=flecha.instantiate()
		get_tree().get_root().call_deferred("add_child",nuevaFlecha)
		nuevaFlecha.Setup(position.x,frame+4)
		listaFlechas.push_back(nuevaFlecha)


func _on_aparicion_flechas_timeout() -> void:
	#generarFlecha()
	$aparicionFlechas.wait_time=randf_range(1.5,3)
	$aparicionFlechas.start()
