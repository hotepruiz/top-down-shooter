extends Node
var Utils3D = load("res://FuncionesExtraCuerpos3D.gd")

#etest-------------------
@onready var cursor : Node3D = get_node("/root/Main/MonturaJugador/Personaje/Montura Cursor")
@onready var armaa : Node3D = $RigidBody3D
#Elementos del arma-------------------------------------------------------------
@export_range(0, 1000,0.1) var DañoBase : float
@export var Destello : PackedScene
@export var Proyectil: Node3D
@export var SonidoDisparo : AudioStream
@export_range(1, 700,0.1) var Cadencia : float

@onready var AudioPlayer : AudioStreamPlayer3D = $RigidBody3D/AudioStreamPlayer3D
@onready var AnimPlayer : AnimationPlayer

#Elementos del jugador----------------------------------------------------------
@onready var Jugador : Node3D = get_node("/root/Main/MonturaJugador/Personaje")
@onready var MarkerCañon : Marker3D

#Efectos------------------------------------------------------------------------
#esto (Variable equipada) lo voy a usar como un bool de 3 estados
#true= equipada, false= el arma esta tirada en el suelo
#null = el arma esta guardad en un espacio de arma secunario, solo inactiva o algo
var Equipada : Variant = false
var ListaParaDisparar : bool = true

func _ready():
	#TODO: recordar asignar el animation player en un script heredado
	add_to_group("Armas")
	
	Equipada = false
	AudioPlayer.stream = SonidoDisparo
	
	$Timer.timeout.connect(ActualizarSeñalDisparo)
	ActualizarVelocidadAtaque()
	
	set_process(false)


func _process(delta):
	Utils3D.mirar_hacia_objetivo(armaa, cursor)


#Funciones principales --------------------------------------------------------
func Disparar():
	if(ListaParaDisparar == true):
		Chispaso()
		InstanciarAudio()
		AnimacionDisparo()
		$Timer.start()
		ListaParaDisparar=false
		print($RigidBody3D.freeze)
	elif(ListaParaDisparar == false):
		pass

func EquiparArma():
	#actualizamos el estado y apagamos las fisicas
	Equipada = true
	
	$RigidBody3D/CollisionShape3D.disabled = true
	$RigidBody3D.freeze_mode = 0
	$RigidBody3D.freeze = true
	
	
	$RigidBody3D.global_position=self.global_position
	#el arma comienza a poner atencion a las señales de disparo
	Jugador.SeñalDisparo.connect(self.Disparar)
	
	Utils3D.mirar_hacia_objetivo(armaa, cursor)
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


#Funciones secundarias --------------------------------------------------------
func AnimacionDisparo():
	pass

func Chispaso():
	var NuevasParticulas=Destello.instantiate()
	NuevasParticulas.position=MarkerCañon.position
	$RigidBody3D.add_child(NuevasParticulas)

func InstanciarAudio():
	var NuevoAudioPlayer : AudioStreamPlayer3D=$RigidBody3D/AudioStreamPlayer3D.duplicate()
	$RigidBody3D.add_child(NuevoAudioPlayer)
	NuevoAudioPlayer.global_position=$RigidBody3D.global_position
	NuevoAudioPlayer.pitch_scale+=randf_range(-0.07,0.07)
	NuevoAudioPlayer.playing=true

func ActualizarVelocidadAtaque():
	$Timer.wait_time=(60/Cadencia)

func ActualizarSeñalDisparo():
	ListaParaDisparar=true
