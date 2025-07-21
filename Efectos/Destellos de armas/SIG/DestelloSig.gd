extends Node3D


# Esta funcion sirve para todas las particulas de las armas
#de destello de las armas, solo hay que asegurarse de que la 
#emision de la particula apunte a +X
func _ready():
	self.rotation.x=randf_range(-100,100)
	self.emitting=true
	self.one_shot=true
	
	var tamaño = float(randf_range(0.9,1.1))
	$OmniLight3D.light_energy=tamaño
	
	self.finished.connect(suicidar)
	

func suicidar():
	queue_free()
