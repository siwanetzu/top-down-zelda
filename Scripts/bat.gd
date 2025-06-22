class_name Bat extends EnemyBase

# The Bat script now inherits all the functionality from the EnemyBase class
# which is part of your new State Machine AI plugin.
# You can add any bat-specific logic here in the future.

func _ready():
	# Call the parent's ready function to ensure all the base setup is done.
	super()
	
	# Any bat-specific ready logic can go here.
	animated_sprite.play("idle")
