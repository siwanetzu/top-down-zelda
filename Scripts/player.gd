class_name Player extends CharacterBody2D

const Hitbox = preload("res://hitbox.tscn")

@export var speed : float = 100.0
@export var hitbox_offset = 25
var face_direction = "Front"
var animation_to_play = "Idle"

#trying out state variable
var is_attacking = false

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	add_to_group("player")
	_animated_sprite.animation_finished.connect(_on_animation_finished)
	_animated_sprite.play(animation_to_play)
	
func _on_animation_finished():
	var anim_name = _animated_sprite.get_animation()
	
	#When attack is finishing
	if "Attack" in anim_name:
		is_attacking = false
		animation_to_play = face_direction + "_Idle"
		_animated_sprite.play(animation_to_play)
	
func _physics_process(delta: float) -> void:
	if is_attacking:
		move_and_slide()
		return
	
	# Reset velocity
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		_attack()
		return
	
	
	# Add appropriate velocities depending on button press
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0 * speed
		# Only face left/right if not diagonal movement
		if velocity.y == 0.0:
			face_direction = "Left"
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0 * speed
		# Only face left/right if not diagonal movement
		if velocity.y == 0.0:
			face_direction = "Right"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0 * speed
		face_direction = "Back"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0 * speed
		face_direction = "Front"
		
	# 1. Determine the state ("Walk" or "Idle")
	var state = "Idle"
	if velocity.length() > 0.0:
		state = "Walk"  # This MUST be on a new, indented line.
		
	# 2. Build the correct animation name
	animation_to_play = face_direction + "_" + state
	
	# 3. Only play the new animation if it's not already playing
	if _animated_sprite.animation != animation_to_play:
		_animated_sprite.play(animation_to_play)
	
	# Move character, slide at collision
	move_and_slide()

func _attack():
	is_attacking = true
	animation_to_play = face_direction + "_Attack"
	_animated_sprite.play(animation_to_play)

	var hitbox_instance = Hitbox.instantiate()
	var hitbox_position = Vector2.ZERO

	# Direction of my attacks for hitbox2d area

	match face_direction:
		"Front":
			hitbox_position = Vector2(0, hitbox_offset)
		# Using multiplier here to keep distances relative, front seems to be capturing it right
		"Back":
			hitbox_position = Vector2(0, -hitbox_offset * 0.6)
		"Left":
			hitbox_position = Vector2(-hitbox_offset * 0.6, 0)
		"Right":
			hitbox_position = Vector2(hitbox_offset * 0.6, 0)

	# We add the hitbox to the main scene tree so that it doesn't move with the player
	get_tree().current_scene.add_child(hitbox_instance)
	hitbox_instance.global_position = global_position + hitbox_position
