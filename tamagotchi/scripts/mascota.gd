extends Node2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	animacion.play("idle")


func _on_timer_timeout() -> void:
	pass # Replace with function body.
