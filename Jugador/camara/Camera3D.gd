extends Camera3D

@onready var cursor:Node3D = self.get_parent().get_parent().get_node("Montura Cursor")
@onready var Personaje: Node3D  = get_parent().get_parent()

@onready var ResultadosRaycast

#señales------------------------------------------------------------------
signal SeñalIntentoEquiparArma

func _ready():
	#conectar señales
	Personaje.SeñalInteractuar.connect(ManejarInteraccion)
	
	#apuntar camara hacia personaje
	self.look_at(Personaje.global_position)

func _process(delta):
	#cada frame se hace un raycast par amover el cursor
	Raycast()


#todo lo relacionado a mover el cursor va aca
func Raycast():
	var posicion_mouse: Vector2 = get_viewport().get_mouse_position()
	var origen: Vector3 = project_ray_origin(posicion_mouse)
	var destino: Vector3 = origen + project_ray_normal(posicion_mouse) * 200
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origen, destino)
	
	ResultadosRaycast = space_state.intersect_ray(query)
	
	#mover el cursor
	if ResultadosRaycast:
		cursor.global_position = ResultadosRaycast.position


#Manejar interacciones que hace el jugador, todo depende de de la 
#collision del raycast
func ManejarInteraccion():
	if ResultadosRaycast:
		var objeto_impactado = ResultadosRaycast["collider"] 
		
		#si se esta apuntando a un arma
		if objeto_impactado.get_parent() != null:  
			if objeto_impactado.get_parent().is_in_group("Armas"):
				#enviamoes el arma co
				SeñalIntentoEquiparArma.emit(objeto_impactado.get_parent())
		else:
			pass
		
		
