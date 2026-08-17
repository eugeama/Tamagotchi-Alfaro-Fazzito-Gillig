extends Control
var intentos:int = 15

func _ready() -> void:
	actualizar()
	
func actualizar() -> void:
	$CanvasLayer/RichTextLabel.text= "Intentos: "+str(intentos)
	
func bajar() -> void:
	intentos-= 1
	actualizar()
	
func intentoss() -> int:
	return intentos
