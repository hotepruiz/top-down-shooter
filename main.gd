extends Node3D

var sig = preload("res://Armas/Rifles/sig/SIG.tscn")
var PlayerScene = preload("res://Jugador/player/MonturaJugador.tscn")
var Player :Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Player=PlayerScene.instantiate()
	add_child(Player)
	
	var sig2 = sig.instantiate()
	add_child(sig2)
	sig2.position=Vector3(0,3.722,11)
	sig2.scale=Vector3(0.7,0.7,0.7)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
