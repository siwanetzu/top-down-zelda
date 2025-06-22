class_name EnemyBase extends CharacterBody2D

# --- STATS ---
@export var speed = 75.0
@export var attack_range = 30.0
@export var health = 3
@export var damage = 1
@export var attack_cooldown = 1.0
var is_dying = false

# --- REFERENCES ---
var player = null
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine

func _ready():
	add_to_group("enemies")
	
	# Find the player
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]
		
	# Setup detection area
	var detection_area = get_node("DetectionArea")
	if detection_area:
		# The detection area should not be on a layer that something can collide with
		detection_area.collision_layer = 0
		# The detection area should ONLY look for things on the player's layer (2)
		detection_area.collision_mask = 2
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		detection_area.body_exited.connect(_on_detection_area_body_exited)

func _process(delta):
	if state_machine.current_state:
		state_machine.current_state.update(delta)

func _physics_process(delta):
	if state_machine.current_state:
		state_machine.current_state.physics_update(delta)
	move_and_slide()

# --- SIGNALS ---
func _on_detection_area_body_entered(body):
	if is_dying:
		return
	if body.is_in_group("player"):
		state_machine.transition_to("ChaseState")

func _on_detection_area_body_exited(body):
	if is_dying:
		return
	if body.is_in_group("player"):
		state_machine.transition_to("IdleState")

# --- ACTIONS ---
func take_damage(amount):
	if is_dying:
		return
	health -= amount
	if health <= 0:
		is_dying = true
		die()

func die():
	# Stop the enemy from moving and being interacted with
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)

	# Play the death animation if it exists
	if animated_sprite.sprite_frames.has_animation("death"):
		# Ensure the death animation doesn't loop, so 'animation_finished' is emitted.
		animated_sprite.sprite_frames.set_animation_loop("death", false)
		animated_sprite.play("death")
		animated_sprite.animation_finished.connect(_on_death_animation_finished)
	else:
		# If there's no death animation, spawn loot and queue for deletion immediately.
		_spawn_loot()
		queue_free()

func _on_death_animation_finished():
	_spawn_loot()
	# Now it's safe to remove the enemy
	queue_free()

func _spawn_loot():
	# Spawn loot
	var loot_scene = preload("res://loot.tscn")
	var loot_instance = loot_scene.instantiate()
	get_parent().add_child(loot_instance)
	loot_instance.global_position = global_position
