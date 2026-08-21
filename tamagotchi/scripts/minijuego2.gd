extends Node2D

const OPCIONES = ["piedra", "papel", "tijera"]

@onready var spriteJugador:AnimatedSprite2D = $AnimatedSprite2D
@onready var spriteMaquina:AnimatedSprite2D = $AnimatedSprite2D2
@onready var labelCuenta:Label = $Control/LabelCuenta
@onready var labelResultado:Label = $Control/LabelResultado
@onready var labelMonedas:Label = $Control/LabelMonedas
@onready var panelEleccion:HBoxContainer = $Control/HBoxContainer
@export var count_speed: float = 5.0

var gananciaActual = 10
var esperando = false
var pptPot =0

func _ready() -> void:
	labelCuenta.visible = false
	labelResultado.visible = false
	_actualizarMonedas()
	spriteJugador.play("preparacion")
	spriteMaquina.play("preparacion")

func _actualizarMonedas() -> void:
	$Timermonedas.start()

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
	print("[PPT] resultado=", resultado, " | monedas antes=", EstadoMascota.monedas)
	labelResultado.visible = true

	if resultado == 1:
		var ganado = gananciaActual
		EstadoMascota.monedas += ganado
		print("[PPT] monedas despues de sumar=", EstadoMascota.monedas)
		EstadoMascota.guardarEstado()
		pptPot +=ganado
		gananciaActual *= 2
		labelResultado.text = "¡GANASTE!\n\n\n\n+%d monedas" % ganado
		labelMonedas.position= Vector2(497,270)
	elif resultado == -1:
		EstadoMascota.monedas =max(0, EstadoMascota.monedas -pptPot)
		EstadoMascota.guardarEstado()
		pptPot =0
		gananciaActual = 10
		labelResultado.text = "¡PERDISTE!\n\n\n\nMonedas perdidas"
		labelMonedas.position= Vector2(497,270)
	else:
		labelResultado.text = "EMPATE\n\n\n\n"

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
	labelMonedas.position= Vector2(60,15)
	labelResultado.visible = false
	panelEleccion.visible = true
	spriteJugador.play("preparacion")
	spriteMaquina.play("preparacion")
	esperando = false


func _on_timermonedas_timeout() -> void:
	var regex= RegEx.new()
	regex.compile("\\d+") 
	var resultado = regex.search(labelMonedas.text)
	
	var valor_actual: int = int(resultado.get_string()) if resultado else 0
	var valor_final: int = EstadoMascota.monedas
	
	if valor_actual == valor_final:
		return
	var monedas_por_segundo: float= 150.0 
	var distancia: int = abs(valor_final - valor_actual)
	var duracion: float = distancia / monedas_por_segundo
	
	var tween = create_tween()
	tween.tween_method(
		func(valor_intermedio: int): labelMonedas.text = "Monedas: %d" % valor_intermedio,valor_actual,valor_final,duracion
	)

func _on_volver_pressed() -> void:
	EstadoMascota.guardarEstado()
	get_tree().change_scene_to_file("res://escenas/habitacion.tscn")
