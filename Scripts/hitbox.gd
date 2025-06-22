extends Area2D

# The damage this specific attack deals
var damage = 1

func _ready():
	# Hit any enemies already inside the area the moment it's created
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(damage)

	# Disappear after a short time to represent a quick swing
	await get_tree().create_timer(0.3).timeout
	queue_free()

# Hit any enemies that walk into the hitbox while it's active
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
