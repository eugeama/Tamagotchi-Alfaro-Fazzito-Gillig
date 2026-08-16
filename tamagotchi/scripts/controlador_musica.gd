extends Node2D
const editando:bool=false
var cancion="RYTHM_HELL"
var tiempoLlegada:float=2.2
var outputArray=[[],[],[],[]]
var infoCancion={
	"RYTHM_HELL"={
		"tiempos": "[[2.52533321380615, 6.55733375549316, 10.5573337554932, 14.5040004730225, 14.6533325195313, 15.5493324279785, 15.6986663818359, 15.9333332061768, 16.0719993591309, 19.76266746521, 22.8666675567627, 27.2293327331543, 30.823998260498, 34.5786674499512, 34.7173316955566, 35.0159996032715, 35.282666015625, 35.4640014648437, 35.6453330993652, 35.9333351135254, 36.1466682434082, 36.2533348083496, 36.3706672668457, 40.4133346557617], [3.03733329772949, 7.0586669921875, 7.28266696929932, 11.5600002288818, 11.8053329467773, 14.9200008392334, 15.0479991912842, 15.282666015625, 15.5813339233398, 16.296000289917, 18.8026664733887, 19.9119995117188, 20.0826671600342, 23.2080009460449, 23.346667098999, 23.9226673126221, 24.3279998779297, 26.792000579834, 27.7200000762939, 28.1253326416016, 31.1759994506836, 31.858666229248, 34.8453338623047, 34.9839981079102, 35.1546676635742, 35.3999984741211, 35.5706680297852, 35.741333770752, 35.8693321228027, 36.0186660766602, 36.1359985351562, 36.2533348083496], [3.56000022888184, 7.54933338165283, 10.7919996261597, 11.0266664505005, 14.5040004730225, 14.6533325195313, 15.5600002288818, 15.7093341827393, 15.9333332061768, 16.0826671600342, 19.0373332977295, 19.1973331451416, 19.3893325805664, 20.274666595459, 20.4026668548584, 23.5493324279785, 23.7093341827393, 24.1146667480469, 27.0159996032715, 27.9333332061768, 31.5280006408691, 32.231999206543], [4.07199983596802, 8.06133346557617, 12.0613334655762, 26.5893333435059, 27.4639995574951]]",
		"music":load("res://escenas/minijuegos/juegoRitmo/RhythmHell.mp3")
	}
}
func _ready() -> void:
	$AudioStreamPlayer2D.stream=infoCancion.get(cancion).get("music")
	$AudioStreamPlayer2D.play()
	if editando:
		Seniales.teclaPresionada.connect(teclaPresionada)
	else:
		var tiempos=infoCancion.get(cancion).get("tiempos")
		var tiemposArr=str_to_var(tiempos)
		var contador:int=0
		for t in tiemposArr:
			var teclaNombre:String=""
			match contador:
				0:
					teclaNombre="izquierda"
				1:
					teclaNombre="arriba"
				2:
					teclaNombre="abajo"
				3:
					teclaNombre="derecha"
			for delay in t:
				spawnFlechas(teclaNombre,delay)
			contador+=1
			
func spawnFlechas(tecla:String, delay:float):
	await get_tree().create_timer(delay).timeout
	Seniales.generarFlecha.emit(tecla)
func teclaPresionada(teclaInput:String, arrayNum:int):
	print(str(arrayNum)+" "+str($AudioStreamPlayer2D.get_playback_position()))
	outputArray[arrayNum].append($AudioStreamPlayer2D.get_playback_position()-tiempoLlegada)
	
func _on_audio_stream_player_2d_finished() -> void:
	get_tree().change_scene_to_file("res://scripts/habitacion.gd")
