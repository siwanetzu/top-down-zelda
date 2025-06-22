class_name State extends Node

# A reference to the character this state belongs to (e.g., the bat)
var character = null

# This function is called when the state is first entered.
func enter():
	pass

# This function is called when the state is exited.
func exit():
	pass

# This function is called every frame by the state machine.
# It's where the state's logic will run (e.g., moving, checking for attacks).
func update(delta: float):
	pass

# This function is for physics-based updates.
func physics_update(delta: float):
	pass