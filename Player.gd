extends KinematicBody2D

var start_pos = get_pos()

export var health = 10
export var GRAVITY = 200.0
export var WALK_SPEED = 200.0
export var JUMP_SPEED = 300.0
var velocity = Vector2()

var raycast_downLeft = null
var raycast_downRight = null

var timer = null

var attack_pressed = false;

var facing_right = true;

const TILE_GROUND = 0
const TILE_DEATH = 1

func _ready():
	raycast_downLeft = get_node("RayCast2DLeft")
	raycast_downRight = get_node("RayCast2DRight")
	raycast_downLeft.add_exception(self)
	raycast_downRight.add_exception(self)
	
	add_collision_exception_with(get_node("Sword"))
	
	timer = get_node("AttackTimer")
	timer.connect("timeout", self, "end_attack")
	timer.set_active(false)
	timer.stop()
	
	end_attack()
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	# reset player if they are touching instant death tile
	if (is_on_death()):
		reset_player()
		return
	
	velocity.y += delta * GRAVITY
	
	if (Input.is_action_pressed("ui_left")):
		if (facing_right):
			set_scale(Vector2(-get_scale().x, get_scale().y))
			facing_right = false
		velocity.x = -WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
		if (!facing_right):
			set_scale(Vector2(get_scale().x, get_scale().y))
			facing_right = true
		velocity.x = WALK_SPEED
	else:
		velocity.x = 0
		
	if (Input.is_action_pressed("ui_up") && is_on_ground()):
		print("JUMP")
		velocity.y = -JUMP_SPEED
	
	if (!attack_pressed && Input.is_action_pressed("ui_accept") && !timer.is_active()):
		attack_pressed = true
		timer.set_active(true)
		timer.start()
		
		get_node("Sword").enable()
	
	if (attack_pressed && !Input.is_action_pressed("ui_accept")):
		attack_pressed = false
	
	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)


# @brief	reset the player
func reset_player():
	set_pos(start_pos)
	velocity.x = 0
	velocity.y = 0


# @brief 	returns whether the player is on ground
# @return 	bool true if the player is on the ground, false otherwise 
func is_on_ground():
	return (raycast_collide(raycast_downRight) == TILE_GROUND) || (raycast_collide(raycast_downLeft) == TILE_GROUND)

# @brief 	returns whether the player is touching an instant-death tile
# @return 	bool true if player is touching death tile, false otherwise
func is_on_death():
	#this should instead be getting all collisions from collisionshape2d and checkin them, but this kinda works for now
	return (raycast_collide(raycast_downRight) == TILE_DEATH) || (raycast_collide(raycast_downLeft) == TILE_DEATH)


# @brief	Returns whatever tileid of any tile colliding the provided raycast
# @param	raycast a RayCast2D object to use
# @return	int id of colliding tile, null otherwise
func raycast_collide(raycast):
	var collider = raycast.get_collider()
	if (raycast.is_colliding()):
		if (collider extends TileMap):
			var tilemap = collider
			var coll_pos = raycast.get_collision_point()
			var tile = collider.get_cellv(collider.world_to_map(coll_pos))
			if (tile == -1):
				return null
			else:
				return tile
	return null

func end_attack():
	get_node("Sword").disable()
	timer.set_active(false)