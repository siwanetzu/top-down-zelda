class_name Bat extends CharacterBody2D

# You can adjust this speed for each enemy in the Inspector
@export var speed = 75.0
@export var attack_range = 30
@export var health = 3
@export var damage = 1
@export var attack_cooldown = 1.0

# This will hold a reference to the player node
var player = null

@onready var _animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var state_machine = $StateMachine

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	add_to_group("enemies")
	# Let's make it start with an idle animation
	$AnimatedSprite2D.play("idle") # Assumes you have an "idle" animation
	
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]
		
	
	var detection_area = get_node("DetectionArea")
	if detection_area:
		# DetectionArea should not be on any layer
		detection_area.collision_layer = 0
		# DetectionArea should ONLY look for the player on layer 2 (value 2)
	detection_area.collision_mask = 2
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)

func _on_detection_area_body_entered(body):
	print("Detection Body Entered signal working")
	if body.is_in_group("player"):
		print("body is in the group player")
		state_machine.transition_to("ChaseState")
		print ("Transitioning to Chase State")

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		state_machine.transition_to("IdleState")
func _process(delta):
	if state_machine.current_state:
		state_machine.current_state.update(delta)
# _physics_process now gets the state's logic first, then moves.
func _physics_process(delta):
	if state_machine.current_state:
		state_machine.current_state.physics_update(delta)
	move_and_slide()

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# Stop the bat from moving and being interacted with
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)

	# Play the death animation
	$AnimatedSprite2D.play("death")
	
	# Wait for the animation to finish, then remove the bat
	await $AnimatedSprite2D.animation_finished
	queue_free()
