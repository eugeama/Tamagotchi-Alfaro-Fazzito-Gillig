extends Area2D

signal recogido

func _on_input_event(viewport:Node, event:InputEvent, _shapeIndex:int)-> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		recogido.emit()
		queue_free()
	if event is InputEventScreenTouch and event.pressed:
		viewport.set_input_as_handled()
		recogido.emit()
		queue_free()
