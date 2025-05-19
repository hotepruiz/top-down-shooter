extends Node3D

@onready var personaje = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotar()

func rotar():
	self.mirar_hacia_objetivo(personaje)


func mirar_hacia_objetivo(objetivo: Node3D):
	var direccion: Vector3 = (objetivo.global_transform.origin - global_transform.origin).normalized()
	
	# Proyectamos la dirección solo en el plano XZ (ignoramos la altura)
	direccion.y = 0  
	direccion = direccion.normalized()  # Normalizamos nuevamente
	
	# Calculamos la rotación en Y usando atan2()
	rotation.y = atan2(-direccion.x, -direccion.z)
