extends Node
signal cambioEstado

var energia=100
var hambre=0
var aburrimiento=0

const maxPosible=100
const minPosible=0
const rutaGuardado="user://estado_mascota.save"
const segundosPeriodo=20.0
const perdidaEnergiaPeriodo=5.0
const sumaHambrePeriodo=10.0
const sumaAburrimientoPeriodo=10.0

func _ready() -> void:
	cargarEstado()

func _notification(noti: int) -> void:
	if noti==NOTIFICATION_WM_CLOSE_REQUEST or noti==NOTIFICATION_EXIT_TREE:
		guardarEstado()

func cambioEnergia(delta: float) -> void:
	energia+=delta
	if energia>maxPosible:
		energia=maxPosible
	if energia<minPosible:
		energia=minPosible
	cambioEstado.emit()
	guardarEstado()
	
func cambioHambre(delta: float) -> void:
	hambre+=delta
	if hambre>maxPosible:
		hambre=maxPosible
	if hambre<minPosible:
		hambre=minPosible
	cambioEstado.emit()
	guardarEstado()
	
func cambioAburrimiento(delta: float) -> void:
	aburrimiento+=delta
	if aburrimiento>maxPosible:
		aburrimiento=maxPosible
	if aburrimiento<minPosible:
		aburrimiento=minPosible
	cambioEstado.emit()
	guardarEstado()

func cargarEstado() -> void:
	if not FileAccess.file_exists(rutaGuardado):
		guardarEstado()
		return
	var archivo=FileAccess.open(rutaGuardado,FileAccess.READ)
	if archivo==null:
		return
	var datos=archivo.get_var()
	if typeof(datos)!=TYPE_DICTIONARY:
		return
	energia=datos.get("energia",energia)
	hambre=datos.get("hambre",hambre)
	aburrimiento=datos.get("aburrimiento",aburrimiento)
	aplicarTiempoCerrado(datos.get("ultimoGuardado",Time.get_unix_time_from_system()))
	cambioEstado.emit()
	guardarEstado()

func aplicarTiempoCerrado(ultimoGuardado: float) -> void:
	var tiempoActual=Time.get_unix_time_from_system()
	var segundosCerrado=max(0.0,tiempoActual-ultimoGuardado)
	var periodos=segundosCerrado/segundosPeriodo
	energia=clamp(energia-(perdidaEnergiaPeriodo* periodos),minPosible,maxPosible)
	hambre=clamp(hambre+(sumaHambrePeriodo *periodos),minPosible,maxPosible)
	aburrimiento=clamp(aburrimiento+(sumaAburrimientoPeriodo*periodos),minPosible,maxPosible)

func guardarEstado() -> void:
	var archivo=FileAccess.open(rutaGuardado,FileAccess.WRITE)
	if archivo==null:
		return
	var datos={
		"energia": energia,
		"hambre" :hambre,
		"aburrimiento":aburrimiento,
		"ultimoGuardado" : Time.get_unix_time_from_system()
	}
	archivo.store_var(datos)
