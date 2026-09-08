extends Node2D

@onready var tileMap=$TileMapLayer
@onready var jugador=$Jugador
@onready var bandera=$Bandera

var termino=false

func _ready():
	crearColisiones()
	crearNavegacion()
	jugador.elegirMascota(EstadoMascota.mascotaJugando)
	jugador.jugador_cayo.connect(terminarJuego)
	$Pajaro.atrapo_al_jugador.connect(terminarJuego)
	await get_tree().physics_frame
	$Pajaro/NavigationAgent2D.target_position=jugador.global_position
	
func crearColisiones():
	var tamano=Vector2(tileMap.tile_set.tile_size)
	for celda in tileMap.get_used_cells():
		var terreno=StaticBody2D.new()
		terreno.position=tileMap.map_to_local(celda)
		var colision=CollisionShape2D.new()
		var forma=RectangleShape2D.new()
		forma.size=tamano
		colision.shape=forma
		terreno.add_child(colision)
		add_child(terreno)
	
func crearNavegacion():
	var rect=tileMap.get_used_rect()
	var tamano=Vector2(tileMap.tile_set.tile_size)
	var esquina=tileMap.map_to_local(rect.position)-(tamano/2)
	var finalMapa=esquina+(Vector2(rect.size)*tamano)
	var poligono=NavigationPolygon.new()
	poligono.add_outline(PackedVector2Array([esquina, Vector2(finalMapa.x,esquina.y), finalMapa, Vector2(esquina.x,finalMapa.y)]))
	poligono.make_polygons_from_outlines()
	$Navegacion.navigation_polygon=poligono
	
func terminarJuego():
	if termino:
		return
	termino=true
	if EstadoMascota.mascotaJugando!="":
		EstadoMascota.cambioAburrimiento(EstadoMascota.mascotaJugando,-100)
		EstadoMascota.mascotaJugando=""
	EstadoMascota.guardarEstado()
	get_tree().change_scene_to_file("res://escenas/habitacion.tscn")
	
func _on_bandera_body_entered(body):
	if body==jugador:
		terminarJuego()

func _on_pajaro_body_entered(body):
	if body==jugador:
		terminarJuego()
