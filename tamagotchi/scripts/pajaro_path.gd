extends CharacterBody2D

signal atrapo_al_jugador

@export var velocidad=190.0
@export var velocidadVertical=100.0
@export var distanciaAtrape=20.0

@onready var jugador=get_node("../Jugador")
@onready var agente=$NavigationAgent2D

var subiendo=false

func _ready():
	$Sprite2D.play("volando")
	
func _physics_process(delta):
	agente.target_position=jugador.global_position
	var siguientePunto=agente.get_next_path_position()
	var direccion=global_position.direction_to(siguientePunto)
	velocity.x=direccion.x*velocidad
	if subiendo:
		velocity.y=-velocidadVertical
	else:
		velocity.y=velocidadVertical
	if velocity.x!=0:
		$Sprite2D.flip_h=velocity.x>0
	move_and_slide()
	if tocandoAlgo():
		subiendo=true
	elif subiendo:
		subiendo=false
	if global_position.distance_to(jugador.global_position)<distanciaAtrape:
		atrapo_al_jugador.emit()
	
func tocandoAlgo():
	for i in get_slide_collision_count():
		var choque=get_slide_collision(i)
		if choque.get_collider()!=jugador:
			return true
	return false
