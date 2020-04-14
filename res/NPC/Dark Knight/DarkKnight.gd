extends KinematicBody2D

var health = 10
const GRAVITY = 1
export (int) var speed = 200
const UP = Vector2(0, -1)
var velocity = Vector2()
var player_detected = false
onready var animatedSprite = $AnimatedSprite
onready var healthSprite = $HealthSprite
var hit = false

func takeHit(damage):
	hit = true
	health = health - damage
	if health < 0:
		health = 0
	if health > 0:
		animatedSprite.play("takehit")
	else:
		animatedSprite.play("death")

func _process(_delta):
	healthSprite.play(str(health))

func _physics_process(_delta):
	velocity = Vector2()
	velocity.y += GRAVITY
	if not hit:
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

func _on_AnimatedSprite_animation_finished():
	var animation = animatedSprite.get_animation()
	if animation == "takehit":
		hit = false
	elif animation == "death":
		queue_free()
