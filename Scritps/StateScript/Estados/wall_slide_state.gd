extends PlayerStateGravityBase


func on_physics_process(delta):
	player.velocity.x = \
		Input.get_axis("left", "right") * player.movement_stats.move_speed
	if  player.is_on_wall_only():
		player.velocity.y = player.movement_stats.wall_slide_speed *	delta
	elif  not player.is_on_floor():
		player.velocity.y += gravity * delta
	
	if !player.is_on_wall_only():
		if player.velocity.y >= 0 and player.is_on_floor(): 
				state_machine.change_to(player.states.Idle)
		if Input.get_axis("left", "right") and player.is_on_floor(): 
				state_machine.change_to(player.states.Move)
		if controlled_node.velocity.y > 0:
			state_machine.change_to(player.states.Fall)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
