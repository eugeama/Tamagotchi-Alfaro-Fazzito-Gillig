extends Node2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

const perdidaEnergia=5.0
const sumaHambre=10.0
const sumaAburrimiento=10.0
func _ready() -> void:
	animacion.play("idle")
	EstadoMascota.cambioEstado.connect(actualizarAnimacion)

func _on_timer_timeout() -> void:
	EstadoMascota.cambioEnergia(-perdidaEnergia)
	EstadoMascota.cambioHambre(+sumaHambre)
	EstadoMascota.cambioAburrimiento(+sumaAburrimiento)
func actualizarAnimacion() -> void:
	#pass
	"""
	para cuando gtengamos los sprites chicoooos
	var hambre=EstadoMascota.hambre
	var energia=EstadoMascota.energia
	var aburrimiento=EstadoMascota.aburrimiento
	
	if hambre>50:
		cambiarAnimacion("hambriento")
	elif energia<50:
		cambiarAnimacion("cansado")
	elif aburrimiento>50:
		cambiarAnimacion("aburrido")
	else:
		cambiarAnimacion("idle")
		"""
func cambiarAnimacion(nombre:String)-> void:
	if animacion.current_animation!=nombre:
		animacion.play(nombre)
	
func dormir() -> void:
	EstadoMascota.cambioEnergia(+10)
	EstadoMascota.cambioHambre(+20)
func comer() -> void:
	EstadoMascota.cambioHambre(-5)
	EstadoMascota.cambioAburrimiento(+20)
func jugar() -> void:
	#aca va el juegou
	EstadoMascota.cambioAburrimiento(-5)
	EstadoMascota.cambioEnergia(-20)
