extends Node2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	animacion.play("idle")
