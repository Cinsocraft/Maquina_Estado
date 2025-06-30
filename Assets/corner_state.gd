extends PlayerStateGravityBase


func on_physics_process(delta):
	player.velocity.x = \
		Input.get_axis("left", "right") * player.movement_stats.move_speed
	##Control de estados
	##Control del corrector de esquinas del personaje
	handle_gravity(delta)
	controlled_node.move_and_slide()
