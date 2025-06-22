class_name IdleState extends State

func enter():
	# When entering the idle state, the character should stop moving
	# and play its idle animation.
	character.velocity = Vector2.ZERO
	if character.animated_sprite.sprite_frames.has_animation("idle"):
		character.animated_sprite.play("idle")