extends AudioStreamPlayer3D

func _ready():
	self.finished.connect(suicidar)

func suicidar():
	self.queue_free()
	await get_tree().process_frame
