extends Area2D

var old_layer_mask = get_layer_mask()
var old_collision_mask = get_collision_mask()

export var power = 5

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	pass

func disable():
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	
func enable():
	set_layer_mask(old_layer_mask)
	set_collision_mask(old_collision_mask)
	show()


func _on_Sword_body_enter( body ):
	if (body.has_method("takedamage")):
		body.takedamage(power)
