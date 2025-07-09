extends "res://Armas/BaseArmasAutomaticas.gd"


func _ready():
	super()
	
	MarkerCañon=$"RigidBody3D/MarkerCañon"
	AnimPlayer=$RigidBody3D/MP7/AnimationPlayer2

func AnimacionDisparo():
	AnimPlayer.play("disparo")
	
