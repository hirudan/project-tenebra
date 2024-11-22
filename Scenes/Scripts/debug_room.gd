extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interaction_triggered(id: String, message: String) -> void:
	print("Received message from interactable " + id + ":")
	print(message)

func _on_interactable_interaction_limit_reached(id: String) -> void:
	print("Interaction limit reached for interactable " + id)
