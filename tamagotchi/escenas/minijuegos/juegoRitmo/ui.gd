extends Control
var puntaje:int=0
signal puntaje_ganador
func _ready() -> void:
	Seniales.aumentarPuntaje.connect(aumentarPuntaje)
func aumentarPuntaje(puntos:int):
	puntaje+=puntos
	$CanvasLayer/RichTextLabel.text=str(puntaje)+ " PUNTOS"
func _process(delta: float) -> void:
	pass

func _on_volver_pressed() -> void:
	var monedas_ganadas= max(0, puntaje /10)
	EstadoMascota.monedas +=monedas_ganadas
	EstadoMascota.guardarEstado()
	get_tree().change_scene_to_file("res://escenas/habitacion.tscn")
