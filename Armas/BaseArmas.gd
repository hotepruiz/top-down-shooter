extends Node
var Utils3D = load("res://Utils/FuncionesExtraCuerpos3D.gd")

#Elementos para rotar el arma-------------------
@onready var cursor : Node3D = get_node("/root/Main/MonturaJugador/Personaje/Montura Cursor/Marcador")
@onready var Jugador : Node3D = get_node("/root/Main/MonturaJugador/Personaje")

#Elementos del arma----------------------------------------------------------
@onready var CuerpoArma : Node3D = $RigidBody3D
@onready var AudioPlayer : AudioStreamPlayer3D = $RigidBody3D/AudioStreamPlayer3D
@onready var AnimPlayer : AnimationPlayer
@onready var MarkerCañon : Marker3D

#Atributos del arma-------------------------------------------------------------
@export_range(1, 700,1) var TamañoCargador : int
@export_range(1, 1200,0.1) var Cadencia : float
@export_range(0, 1000,0.1) var DañoBase : float
@export var Destello : PackedScene
@export var Proyectil: PackedScene
@export var SonidoDisparo : AudioStream

#esto (Variable equipada) lo voy a usar como un bool de 3 estados
#true= equipada, false= el arma esta tirada en el suelo
#null = el arma esta guardad en un espacio de arma secunario, solo inactiva o algo
var Equipada : Variant = false
var ListaParaDisparar : bool = true
var balas: int 

func _ready():
	#TODO: recordar asignar el animation player en un script heredado
	add_to_group("Armas")
	
	balas = TamañoCargador
	
	Equipada = false
	AudioPlayer.stream = SonidoDisparo
	
	set_process(false)

func _process(delta):
	Utils3D.rotar_verticalmente(CuerpoArma, cursor)
	Utils3D.mirar_hacia_objetivo(CuerpoArma, cursor)

#Funciones de logica de disparo ---------------------------------------------------------
func Disparar():
	push_warning("Disparar() debe ser sobreescrito en el arma hija.")

func ManejarMunicion():
	if(balas == 0):
		print("recargar")
	else:
		balas -= 1
		print(balas)

func Recargar():
	if(balas < TamañoCargador):
		balas = TamañoCargador
		print("Recargando arma")
		return
	if(balas == TamañoCargador or balas > TamañoCargador):
		return

func RecargarSecundario():
	push_warning("Esta arma no tiene mecanica secundaria de recarga o .")

#Funciones de fisicas ---------------------------------------------------------
func EquiparArma():
	#actualizamos el estado y apagamos las fisicas
	Equipada = true
	
	$RigidBody3D.rotation = Vector3(0,0,0)
	
	$RigidBody3D/CollisionShape3D.disabled = true
	$RigidBody3D.freeze_mode = 0
	$RigidBody3D.freeze = true
	
	
	$RigidBody3D.global_position=self.global_position
	#el arma comienza a poner atencion a las señales de disparo
	Jugador.SeñalDisparo.connect(self.Disparar)
	
	Utils3D.mirar_hacia_objetivo(CuerpoArma, cursor)
	set_process(true)

func TirarArma():
	Equipada = true
	
	#prendemos las fisicas
	$RigidBody3D/CollisionShape3D.disabled = false
	$RigidBody3D.freeze_mode = 1
	$RigidBody3D.freeze = false
	
	$RigidBody3D.apply_impulse(Vector3(100, 20, 0), Vector3(-1, 0, 0))
	$RigidBody3D.apply_torque(Vector3(50, 0, 0))
	
	#el arma deja de poner atencion a las señales de disparo
	Jugador.SeñalDisparo.disconnect(self.Disparar)
	set_process(false)

func GuardarArma():
	#actualizamos el estado y apagamos las fisicas
	Equipada = null
	$RigidBody3D/CollisionShape3D.disabled = true
	
	$RigidBody3D.global_position=self.global_position
	#el arma deja de poner atencion a las señales de disparo
	Jugador.SeñalDisparo.disconnect(self.Disparar)
	
	set_process(false)

#Funciones de efectos de disparo ----------------------------------------------------------
func AnimacionDisparo():
	push_warning("AnimacionDisparo() debe ser sobreescrito en el arma hija.")

func InstanciarProyectil():
	var proyectil_nuevo = Proyectil.instantiate()
	var nivel=get_node("/root/Main")
	
	nivel.add_child(proyectil_nuevo)
	
	#transforms
	proyectil_nuevo.global_position = MarkerCañon.global_position
	proyectil_nuevo.rotation = MarkerCañon.global_rotation
	
	proyectil_nuevo.init((cursor.global_position  - MarkerCañon.global_position ))

func Chispaso():
	var NuevasParticulas=Destello.instantiate()
	NuevasParticulas.position=MarkerCañon.position
	NuevasParticulas.rotation=MarkerCañon.rotation
	$RigidBody3D.add_child(NuevasParticulas)

func InstanciarAudio():
	var NuevoAudioPlayer : AudioStreamPlayer3D=$RigidBody3D/AudioStreamPlayer3D.duplicate()
	$RigidBody3D.add_child(NuevoAudioPlayer)
	NuevoAudioPlayer.global_position=$RigidBody3D.global_position
	NuevoAudioPlayer.pitch_scale+=randf_range(-0.07,0.07)
	NuevoAudioPlayer.playing=true
	
func ActualizarSeñalDisparo():
	ListaParaDisparar=true
