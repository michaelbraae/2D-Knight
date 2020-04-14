extends KinematicBody2D

const GRAVITY = 1
export (int) var speed = 200
const UP = Vector2(0, -1)
var velocity = Vector2()
var player_detected = false
onready var animatedSprite = $AnimatedSprite
var hit = false

func setHit(wasHit):
	hit = wasHit

func printSomething():
	print("FROM DARKKNIGHT")

func _physics_process(_delta):
	velocity = Vector2()
	velocity.y += GRAVITY
	if hit:
		animatedSprite.play("takehit")
	else:
		if velocity.x > 0:
			animatedSprite.flip_h = false
			animatedSprite.play("run")
		elif velocity.x < 0:
			animatedSprite.flip_h = true
			animatedSprite.play("run")
		else:
			animatedSprite.play("idle")
	
	if not is_on_floor():
		animatedSprite.play("fall")
	
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity, UP)

