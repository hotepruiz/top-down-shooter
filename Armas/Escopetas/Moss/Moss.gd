extends "res://Armas/BaseArmasSemi.gd"


func _ready():
	super()
	
	MarkerCañon=$"RigidBody3D/MarkerCañon"
	AnimPlayer=$RigidBody3D/mossenberg/AnimationPlayer2

func AnimacionDisparo():
	AnimPlayer.play("disparo")
	
