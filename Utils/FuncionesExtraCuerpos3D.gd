extends Node

static func mirar_hacia_objetivo(objeto_a_rotar: Node3D, objetivo: Node3D):
	var direccion: Vector3 = (objetivo.global_transform.origin - objeto_a_rotar.global_transform.origin).normalized()
	
	# Proyectamos la dirección solo en el plano XZ
	direccion.y = 0  
	direccion = direccion.normalized()  # Normalizamos nuevamente
	
	# Calculamos la rotación en Y usando atan2()
	objeto_a_rotar.rotation.y = atan2(-direccion.x, -direccion.z)

static func rotar_verticalmente(objeto_a_rotar: Node3D, objetivo: Node3D):
	var origen = objeto_a_rotar.global_transform.origin
	var destino = objetivo.global_transform.origin

	# Creamos una base temporal que mira al objetivo
	var dummy = Transform3D().looking_at(destino - origen, Vector3.UP)
	var rot_x = dummy.basis.get_euler().x
	
	objeto_a_rotar.rotation.x = rot_x
