extends PlayerStateGravityBase

func 	on_physics_process(delta):
	player.velocity.x = \
	Input.get_axis("left", "right") * player.movement_stats.move_speed
	###
	player.jumper_buffer.start()
	###
	# si esta en el suelo y esta parado sobre él, podemos darle impulso de salto
	if controlled_node.is_on_floor() and controlled_node.velocity.y >= 0: 
		controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
	elif controlled_node.velocity.y > 0: 
		state_machine.change_to(player.states.Fall)
	
	if !player.is_on_wall():
		if player.corner_left_control.is_colliding() and not player.corner_right_control.is_colliding():
			player.position.x += controlled_node.movement_stats.correct_corner
		elif !player.corner_left_control.is_colliding() and player.corner_right_control.is_colliding():
			player.position.x -= controlled_node.movement_stats.correct_corner
	
	if player.is_on_wall():
		state_machine.change_to(player.states.WallSlide)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
