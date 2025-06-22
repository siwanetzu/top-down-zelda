class_name AttackState extends State

var time_since_last_attack = 0.0

func enter():
	# When entering the attack state, stop moving and check the attack cooldown.
	character.velocity = Vector2.ZERO
	time_since_last_attack = 0.0
	_attack()

func update(delta: float):
	time_since_last_attack += delta
	# After the attack cooldown, decide the next state.
	if time_since_last_attack >= character.attack_cooldown:
		_determine_next_state()

func _attack():
	# Play the attack animation and deal damage.
	if character.animated_sprite.sprite_frames.has_animation("attack"):
		character.animated_sprite.play("attack")
	
	if character.player and character.player.has_method("take_damage"):
		character.player.take_damage(character.damage)

func _determine_next_state():
	# If the player is still in attack range, attack again.
	if character.player and character.global_position.distance_to(character.player.global_position) <= character.attack_range:
		character.state_machine.transition_to("AttackState")
	# If the player is out of attack range, chase them.
	elif character.player and character.global_position.distance_to(character.player.global_position) > character.attack_range:
		character.state_machine.transition_to("ChaseState")
	# Otherwise, go back to idle.
	else:
		character.state_machine.transition_to("IdleState")