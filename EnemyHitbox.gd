extends Area2D

export var power = 5

func _ready():
	connect("body_enter", self, "on_area_enter")
	
func on_area_enter(body):
	print("test")
	print(body)

func _on_Hitbox_body_enter( body ):
	print("test")
	if (body.has_method("takedamage")):
		body.takedamage(power)
