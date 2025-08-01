extends CharacterBody3D

@onready var Camara:Camera3D = $"Montura camara/Camara"
#modelo-------------------------------------------------------------------------
@onready var cabeza: MeshInstance3D = $Cabeza
@onready var torso: MeshInstance3D = $Torso
@onready var piernas: MeshInstance3D = $Piernas
@onready var cursor: Node3D = $"Montura Cursor"
@onready var torso2: Node3D = $"personaje 2 test"

#señales------------------------------------------------------------------------
signal SeñalDisparo
signal SeñalSoltarDisparo
signal SeñalInteractuar
signal SeñalSoltarRecarga

#Armas--------------------------------------------------------------------------
@export var ArmaPrimaria: Node3D
@export var ArmaSecundaria: Node3D

@onready var MonturaArmaPrimaria: Marker3D = $"Cabeza/MonturaArmaPrimaria"
@onready var MonturaArmaSecundaria: Marker3D = $"MonturaArmaSecundaria"

#-------------------------------------------------------------------------------
var tiempo_presionado := 0.0
const TIEMPO_UMBRAL := 0.5  # segundos que debe mantenerse presionado

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var test = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Camara.SeñalIntentoEquiparArma.connect(EquiparArma)

func _process(delta):
	MoverArmas()
	ManejarInputsSeñales(delta)
	mover_cabeza()
	mover_torso()

#inputs/Controles/señales----------------------------------------------------------------------
func ManejarInputsSeñales(delta):
	#armas-----------------------------------------------------
	if Input.is_action_pressed("ui_disparar"):
		SeñalDisparo.emit()
	
	if Input.is_action_just_released("ui_disparar"):
		SeñalSoltarDisparo.emit()
	
	if Input.is_action_pressed("ui_lanzarArma"):
		LanzarArma()
	
	if Input.is_action_pressed("ui_interactuar"):
		SeñalInteractuar.emit()
	
	if Input.is_action_pressed("ui_lanzarArma"):
		LanzarArma()
	
	#Recarga--------------------------------------------------------------------
	if Input.is_action_pressed("ui_recargar") and test == false:
		test = true
		RecargarArma()
	
	if Input.is_action_just_released("ui_recargar"):
		test = false
		SeñalSoltarDisparo.emit()
	
	#mantener presionado
	if Input.is_action_pressed("ui_recargar"):
		tiempo_presionado += delta
		if tiempo_presionado >= TIEMPO_UMBRAL:
			RecargarArmaSecundario()
	else:
		tiempo_presionado = 0.0  # Reiniciar si se suelta antes de llegar al umbral

#Armas--------------------------------------------------------------------------
func EquiparArma(Arma: Node3D):
	self.ArmaPrimaria=Arma
	Arma.Equipada=true
	Arma.EquiparArma()
	

func LanzarArma():
	if !self.ArmaPrimaria:
		return
	
	print(ArmaPrimaria)
	self.ArmaPrimaria.Equipada=false
	self.ArmaPrimaria.TirarArma()
	self.ArmaPrimaria = null

func RecargarArma():
	if !self.ArmaPrimaria:
		return
	
	self.ArmaPrimaria.Recargar()

func RecargarArmaSecundario():
	if !self.ArmaPrimaria:
		return
	
	self.ArmaPrimaria.RecargarSecundario()

#Cosas de modelo ---------------------------------------------------------------
func MoverArmas():
	if(ArmaPrimaria):
		ArmaPrimaria.global_position=MonturaArmaPrimaria.global_position

func mover_cabeza():
	mirar_hacia_objetivo(cabeza, cursor)
	
	if(ArmaPrimaria):
		var nodo = ArmaPrimaria.get_node("RigidBody3D/MarkerCañon")
		dibujar_linea(nodo, cursor.get_node("Marcador"))

func mover_torso():
	mirar_hacia_objetivo(torso2, cursor)
	#dibujar_linea(MonturaArmaPrimaria, cursor.get_node("Marcador"))


#Movimiento---------------------------------------------------------------------
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

#ETC--------------------------------------------------------------------------------
func dibujar_linea(inicio: Node3D, destino: Node3D):
	DebugDraw3D.scoped_config().set_thickness(0.02)
	DebugDraw3D.draw_line(inicio.global_position, destino.global_position, Color(1,0,0))

func mirar_hacia_objetivo(objeto_a_rotar: Node3D, objetivo: Node3D):
	var direccion: Vector3 = (objetivo.global_transform.origin - global_transform.origin).normalized()
	
	# Proyectamos la dirección solo en el plano XZ (ignoramos la altura)
	direccion.y = 0  
	direccion = direccion.normalized()  # Normalizamos nuevamente
	
	# Calculamos la rotación en Y usando atan2()
	objeto_a_rotar.rotation.y = atan2(-direccion.x, -direccion.z)
