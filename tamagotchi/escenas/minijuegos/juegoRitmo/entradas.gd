extends Sprite2D
@export var tecla:String=""
@onready var flecha=preload("res://escenas/minijuegos/juegoRitmo/flechas.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func inicio():
	set_process(false)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(tecla):
		generarFlecha()
func generarFlecha():
	var nuevaFlecha=flecha.instantiate()
	get_tree().get_root().call_deferred("add_child",nuevaFlecha)
	nuevaFlecha.Setup(position.x,frame+4)
