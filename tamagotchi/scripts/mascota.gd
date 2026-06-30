extends Node2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var camara: Camera2D = $Camera2D
@onready var atributos: Control = $Control
@onready var textura: Control = $textura

const perdidaEnergiaPeriodica=5.0
const sumaHambrePeriodica=10.0
const sumaAburrimientoPeriodica=10.0
const zoomNormal=Vector2(1,1)
const zoomEnMascota=Vector2(2,2)
const duracionZoom=0.6
const areaToque=Vector2(55,65)
const pausaIdleMin=1.0
const pausaIdleMax=3.5
const velocidadIdleMin=45.0
const velocidadIdleMax=95.0
const margenMovimiento=30.0

var mostrandoAtributos=false
var tweenCamara:Tween
var tweenMovimiento:Tween
var centroCamaraInicial=Vector2.ZERO
var offsetCamaraMascota=Vector2.ZERO
var random=RandomNumberGenerator.new()

func _ready() -> void:
	animacion.play("idle")
	EstadoMascota.cambioEstado.connect(actualizarAnimacion)
	random.randomize()
	offsetCamaraMascota=camara.position
	atributos.visible=false
	atributos.modulate=Color(1,1,1,0)
	camara.enabled=false
	ignorarMouseEnVisuales(textura)
	iniciarMovimientoIdle()

func _on_timer_timeout() -> void:
	EstadoMascota.cambioEnergia(-perdidaEnergiaPeriodica)
	EstadoMascota.cambioHambre(+sumaHambrePeriodica)
	EstadoMascota.cambioAburrimiento(+sumaAburrimientoPeriodica)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and mostrandoAtributos:
		cerrarAtributos()
		get_viewport().set_input_as_handled()
	if eventoTocaMascota(event) and not mostrandoAtributos:
		mostrarAtributos()
		get_viewport().set_input_as_handled()

func eventoTocaMascota(event: InputEvent) -> bool:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		return puntoTocaMascota(event.position)
	if event is InputEventScreenTouch and event.pressed:
		return puntoTocaMascota(event.position)
	return false

func puntoTocaMascota(posicionPantalla: Vector2) -> bool:
	var posicionMundo=get_viewport().get_canvas_transform().affine_inverse()* posicionPantalla
	var posicionLocal=to_local(posicionMundo)
	return abs(posicionLocal.x)<=areaToque.x and abs(posicionLocal.y)<=areaToque.y

func mostrarAtributos() -> void:
	mostrandoAtributos=true
	detenerMovimientoIdle()
	centroCamaraInicial=get_viewport().get_canvas_transform().affine_inverse()* (get_viewport_rect().size/2.0)
	var centroMascota=global_position+(offsetCamaraMascota* global_scale)
	if tweenCamara:
		tweenCamara.kill()
	camara.enabled=true
	camara.make_current()
	camara.zoom=zoomNormal
	camara.global_position=centroCamaraInicial
	atributos.visible=true
	atributos.modulate=Color(1,1,1,0)
	animacion.play("mostrarAtributos")
	tweenCamara=create_tween()
	tweenCamara.set_parallel(true)
	tweenCamara.tween_property(camara,"zoom",zoomEnMascota,duracionZoom)
	tweenCamara.tween_property(camara,"global_position",posicionCamaraLimitada(zoomEnMascota,centroMascota),duracionZoom)

func cerrarAtributos() -> void:
	mostrandoAtributos=false
	if tweenCamara:
		tweenCamara.kill()
	if animacion.current_animation=="mostrarAtributos":
		animacion.stop()
	animacion.play("quitarAtributos")
	var duracionSalida=obtenerDuracionAnimacion("quitarAtributos",duracionZoom)
	tweenCamara=create_tween()
	tweenCamara.set_parallel(true)
	tweenCamara.tween_property(camara,"zoom",zoomNormal,duracionSalida)
	tweenCamara.tween_property(camara,"global_position",centroCamaraInicial,duracionSalida)
	tweenCamara.finished.connect(_on_cerrar_atributos_terminado)

func posicionCamaraLimitada(zoomObjetivo: Vector2, posicionObjetivo: Vector2) -> Vector2:
	var rectFondo=obtenerRectFondo()
	var mitadVisible=(get_viewport_rect().size/zoomObjetivo)/2.0
	posicionObjetivo.x=limitarEje(posicionObjetivo.x,rectFondo.position.x +mitadVisible.x,rectFondo.end.x-mitadVisible.x,rectFondo.get_center().x)
	posicionObjetivo.y=limitarEje(posicionObjetivo.y,rectFondo.position.y+ mitadVisible.y,rectFondo.end.y-mitadVisible.y,rectFondo.get_center().y)
	return posicionObjetivo

