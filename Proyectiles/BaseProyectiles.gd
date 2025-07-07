extends RigidBody3D

@export var velocidad : PackedScene

func _ready():
	print("bala!!")

func init(direccion: Vector3):
	self.apply_central_impulse(direccion.normalized() * 3)
