extends Node2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

const perdidaEnergiaPeriodica=5.0
const sumaHambrePeriodica=10.0
const sumaAburrimientoPeriodica=10.0
func _ready() -> void:
	animacion.play("idle")
	EstadoMascota.cambioEstado.connect(actualizarAnimacion)

func _on_timer_timeout() -> void:
	EstadoMascota.cambioEnergia(-perdidaEnergiaPeriodica)
	EstadoMascota.cambioHambre(+sumaHambrePeriodica)
	EstadoMascota.cambioAburrimiento(+sumaAburrimientoPeriodica)
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
	EstadoMascota.cambioEnergia(+50)
	EstadoMascota.cambioHambre(+10)
	EstadoMascota.cambioAburrimiento(+20)
	animacion.play("Dormir")
func comer() -> void:
	EstadoMascota.cambioHambre(-30)
	animacion.play("comer")
func jugar() -> void:
	#aca va el juegou
	EstadoMascota.cambioAburrimiento(-20)
	EstadoMascota.cambioEnergia(-10)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name!="idle":
		animacion.play("idle")
