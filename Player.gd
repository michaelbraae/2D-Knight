extends KinematicBody2D
onready var PlayerAttackBox = get_node("AttackBox")
const UP = Vector2(0, -1)
const GRAVITY = 10
const SPEED = 180
const JUMP_HEIGHT = -200
onready var animatedSprite = $AnimatedSprite
# onready var hitBox = $HitBox
var rolling = false
var attacking = false
var nextAttack = "attack1" # so we always start from the first attack

var motion = Vector2()

func _process(_delta):
	#Resets the level if the character falls too low
	if global_transform.origin.y > 260:
		get_tree().reload_current_scene()

func _physics_process(_delta):
	var speed = SPEED
	motion.y += GRAVITY
	if animatedSprite.get_animation() == "roll":
		rolling = true
		hitBox.set_process(false)
	elif attacking == true:
		animatedSprite.play("attack1")
	else:
		rolling = false
		if Input.is_action_pressed("left_click"):
			attack()
		elif Input.is_action_pressed("ui_right"):
			animatedSprite.play("run")
			animatedSprite.flip_h = false
			motion.x = SPEED
		elif Input.is_action_pressed("left"):
			animatedSprite.play("run")
			animatedSprite.flip_h = true
			motion.x = -SPEED
		else:
			animatedSprite.play("idle")
			motion.x = 0
				
		if Input.is_action_pressed("roll"):
				animatedSprite.play("roll")
		
	if is_on_floor():
		if Input.is_action_just_pressed('up'):
			motion.y = JUMP_HEIGHT
	else:
		attacking = false
		animatedSprite.play("jump")
		
	motion = move_and_slide(motion, UP)
	pass

func attack():
	attacking = true
	if animatedSprite.flip_h:
		motion.x = -SPEED / 7
	else:
		motion.x = SPEED / 7

func _on_AnimatedSprite_animation_finished():
	if animatedSprite.get_animation() == "roll":
		animatedSprite.play("idle")
		rolling = false
		hitBox.set_process(true)
	if animatedSprite.get_animation() == "attack1":
		animatedSprite.play("idle")
		attacking = false


func _on_AttackBox_area_entered(area):
	print(area.get_parent().printSomething())
