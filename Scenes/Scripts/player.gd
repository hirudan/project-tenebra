extends CharacterBody2D

@export var SPEED = 300.0
var direction = Vector2.RIGHT

func _ready():
	$AnimatedSprite2D.play("idle")
	
	
func _process(_delta):
	if velocity != Vector2(0, 0):
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	if Input.is_action_just_pressed("lantern_mode"):
		$Lantern.mode_switch()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction_h = Input.get_axis("move-left", "move-right")
	direction = Vector2.RIGHT * direction_h
	
	var direction_v = Input.get_axis("move-up", "move-down")
	if direction_h or direction_v:
		velocity =  Vector2(direction_h, direction_v).normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
