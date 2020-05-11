extends KinematicBody2D
onready var PlayerAttackBox = get_node("AttackBox")
const UP = Vector2(0, -1)
const GRAVITY = 10
const SPEED = 180
const JUMP_HEIGHT = -200
onready var animatedSprite = $AnimatedSprite
onready var attackBox = $AttackBox
var doubleJumped = false
onready var attackBoxOriginX = attackBox.position.x

# onready var hitBox = $HitBox
var rolling = false
var attacking = false
var nextAttack = "attack1" # so we always start from the first attack
var direction = 1
var motion = Vector2()

func _process(_delta):
	#Resets the level if the character falls too low
	if global_transform.origin.y > 260:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func getMotion():
	rolling = false
	motion.x = SPEED * direction
	if Input.is_action_pressed("left_click"):
		attack()
	elif Input.is_action_pressed("ui_right"):
		
		direction = 1
		animatedSprite.position.x = 0
		attackBox.position.x = 42
		animatedSprite.play("run")
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		direction = -1
		animatedSprite.position.x = 18
		attackBox.position.x = -23
		animatedSprite.play("run")
		animatedSprite.flip_h = true
	else:
		animatedSprite.play("idle")
		motion.x = 0
	
func _physics_process(_delta):
	motion.y += GRAVITY
	if animatedSprite.get_animation() == "roll":
		rolling = true
	elif attacking == true:
		animatedSprite.play("attack1")
	else:
		getMotion()	
		if Input.is_action_pressed("roll"):
				animatedSprite.play("roll")
		
	if is_on_floor():
		doubleJumped = false
		if Input.is_action_just_pressed('up'):
			motion.y = JUMP_HEIGHT
	else:
		if doubleJumped and rolling:
			animatedSprite.play("roll")
		elif Input.is_action_just_pressed('up') and not doubleJumped:
			animatedSprite.play("roll")
			rolling = true
			doubleJumped = true
			motion.y = JUMP_HEIGHT
		else:
			rolling = false
			attacking = false
			animatedSprite.play("jump")
		
	motion = move_and_slide(motion, UP)

func attack():
	var overlappingAreas = PlayerAttackBox.get_overlapping_areas()
	if not attacking and overlappingAreas:
		for area in overlappingAreas:
			area.get_parent().takeHit(3)
	attacking = true
	if animatedSprite.flip_h:
		# warning-ignore:integer_division
		motion.x = -SPEED / 2
	else:
		# warning-ignore:integer_division
		motion.x = SPEED / 2

func _on_AnimatedSprite_animation_finished():
	animatedSprite.play("idle")
	rolling = false
	attacking = false

func isPlayer():
	pass
