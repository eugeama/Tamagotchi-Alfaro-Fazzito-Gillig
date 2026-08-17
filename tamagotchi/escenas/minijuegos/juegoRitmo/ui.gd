extends Control
var puntaje:int=0

func _ready() -> void:
	Seniales.aumentarPuntaje.connect(aumentarPuntaje)
func aumentarPuntaje(puntos:int):
	puntaje+=puntos
	$CanvasLayer/RichTextLabel.text=str(puntaje)+ " PUNTOS"
func _process(delta: float) -> void:
	pass
