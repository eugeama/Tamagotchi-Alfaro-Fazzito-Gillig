extends Node2D

const OPCIONES = ["piedra", "papel", "tijera"]

@onready var spriteJugador:AnimatedSprite2D = $AnimatedSprite2D
@onready var spriteMaquina:AnimatedSprite2D = $AnimatedSprite2D2
@onready var labelCuenta:Label = $Control/LabelCuenta
@onready var labelResultado:Label = $Control/LabelResultado
@onready var labelMonedas:Label = $Control/LabelMonedas
@onready var panelEleccion:HBoxContainer = $Control/HBoxContainer

var gananciaActual = 10
var esperando = false

func _ready() -> void:
	labelCuenta.visible = false
	labelResultado.visible = false
	_actualizarMonedas()
	spriteJugador.play("preparacion")
	spriteMaquina.play("preparacion")

func _actualizarMonedas() -> void:
	labelMonedas.text = "Monedas: %d" % EstadoMascota.monedas

func _on_boton_piedra_pressed() -> void:
	_elegir(0)
func _on_boton_papel_pressed() -> void:
	_elegir(1)
func _on_boton_tijera_pressed() -> void:
	_elegir(2)

func _elegir(opcion: int) -> void:
	if esperando:
		return
	esperando = true
	panelEleccion.visible = false
	await _cuentaAtras()
	_resolver(opcion)

func _cuentaAtras() -> void:
	labelCuenta.visible = true
	for n in [3, 2, 1]:
		labelCuenta.text = str(n)
		await get_tree().create_timer(1.0).timeout
	labelCuenta.visible = false

func _resolver(eleccionJugador: int) -> void:
	var eleccionMaquina = randi() % 3
	spriteJugador.play(OPCIONES[eleccionJugador])
	spriteMaquina.play(OPCIONES[eleccionMaquina])

	var resultado = _calcularResultado(eleccionJugador, eleccionMaquina)
	labelResultado.visible = true

	if resultado == 1:
		var ganado = gananciaActual
		EstadoMascota.monedas += ganado
		gananciaActual *= 2
		labelResultado.text = "¡GANASTE!\n+%d monedas" % ganado
	elif resultado == -1:
		EstadoMascota.monedas = 0
		gananciaActual = 10
		labelResultado.text = "¡PERDISTE!\nMonedas perdidas"
	else:
		labelResultado.text = "EMPATE"

	_actualizarMonedas()
	await get_tree().create_timer(2.0).timeout
	_reiniciarRonda()

func _calcularResultado(jugador: int, maquina: int) -> int:
	if jugador == maquina:
		return 0
	if (jugador==0 and maquina==2) or (jugador==1 and maquina==0) or (jugador==2 and maquina==1):
		return 1
	return -1

func _reiniciarRonda() -> void:
	labelResultado.visible = false
	panelEleccion.visible = true
	spriteJugador.play("preparacion")
	spriteMaquina.play("preparacion")
	esperando = false
