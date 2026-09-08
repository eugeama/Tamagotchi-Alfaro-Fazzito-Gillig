extends CharacterBody2D

signal jugador_cayo

@export var velocidad=150.0
@export var fuerzaSalto=700.0
@export var limiteCaida=750.0
@export var texturaJade:Texture2D
@export var texturaRagatha:Texture2D

var gravedad=ProjectSettings.get_setting("physics/2d/default_gravity")

func elegirMascota(idMascota):
	if idMascota=="mascota2":
		$Sprite2D.texture=texturaRagatha
	else:
		$Sprite2D.texture=texturaJade
	
func _physics_process(delta):
	if !is_on_floor():
		velocity.y+=gravedad*delta
	var direccion=Input.get_axis("izquierda","derecha")
	velocity.x=direccion*velocidad
	if direccion!=0:
		$Sprite2D.flip_h=direccion>0
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y=-fuerzaSalto
	move_and_slide()
	if global_position.y>limiteCaida:
		jugador_cayo.emit()
