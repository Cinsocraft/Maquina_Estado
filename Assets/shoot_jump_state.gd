extends PlayerStateGravityBase

func 	on_physics_process(delta):
	#region Movimiento
	controlled_node.movement_stats.input_direction  = Input.get_axis("left", "right") * controlled_node.movement_stats.move_speed
	controlled_node.movement_stats.target_speed = controlled_node.movement_stats.input_direction * controlled_node.movement_stats.move_speed
	
	if controlled_node.movement_stats.input_direction != 0:
		controlled_node.velocity.x = move_toward(controlled_node.velocity.x,controlled_node.movement_stats.target_speed,controlled_node.movement_stats.acceleration_speed * delta)
		if controlled_node.velocity.x >= controlled_node.movement_stats.move_speedTop:
			controlled_node.velocity.x= controlled_node.movement_stats.move_speedTop
		elif controlled_node.velocity.x <= -controlled_node.movement_stats.move_speedTop:
			controlled_node.velocity.x= -controlled_node.movement_stats.move_speedTop
	else:
		controlled_node.velocity.x = move_toward(controlled_node.velocity.x,0,controlled_node.movement_stats.decceleration_speed * delta)
	#endregion
	###Jumper Buffer
	player.jumper_buffer.start()
	###
	#region Salto
	if controlled_node.is_on_floor() and controlled_node.velocity.y >= 0: 
		controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
	elif controlled_node.velocity.y > 0: 
		state_machine.change_to(player.states.Fall)
	#endregion
	#region Salto pared
	if player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
			state_machine.change_to(player.states.WallSlide)
	elif player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
			state_machine.change_to(player.states.WallSlide)
	#endregion
	#region Esquina de Correción
	if !player.is_on_wall():
		if player.corner_left_control.is_colliding() and not player.corner_right_control.is_colliding():
			player.global_position.x += 10
		elif !player.corner_left_control.is_colliding() and player.corner_right_control.is_colliding():
			player.global_position.x -= 10
	#endregion
	handle_gravity(delta)
	controlled_node.move_and_slide()
