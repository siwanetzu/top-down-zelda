@tool
extends EditorPlugin

const State = preload("res://addons/state_machine_ai/state.gd")
const StateMachine = preload("res://addons/state_machine_ai/state_machine.gd")
const EnemyBase = preload("res://addons/state_machine_ai/enemy_base.gd")
const IdleState = preload("res://addons/state_machine_ai/states/idle_state.gd")
const ChaseState = preload("res://addons/state_machine_ai/states/chase_state.gd")
const AttackState = preload("res://addons/state_machine_ai/states/attack_state.gd")

func _enter_tree():
	# Add custom types to Godot's class system
	add_custom_type("State", "Node", State, null)
	add_custom_type("StateMachine", "Node", StateMachine, null)
	add_custom_type("EnemyBase", "CharacterBody2D", EnemyBase, null)
	add_custom_type("IdleState", "State", IdleState, null)
	add_custom_type("ChaseState", "State", ChaseState, null)
	add_custom_type("AttackState", "State", AttackState, null)

func _exit_tree():
	# Clean up when the plugin is disabled
	remove_custom_type("State")
	remove_custom_type("StateMachine")
	remove_custom_type("EnemyBase")
	remove_custom_type("IdleState")
	remove_custom_type("ChaseState")
	remove_custom_type("AttackState")