extends "res://Armas/BaseArmasAutomaticas.gd"


func _ready():
	super()
	
	MarkerCañon=$"RigidBody3D/MarkerCañon"
	AnimPlayer=$RigidBody3D/SIG/AnimationPlayer2

func AnimacionDisparo():
	AnimPlayer.play("disparo")
	
