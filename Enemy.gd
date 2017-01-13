extends KinematicBody2D

export var maxHealth = 10
var health = maxHealth

func _ready():
	pass
	
func takedamage(damage):
	print(get_name(), "Take %s damage,"%damage, "new health = %s"%(health - damage))
	health -= damage
	if (health <= 0):
		kill()

func kill():
	self.hide()
	self.set_collision_mask(0)
	self.set_layer_mask(0)
	self.queue_free()
	