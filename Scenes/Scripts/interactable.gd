extends Area2D

@export var debug: bool = false
@export var interact_limit_ct: int = -1
@export var trigger_on_player_touch: bool = false
@export var trigger_on_enemy_touch: bool = false
@export var repeat_last_action_on_limit_met = false
@export var messages: Array = []
@export var id: String

var interactions: int = 0

const PLAYER_COLLISION_LAYER: int = 2
const ENEMY_COLLISION_LAYER: int = 3

signal interaction_triggered
signal interaction_limit_reached

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !debug:
		$Sprite2D.hide()
	if trigger_on_enemy_touch || trigger_on_player_touch:
		self.body_entered.connect(_on_body_entered)
	if messages:
		interact_limit_ct = len(messages)
	# Sanity check that we define an interaction limit if we expect looping behavior
	assert((repeat_last_action_on_limit_met) == (interact_limit_ct > 0) or (repeat_last_action_on_limit_met) == (len(messages) > 0))

func _on_body_entered(node: Node2D):
	if (trigger_on_enemy_touch && node.collision_layer == ENEMY_COLLISION_LAYER) || \
	(trigger_on_player_touch && node.collision_layer == PLAYER_COLLISION_LAYER):
		interact()
		
func increment_interactions():
	if interact_limit_ct > 0 && interactions < interact_limit_ct:
		interactions += 1
		if interactions == interact_limit_ct:
			interaction_limit_reached.emit(id)
	elif interact_limit_ct < 0:
		interactions += 1
			
func reset_interact_ct():
	interactions = 0

func interact() -> void:
	increment_interactions()
	# If this item is supposed to loop its final message and we've hit the interaction limit, 
	# publish the final text in messages, else pull the proper message in the sequence
	var message: String
	if messages:
		message = messages[-1] if (repeat_last_action_on_limit_met && interactions >= interact_limit_ct) else messages[interactions % len(messages)]
	interaction_triggered.emit(id, message if message else "")
