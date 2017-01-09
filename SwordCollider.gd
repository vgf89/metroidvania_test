extends Area2D

var old_layer_mask = get_layer_mask()
var old_collision_mask = get_collision_mask()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter", self, "on_area2d_enter")
	connect("body_exit", self, "on_area2d_exit")
	set_fixed_process(true)
	
func _fixed_process(delta):
	#if is_colliding():
#		print("Collision with: ")
	pass
	
func on_area2d_enter(entity):
	if (entity.has_method("takedamage")):
		entity.takedamage()
		
func on_area2d_exit(entity):
	pass

func disable():
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	
func enable():
	set_layer_mask(old_layer_mask)
	set_collision_mask(old_collision_mask)
	show()