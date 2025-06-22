class_name Bat extends CharacterBody2D

# You can adjust this speed for each enemy in the Inspector
@export var speed = 75.0
@export var attack_range = 30
@export var health = 3
@export var damage = 1
@export var attack_cooldown = 1.0

var time_since_last_attack = 0.0
# This will act as the switch to turn chasing on and off
var is_chasing = false
# This will hold a reference to the player node
var player = null

@onready var _animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	add_to_group("enemies")
	# Let's make it start with an idle animation
	$AnimatedSprite2D.play("idle") # Assumes you have an "idle" animation
	
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]


# _physics_process is called every physics frame. Ideal for movement.
func _physics_process(delta):
	time_since_last_attack += delta
	# We only run our chase/attack logic if is_chasing is true.
	if is_chasing and player:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player <= attack_range:
			# Player is in attack range, stop and attack
			velocity = Vector2.ZERO
			if time_since_last_attack >= attack_cooldown:
				attack()
		else:
			# Player is in chase range, but not attack range. Move towards them.
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			$AnimatedSprite2D.play("walk") # Assumes you have a "walk" animation
	else:
		# Player is outside the detection area. Stop moving.
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")
		
	move_and_slide()

func attack():
	time_since_last_attack = 0.0
	$AnimatedSprite2D.play("attack") # Assumes you have an "attack" animation
	if player and player.has_method("take_damage"):
		player.take_damage(damage)


# This function is called automatically when a body enters the DetectionArea
func _on_detection_area_body_entered(body):
	# Check if the body that entered is the player (by checking its group)
	if body.is_in_group("player"):
		is_chasing = true


# This function is called automatically when a body exits the DetectionArea
func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		is_chasing = false

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
