extends Node3D

var sig = preload("res://Armas/SMG/MP7/MP7.tscn")
var fnx = preload("res://Armas/Pistolas/FNX45/FNX45.tscn")
var moss = preload("res://Armas/Escopetas/Moss/Moss.tscn")

var PlayerScene = preload("res://Jugador/player/MonturaJugador.tscn")
var Player :Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _ready2():
	Player=PlayerScene.instantiate()
	add_child(Player)
	
	var sig2 = sig.instantiate()
	add_child(sig2)
	sig2.position=Vector3(4,3.722,11)
	sig2.scale=Vector3(0.7,0.7,0.7)
	
	var fnx2 = fnx.instantiate()
	add_child(fnx2)
	fnx2.position=Vector3(0,10,11)
	fnx2.scale=Vector3(0.7,0.7,0.7)
	
	var moss2 = moss.instantiate()
	add_child(moss2)
	moss2.position=Vector3(-5,10,11)
	moss2.scale=Vector3(1,1,1)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
