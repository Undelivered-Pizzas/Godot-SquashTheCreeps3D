extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random locaiton on the SpawnPath and store its reference
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# randf() produces a number between 0 and 1, which is what the Path Follow
	# node's expect: 0 is the start of the path and 1 is the end of it.
	mob_spawn_location.progress_ratio = randf()
	
	# Get the player's actual position and call initialize method on Mob's
	# scene
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawn the Mob by adding it to the Main scene
	add_child(mob)
	
	# We connect the Mob to the ScoreLabel to update the score
	# When the mob emits the squashed signal, the ScoreLabel will receive it
	# and will call _on_mob_squashed()
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if $UserInterface/Retry.visible and event.is_action_pressed("ui_accept"):
		# Restart the current scene
		get_tree().reload_current_scene()
