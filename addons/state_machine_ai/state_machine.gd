class_name StateMachine extends Node

# The state that is currently active
var current_state: State

# A dictionary of all the states this machine can be in.
# The keys are the state names (e.g., "idle", "chase")
# The values are the state nodes themselves.
var states: Dictionary = {}

# The initial state the machine should start in.
@export var initial_state: State


func _ready():
	# Get all child nodes that are states and add them to the dictionary
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# Set the character reference for each state
			child.character = get_parent()

	# Start in the initial state
	if initial_state:
		current_state = initial_state
		current_state.enter()


func _process(delta):
	if current_state:
		current_state.update(delta)


# This function changes the current state to a new one.
func transition_to(state_name: String):
	var lower_state_name = state_name.to_lower()
	# First, check if the requested state exists
	if not states.has(lower_state_name):
		return

	var new_state = states[lower_state_name]

	# Don't transition to the same state
	if current_state == new_state:
		return

	# Call the exit function on the current state
	if current_state:
		current_state.exit()

	# Set the new state and call its enter function
	current_state = new_state
	if current_state:
		current_state.enter()