extends CanvasLayer

# This will hold a reference to the player node
var player = null

@onready var health_label = $Label

func _ready():
	# Find the player in the scene tree
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]
		# Connect to the player's health_changed signal (we'll create this next)
		if player.has_signal("health_changed"):
			player.health_changed.connect(_on_player_health_changed)
			# Update the label with the initial health
			_on_player_health_changed(player.health)

func _on_player_health_changed(new_health):
	health_label.text = "Health: " + str(new_health)
