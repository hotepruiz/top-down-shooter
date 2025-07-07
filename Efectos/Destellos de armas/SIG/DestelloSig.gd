extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotation.x=randf_range(-100,100)
	self.emitting=true
	self.one_shot=true
	self.finished.connect(suicidar)
	

func suicidar():
	queue_free()
