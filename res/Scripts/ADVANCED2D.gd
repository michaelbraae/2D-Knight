extends KinematicBody2D
onready var animatedSprite = $AnimatedSprite
export (int) var speed = 200
const GRAVITY = 1
const UP = Vector2(0, -1)
const JUMP_HEIGHT = -1000
var rolling = false
var velocity = Vector2()

func _physics_process(delta):
	velocity = Vector2()
	velocity.y += GRAVITY
	
	if animatedSprite.get_animation() == "roll":
		rolling = true
	else:
		rolling = false
		if Input.is_action_pressed('right'):
			animatedSprite.flip_h = false
			animatedSprite.play("run")
			velocity.x += 1
		elif Input.is_action_pressed('left'):
			animatedSprite.play("run")
			animatedSprite.flip_h = true
			velocity.x -= 1
		else:
			velocity.x = 0
			animatedSprite.play("idle")
		
		if Input.is_action_pressed("roll"):
			animatedSprite.play("roll")
		
		if is_on_floor():
			if Input.is_action_just_pressed('up'):
				velocity.y = JUMP_HEIGHT
		else:
			animatedSprite.play("jump")
	
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity, UP)


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.get_animation() == "roll":
		print("_on_AnimatedSprite_animation_finished")
		animatedSprite.play("idle")
		rolling = false
