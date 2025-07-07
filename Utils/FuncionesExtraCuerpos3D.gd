extends Node

static func mirar_hacia_objetivo(objeto_a_rotar: Node3D, objetivo: Node3D):
	var direccion: Vector3 = (objetivo.global_transform.origin - objeto_a_rotar.global_transform.origin).normalized()
	
	# Proyectamos la dirección solo en el plano XZ
	direccion.y = 0  
	direccion = direccion.normalized()  # Normalizamos nuevamente
	
	# Calculamos la rotación en Y usando atan2()
	objeto_a_rotar.rotation.y = atan2(-direccion.x, -direccion.z)
