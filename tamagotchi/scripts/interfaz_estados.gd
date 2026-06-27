extends CanvasLayer
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
	
