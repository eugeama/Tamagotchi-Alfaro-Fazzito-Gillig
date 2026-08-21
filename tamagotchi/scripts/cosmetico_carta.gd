extends Control

signal carta_presionada(id: String)

const texMoneda= preload("res://assets/Sprites/moneda.png")

@onready var boton: TextureButton =$Boton
@onready var overlay: ColorRect =$Overlay
@onready var filaPrecio: HBoxContainer =$Overlay/FilaPrecio
@onready var etiquetaPrecio: Label =$Overlay/FilaPrecio/Precio
@onready var iconoMoneda: TextureRect =$Overlay/FilaPrecio/Moneda

var idCosmetico: String= ""
var idMascota: String =""

func setup(id: String, tex: Texture2D, p: int, mascota_id: String) -> void:
	idCosmetico =id
	idMascota= mascota_id
	boton.texture_normal= tex
	etiquetaPrecio.text =str(p)
	iconoMoneda.texture= texMoneda
	actualizarVisual()

func actualizarVisual() -> void:
	var desbloqueado= EstadoMascota.cosmeticsDesbloqueados.has(idCosmetico)
	var equipado= EstadoMascota.cosmeticoPuesto.get(idMascota, "") ==idCosmetico
	overlay.visible= not desbloqueado
	if desbloqueado and equipado:
		boton.modulate= Color(0.6, 1, 0.6, 1)
	else:
		boton.modulate= Color(1, 1, 1, 1)

func _on_boton_pressed() -> void:
	carta_presionada.emit(idCosmetico)
