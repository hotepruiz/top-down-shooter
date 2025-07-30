extends "res://Armas/BaseArmasCerrojo.gd"


func _ready():
	super()
	
	MarkerCañon=$"RigidBody3D/MarkerCañon"
	AnimPlayer=$RigidBody3D/mossenberg/AnimationPlayer2

func AnimacionDisparo():
	pass
	

func AnimacionAbrirCerrojo():
	AnimPlayer.play("abrir_cerrojo")

func AnimacionCerrarCerrojo():
	AnimPlayer.play("cerrar_cerrojo")
