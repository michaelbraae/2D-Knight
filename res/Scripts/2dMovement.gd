extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -550

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("right"):
		motion.x = SPEED
		# anim
		
	if Input.is_action_pressed("left"):
		motion.x = -SPEED
		#anim
	else:
			motion.x = 0
			
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			motion.y = JUMP_HEIGHT
		
	motion = move_and_slide(motion, UP)
	pass
