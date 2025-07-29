extends "res://Armas/BaseArmas.gd"

func _ready():
	super()
	
	$Timer.timeout.connect(ActualizarSeñalDisparo)
	ActualizarVelocidadAtaque()

func Disparar():
	if(ListaParaDisparar == true and balas > 0):
		Chispaso()
		InstanciarAudio()
		AnimacionDisparo()
		InstanciarProyectil()
		ManejarMunicion()
		$Timer.start()
		ListaParaDisparar=false
		print($RigidBody3D.freeze)
	elif(ListaParaDisparar == false):
		pass


func ActualizarVelocidadAtaque():
	$Timer.wait_time=(60/Cadencia)
