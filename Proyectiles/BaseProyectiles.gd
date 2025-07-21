extends RigidBody3D

@export var velocidad : PackedScene

func _ready():
	print("bala!!")

func init(direccion: Vector3):
	self.apply_central_impulse(direccion.normalized() * 4.5)

func _on_body_entered(body: Node) -> void:
	suicidar()

func suicidar():
	self.queue_free()
	await get_tree().process_frame
