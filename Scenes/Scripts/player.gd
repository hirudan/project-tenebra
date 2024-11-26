extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var INTERACT_DIST: int = 48
var direction = Vector2.DOWN
var directions = ["e", "s", "w", "n"] # Unit circle; 0 is east

func _ready():
	$AnimatedSprite2D.play("idle_s")

func _process(_delta):
	if Input.is_action_just_pressed("lantern_mode"):
		$Lantern.mode_switch()

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	var direction_h = Input.get_axis("move-left", "move-right")
	var direction_v = Input.get_axis("move-up", "move-down")
	if direction_h or direction_v:
		velocity =  Vector2(direction_h, direction_v).normalized() * SPEED
		direction = Vector2(direction_h, direction_v)
		var animation = "walk_" + dir2str(direction)
		if $AnimatedSprite2D.animation != animation:
			$AnimatedSprite2D.play(animation)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		var animation = "idle_" + dir2str(direction)
		if $AnimatedSprite2D.animation != animation:
			$AnimatedSprite2D.play(animation)

	move_and_slide()
	
	var angle = direction.angle()
	$Interactor.set_target_position(Vector2(INTERACT_DIST * cos(angle), INTERACT_DIST * sin(angle)))
	
	# Handle interactions with interactable objects
	if Input.is_action_just_pressed("Interact"):
		interact()
	
func interact():
	# The interactor raycast only interacts with objects on collision layer 4,
	# i.e. interactables. 
	# The interactor is half the size of this sprite, so it can only hit stuff 
	# the player is adjacent to
	var interactable = $Interactor.get_collider()
	if not interactable:
		return
	(interactable as Interactable).interact()
	
func dir2str(direction: Vector2):
	var angle = direction.angle()
	if angle < 0:
		angle += 2 * PI
	var index = round(angle / (PI / 2))
	return directions[index]
