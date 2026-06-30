extends Control

@onready var mascota:Node2D = get_node("/root/habitacion/mascota")
@onready var barraHambre:ProgressBar=$VBoxContainer/hambre/ProgressBar
@onready var barraEnergia:ProgressBar=$VBoxContainer/energia/ProgressBar
@onready var barraAburrimiento:ProgressBar=$VBoxContainer/aburrimiento/ProgressBar

func _ready() -> void:
	EstadoMascota.cambioEstado.connect(actualizarBarras)
	actualizarBarras()
func actualizarBarras() -> void:
	barraEnergia.value=EstadoMascota.energia
	barraHambre.value=EstadoMascota.hambre
	barraAburrimiento.value=EstadoMascota.aburrimiento
	
func _on_jugar_pressed() -> void:
	mascota.jugar()
func _on_comer_pressed() -> void:
	mascota.comer()
func _on_dormir_pressed() -> void:
	mascota.dormir()
