extends KinematicBody2D

const GRAVITY = 10
const UP = Vector2(0, -1)
const SPEED = 100

var motion = Vector2()

var health = 10
var player_detected = false
var hit = false
var direction = 1
var sightCastToY = 250

onready var animatedSprite = $AnimatedSprite
onready var healthSprite = $HealthSprite
onready var ledgeRayCast = $LedgeRayCast
onready var sightRayCast = $SightRayCast
onready var Player = get_node("Player")

func takeHit(damage):
	player_detected = true
	hit = true
	health = health - damage
	if health < 0:
		health = 0
	if health > 0:
		animatedSprite.play("takehit")
	else:
		animatedSprite.play("death")

func bounceOffWallsAndLedges():
	if is_on_wall():
		direction = direction * -1
		ledgeRayCast.position.x *= -1
		sightCastToY = sightCastToY * -1
		
	if ledgeRayCast.is_colliding() == false:
		sightCastToY = sightCastToY * -1
		direction = direction * -1
		ledgeRayCast.position.x *= -1
	sightRayCast.set_cast_to(Vector2(0, sightCastToY))

func _process(_delta):
	healthSprite.play(str(health))

func attack():
	pass

func _physics_process(_delta):
	motion.y += GRAVITY
	motion.x = SPEED * direction
	if not hit:
		if motion.x > 0:
			animatedSprite.flip_h = false
			animatedSprite.play("run")
		elif motion.x < 0:
			animatedSprite.flip_h = true
			animatedSprite.play("run")
		else:
			animatedSprite.play("idle")
	
	if not is_on_floor():
		animatedSprite.play("fall")
	
	motion = motion.normalized() * SPEED
	motion = move_and_slide(motion, UP)
	
	bounceOffWallsAndLedges()
	
	if sightRayCast.is_colliding():
		var collidingObject = sightRayCast.get_collider()
		if collidingObject.has_method("isPlayer"):
			player_detected = true

func _on_AnimatedSprite_animation_finished():
	var animation = animatedSprite.get_animation()
	if animation == "takehit":
		hit = false
	elif animation == "death":
		queue_free()
