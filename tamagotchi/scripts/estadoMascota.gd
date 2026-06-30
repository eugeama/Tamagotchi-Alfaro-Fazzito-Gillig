extends Node
signal cambioEstado(idMascota)

var estados={}

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

func crearEstadoBase() -> Dictionary:
	return {
		"energia":100,
		"hambre":0,
		"aburrimiento":0
	}

func obtenerEstado(idMascota: String) -> Dictionary:
	if not estados.has(idMascota):
		estados[idMascota]=crearEstadoBase()
		guardarEstado()
	return estados[idMascota]

func energia(idMascota: String) -> float:
	return obtenerEstado(idMascota).get("energia",100)

func hambre(idMascota: String) -> float:
	return obtenerEstado(idMascota).get("hambre",0)

func aburrimiento(idMascota: String) -> float:
	return obtenerEstado(idMascota).get("aburrimiento",0)

func cambioEnergia(idMascota: String, delta: float) -> void:
	var estado=obtenerEstado(idMascota)
	estado["energia"]=clamp(estado.get("energia",100)+delta,minPosible,maxPosible)
	cambioEstado.emit(idMascota)
	guardarEstado()
	
func cambioHambre(idMascota: String, delta: float) -> void:
	var estado=obtenerEstado(idMascota)
	estado["hambre"]=clamp(estado.get("hambre",0)+delta,minPosible,maxPosible)
	cambioEstado.emit(idMascota)
	guardarEstado()
	
func cambioAburrimiento(idMascota: String, delta: float) -> void:
	var estado=obtenerEstado(idMascota)
	estado["aburrimiento"]=clamp(estado.get("aburrimiento",0)+delta,minPosible,maxPosible)
	cambioEstado.emit(idMascota)
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
	if datos.has("mascotas"):
		estados=datos.get("mascotas",{})
	else:
		estados["mascota"]={
			"energia":datos.get("energia",100),
			"hambre":datos.get("hambre",0),
			"aburrimiento":datos.get("aburrimiento",0)
		}
	aplicarTiempoCerrado(datos.get("ultimoGuardado",Time.get_unix_time_from_system()))
	for idMascota in estados.keys():
		cambioEstado.emit(idMascota)
	guardarEstado()

func aplicarTiempoCerrado(ultimoGuardado: float) -> void:
	var tiempoActual=Time.get_unix_time_from_system()
	var segundosCerrado=max(0.0,tiempoActual-ultimoGuardado)
	var periodos=segundosCerrado/segundosPeriodo
	for idMascota in estados.keys():
		var estado=obtenerEstado(idMascota)
		estado["energia"]=clamp(estado.get("energia",100)-(perdidaEnergiaPeriodo* periodos),minPosible,maxPosible)
		estado["hambre"]=clamp(estado.get("hambre",0)+(sumaHambrePeriodo *periodos),minPosible,maxPosible)
		estado["aburrimiento"]=clamp(estado.get("aburrimiento",0)+(sumaAburrimientoPeriodo*periodos),minPosible,maxPosible)

func guardarEstado() -> void:
	var archivo=FileAccess.open(rutaGuardado,FileAccess.WRITE)
	if archivo==null:
		return
	var datos={
		"mascotas":estados,
		"ultimoGuardado" : Time.get_unix_time_from_system()
	}
	archivo.store_var(datos)
