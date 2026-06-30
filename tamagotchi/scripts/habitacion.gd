extends Node2D

@onready var fondo:Sprite2D=$Fondo
@onready var botonPintura:TextureButton=$botonPintura

const carpetaFondos="res://assets/Sprites/Fondos"

var fondos:Array[Texture2D]=[]
var indiceFondo=0

func _ready() -> void:
	cargarFondos()
	acomodarIndiceFondoActual()
	if not botonPintura.pressed.is_connected(_on_boton_pintura_pressed):
		botonPintura.pressed.connect(_on_boton_pintura_pressed)

func cargarFondos() -> void:
	var archivos=DirAccess.get_files_at(carpetaFondos)
	archivos.sort()
	for archivo in archivos:
		if archivo.get_extension().to_lower()!="png":
			continue
		var textura=load(carpetaFondos+"/"+archivo)
		if textura is Texture2D:
			fondos.append(textura)

func acomodarIndiceFondoActual() -> void:
	if fondos.is_empty() or fondo.texture==null:
		return
	for i in range(fondos.size()):
		if fondos[i].resource_path==fondo.texture.resource_path:
			indiceFondo=i
			return

func _on_boton_pintura_pressed() -> void:
	if fondos.is_empty():
		return
	indiceFondo=(indiceFondo+ 1)%fondos.size()
	fondo.texture=fondos[indiceFondo]
