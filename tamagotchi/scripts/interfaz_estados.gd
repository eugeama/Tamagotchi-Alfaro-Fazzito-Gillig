extends Control

@onready var mascota:Node2D = get_parent()
@onready var barraHambre:ProgressBar=$VBoxContainer/hambre/ProgressBar
@onready var barraEnergia:ProgressBar=$VBoxContainer/energia/ProgressBar
@onready var barraAburrimiento:ProgressBar=$VBoxContainer/aburrimiento/ProgressBar
@onready var botonJugar:Button=$HBoxContainer/jugar
@onready var botonComer:Button=$HBoxContainer/comer
@onready var botonDormir:Button=$HBoxContainer/dormir

var idEstado=""

func _ready() -> void:
	idEstado=mascota.idEstado
	if not EstadoMascota.cambioEstado.is_connected(actualizarBarras):
		EstadoMascota.cambioEstado.connect(actualizarBarras)
	if not botonJugar.pressed.is_connected(_on_jugar_pressed):
		botonJugar.pressed.connect(_on_jugar_pressed)
	if not botonComer.pressed.is_connected(_on_comer_pressed):
		botonComer.pressed.connect(_on_comer_pressed)
	if not botonDormir.pressed.is_connected(_on_dormir_pressed):
		botonDormir.pressed.connect(_on_dormir_pressed)
	actualizarBarras()
	
	
func actualizarBarras(idMascotaCambiada: String="") -> void:
	if idMascotaCambiada!="" and idMascotaCambiada!=idEstado:
		return
	barraEnergia.value=EstadoMascota.energia(idEstado)
	barraHambre.value=EstadoMascota.hambre(idEstado)
	barraAburrimiento.value=EstadoMascota.aburrimiento(idEstado)
	
func _on_jugar_pressed() -> void:
	mascota.jugar()
func _on_comer_pressed() -> void:
	mascota.comer()
func _on_dormir_pressed() -> void:
	mascota.dormir()
