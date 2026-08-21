extends Node
signal cambioEstado(idMascota)

var estados={}
var juegoIniciado=false
var mascotaConFoco=""
var monedas: int =0
var cosmeticsDesbloqueados: Array= []
var cosmeticoPuesto: Dictionary ={}

const rutaMonedas ="user://monedas.save"

const CATALOGO_COSMETICOS= {
	"propeller": {"textura": "res://assets/Sprites/cosmeticos/propeller.png", "precio": 50},
	"beanie": {"textura": "res://assets/Sprites/cosmeticos/Beanie.png", "precio": 30},
	"tophat": {"textura": "res://assets/Sprites/cosmeticos/TopHat.png", "precio": 80}
}

const maxPosible=100
const minPosible=0
const rutaGuardado="user://estado_mascota.save"
const segundosPeriodo=20.0
const perdidaEnergiaPeriodo=5.0
const sumaHambrePeriodo=10.0
const sumaAburrimientoPeriodo=10.0

func _ready() -> void:
	print("[DIR] user data: ", OS.get_user_data_dir())
	var monedasBackup= 0
	if FileAccess.file_exists(rutaMonedas):
		var f= FileAccess.open(rutaMonedas, FileAccess.READ)
		if f:
			var txt= f.get_as_text().strip_edges()
			f.close()
			print("[BACKUP] monedas.save contiene: '", txt, "'")
			if txt.is_valid_int():
				monedasBackup= int(txt)
	else:
		print("[BACKUP] monedas.save NO existe")
	cargarEstado()
	print("[AFTER LOAD] monedas del JSON: ", monedas)
	monedas =max(monedas, monedasBackup)
	print("[FINAL] monedas usadas: ", monedas)
	get_tree().root.close_requested.connect(_on_ventana_cerrada)

func _on_ventana_cerrada() -> void:
	guardarEstado()
	get_tree().quit()

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
	var archivo=FileAccess.open(rutaGuardado, FileAccess.READ)
	if archivo==null:
		return
	var texto= archivo.get_as_text()
	archivo.close()
	var json= JSON.new()
	if json.parse(texto) !=OK:
		guardarEstado()
		return
	var datos= json.get_data()
	if typeof(datos)!=TYPE_DICTIONARY:
		guardarEstado()
		return
	if datos.has("mascotas"):
		estados=datos.get("mascotas",{})
	else:
		estados["mascota"]={
			"energia":datos.get("energia",100),
			"hambre":datos.get("hambre",0),
			"aburrimiento":datos.get("aburrimiento",0)
		}
	monedas= int(datos.get("monedas", 0))
	cosmeticsDesbloqueados= datos.get("cosmeticsDesbloqueados", [])
	cosmeticoPuesto= datos.get("cosmeticoPuesto", {})
	aplicarTiempoCerrado(float(datos.get("ultimoGuardado",Time.get_unix_time_from_system())))
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
	var datos={
		"mascotas":estados,
		"ultimoGuardado": Time.get_unix_time_from_system(),
		"monedas": monedas,
		"cosmeticsDesbloqueados": cosmeticsDesbloqueados,
		"cosmeticoPuesto": cosmeticoPuesto
	}
	var archivo=FileAccess.open(rutaGuardado, FileAccess.WRITE)
	if archivo:
		archivo.store_string(JSON.stringify(datos))
		archivo.close()
	_escribirMonedasSimple()

func _escribirMonedasSimple() -> void:
	print("[SIMPLE WRITE] escribiendo monedas=", monedas, " en ", rutaMonedas)
	var f= FileAccess.open(rutaMonedas, FileAccess.WRITE)
	if f:
		f.store_string(str(monedas))
		f.close()
		print("[SIMPLE WRITE] OK")
	else:
		print("[SIMPLE WRITE] FALLO - error: ", FileAccess.get_open_error())

func comprarCosmetico(id: String) -> bool:
	if cosmeticsDesbloqueados.has(id):
		return false
	var precio= CATALOGO_COSMETICOS.get(id, {}).get("precio", 0)
	if monedas <precio:
		return false
	monedas -=precio
	cosmeticsDesbloqueados.append(id)
	guardarEstado()
	return true

func equiparCosmetico(idMascota: String, id: String) -> void:
	if cosmeticoPuesto.get(idMascota, "") ==id:
		cosmeticoPuesto[idMascota]= ""
	else:
		cosmeticoPuesto[idMascota]= id
	guardarEstado()