func limitarEje(valor: float, minimo: float, maximo: float, centro: float) -> float:
	if minimo>maximo:
		return centro
	return clamp(valor,minimo,maximo)

func obtenerRectFondo() -> Rect2:
	var fondo=get_parent().get_node_or_null("Fondo")
	var piso=get_parent().get_node_or_null("Piso")
	var rect=Rect2()
	var tieneRect=false
	if fondo is Sprite2D and fondo.texture:
		rect=rectSprite(fondo)
		tieneRect=true
	if piso is Sprite2D and piso.texture:
		var rectPiso=rectSprite(piso)
		if tieneRect:
			rect=rect.merge(rectPiso)
		else:
			rect=rectPiso
			tieneRect=true
	if tieneRect:
		return rect
	var centro=get_viewport().get_canvas_transform().affine_inverse()* (get_viewport_rect().size/2.0)
	var tamano=get_viewport_rect().size
	return Rect2(centro-(tamano/2.0),tamano)

func rectSprite(sprite: Sprite2D) -> Rect2:
	var tamano=sprite.texture.get_size()* sprite.global_scale.abs()
	return Rect2(sprite.global_position-(tamano/2.0),tamano)

func obtenerDuracionAnimacion(nombre: StringName, duracionDefecto: float) -> float:
	if animacion.has_animation(nombre):
		return animacion.get_animation(nombre).length
	return duracionDefecto

func _on_cerrar_atributos_terminado() -> void:
	atributos.visible=false
	camara.enabled=false

func iniciarMovimientoIdle() -> void:
	while is_inside_tree():
		await get_tree().create_timer(random.randf_range(pausaIdleMin,pausaIdleMax)).timeout
		if mostrandoAtributos or not is_inside_tree():
			continue
		var destino=posicionIdleRandom()
		var distancia=abs(destino.x-global_position.x)
		if distancia<5.0:
			continue
		var duracion=distancia/random.randf_range(velocidadIdleMin,velocidadIdleMax)
		tweenMovimiento=create_tween()
		tweenMovimiento.tween_property(self,"global_position",destino,duracion)
		await get_tree().create_timer(duracion).timeout

func posicionIdleRandom() -> Vector2:
	var rectFondo=obtenerRectFondo()
	var margen=(margenMovimiento*abs(global_scale.x))
	var minimo=rectFondo.position.x +margen
	var maximo=rectFondo.end.x-margen
	var destino=global_position
	if minimo>maximo:
		destino.x=rectFondo.get_center().x
	else:
		destino.x=random.randf_range(minimo,maximo)
	return destino

func detenerMovimientoIdle() -> void:
	if tweenMovimiento:
		tweenMovimiento.kill()

func ignorarMouseEnVisuales(nodo: Node) -> void:
	if nodo is Control:
		nodo.mouse_filter=Control.MOUSE_FILTER_IGNORE
	for hijo in nodo.get_children():
		ignorarMouseEnVisuales(hijo)

func actualizarAnimacion() -> void:
	#pass
	"""
	para cuando gtengamos los sprites chicoooos
	var hambre=EstadoMascota.hambre
	var energia=EstadoMascota.energia
	var aburrimiento=EstadoMascota.aburrimiento
	
	if hambre>50:
		cambiarAnimacion("hambriento")
	elif energia<50:
		cambiarAnimacion("cansado")
	elif aburrimiento>50:
		cambiarAnimacion("aburrido")
	else:
		cambiarAnimacion("idle")
		"""
func cambiarAnimacion(nombre:String)-> void:
	if animacion.current_animation!=nombre:
		animacion.play(nombre)
	
func dormir() -> void:
	EstadoMascota.cambioEnergia(+50)
	EstadoMascota.cambioHambre(+10)
	EstadoMascota.cambioAburrimiento(+20)
	animacion.play("Dormir")
func comer() -> void:
	EstadoMascota.cambioHambre(-30)
	animacion.play("comer")
func jugar() -> void:
	#aca va el juegou
	EstadoMascota.cambioAburrimiento(-20)
	EstadoMascota.cambioEnergia(-10)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="quitarAtributos":
		atributos.visible=false
	if anim_name!="idle":
		animacion.play("idle")
