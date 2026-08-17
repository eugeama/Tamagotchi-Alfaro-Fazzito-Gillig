extends Node2D

var carta= preload("res://escenas/carta.tscn")
var todasCartas= []
var cartas_abiertas = []
var comparando = false

@onready var intentos = $ui2
@onready var ui = $ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.puntaje_ganador.connect(_on_puntaje_ganador)
	for key in fotos.CARTAS:
		var carta_info = fotos.CARTAS[key]
		var textura = load(carta_info["foto"])
		
		var cartass= carta.instantiate()
		cartass.numero_pareja = carta_info["numero"]
		cartass.get_node("frente").texture = textura
		cartass.volteo_completado.connect(_on_carta_volteo_completado)
		todasCartas.append(cartass)
		
		var carta_igual= carta.instantiate()
		carta_igual.numero_pareja = carta_info["numero"]
		carta_igual.get_node("frente").texture = textura
		carta_igual.volteo_completado.connect(_on_carta_volteo_completado)
		todasCartas.append(carta_igual)
		
	todasCartas.shuffle()
	
	for fila in 4:
		for columna in 5:
			var cartitas= todasCartas[fila*5 + columna]
			cartitas.position= Vector2(558, 95) + Vector2(124*columna, 124*fila)
			add_child(cartitas)
			
func _on_carta_volteo_completado() -> void:
	cartas_abiertas.clear()
	for c in get_children():
		if c is Carta and c.elegido:
			cartas_abiertas.append(c)
			
	if cartas_abiertas.size() == 2 and not comparando:
		comparando = true
		await get_tree().create_timer(0.5).timeout
		
		if cartas_abiertas[0].numero_pareja == cartas_abiertas[1].numero_pareja:
			Seniales.aumentarPuntaje.emit(5)
			for c in cartas_abiertas:
				c.queue_free()
		else:
			intentos.bajar()
			if intentos.intentoss() <= 0:
				await get_tree().create_timer(1.0).timeout
				get_tree().change_scene_to_file("res://escenas/habitacion.tscn")
			for c in cartas_abiertas:
				c.devolver()
				
		comparando = false

func _on_puntaje_ganador() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://escenas/habitacion.tscn")

func _input(event):
	pass
