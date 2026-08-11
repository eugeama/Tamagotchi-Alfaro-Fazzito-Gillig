extends Control

# Valores de 'value' para que el clip caiga en el gap transparente
# despues de cada cuadrado de barraLlena.png (10 cuadrados, 2px c/u, 1px gap)
# Calculado como: (N*3+3) / 37.0 * 100  para N=1..9
const CORTE_BARRA = [0.0, 16.22, 24.32, 32.43, 40.54, 48.65, 56.76, 64.86, 72.97, 81.08, 100.0]

@onready var mascota:Node2D = get_parent()
@onready var barraHambre:TextureProgressBar=$VBoxContainer/hambre/TextureProgressBar
@onready var barraEnergia:TextureProgressBar=$VBoxContainer/energia/TextureProgressBar
@onready var barraAburrimiento:TextureProgressBar=$VBoxContainer/aburrimiento/TextureProgressBar
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
	barraEnergia.value = _valorBarra(EstadoMascota.energia(idEstado))
	barraHambre.value = _valorBarra(EstadoMascota.hambre(idEstado))
	barraAburrimiento.value = _valorBarra(EstadoMascota.aburrimiento(idEstado))

func _valorBarra(stat: float) -> float:
	var n = clamp(int(floor(stat / 10.0)), 0, 10)
	return CORTE_BARRA[n]
	
func _on_jugar_pressed() -> void:
	mascota.jugar()
func _on_comer_pressed() -> void:
	mascota.comer()
func _on_dormir_pressed() -> void:
	mascota.dormir()
