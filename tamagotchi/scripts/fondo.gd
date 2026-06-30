extends Node2D

var carta= preload("res://escenas/carta.tscn")
var fotos= [
	preload("res://sillys/00a032e1e6d6b4b1498276e56953b468.jpg"),
	preload("res://sillys/1b5d83135b4a56d80e8044855f6e0675.jpg"),
	preload("res://sillys/8acba5697e66d9c1a8cffd7ed1b68f5d.jpg"),
	preload("res://sillys/98d82051d1e95c0a56ee872c3a775e66.jpg"),
	preload("res://sillys/226fe91e4b33666f893d08522a26ee51.jpg"),
	preload("res://sillys/753ad679b9daf5629abcf2774e7b0508.jpg"),
	preload("res://sillys/cf4824f7310008d4430d40529e95827d.jpg"),
	preload("res://sillys/d32076cf862f9e0545b96be76463a0a4.jpg"),
	preload("res://sillys/EadJGwvUMAE5m7m (1).jpg"),
	preload("res://sillys/f4e60bad8d1bdfe900079272e4e13224.jpg")
]
var todasCartas= []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for t in fotos:
		var cartas= carta.instantiate()
		cartas.get_node("frente").texture= t
		todasCartas.append(cartas)
		var carta_igual= carta.instantiate()
		carta_igual.get_node("frente").texture= t
		todasCartas.append(carta_igual)
		
	todasCartas.shuffle()
	
	for fila in 4:
		for columna in 5:
			var cartitas= todasCartas[fila*5 + columna]
			cartitas.position= Vector2(72, 72) + Vector2(124*columna, 124*fila)
			add_child(cartitas)

func _input(event):
	pass
