extends Node
signal cambioEstado

var energia=100
var hambre=0
var aburrimiento=0

const maxPosible=100
const minPosible=0

func cambioEnergia(delta: float) -> void:
	energia+=delta
	if energia>maxPosible:
		energia=maxPosible
	if energia<minPosible:
		energia=minPosible
	cambioEstado.emit()
	
func cambioHambre(delta: float) -> void:
	hambre+=delta
	if hambre>maxPosible:
		hambre=maxPosible
	if hambre<minPosible:
		hambre=minPosible
	cambioEstado.emit()
	
func cambioAburrimiento(delta: float) -> void:
	aburrimiento+=delta
	if aburrimiento>maxPosible:
		aburrimiento
	if aburrimiento<minPosible:
		aburrimiento
	cambioEstado.emit()
func _ready() -> void:
	#para probar si funciona variable globaaal
	await get_tree().create_timer(3.0).timeout
	cambioEnergia(-20.0)
