extends PlayerStateGravityBase


func on_physics_process(delta):
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
	if player.movement_stats.jump_wall_actived and player.movement_stats.was_wall_R:
			controlled_node.velocity.y = player.movement_stats.wall_jumpV_force
			controlled_node.velocity.x = player.movement_stats.wall_jumpH_force
			print("Salto en pared derecha:", controlled_node.velocity)
			state_machine.change_to(player.states.Fall)
	elif player.movement_stats.jump_wall_actived and player.movement_stats.was_wall_L:
			controlled_node.velocity.y = player.movement_stats.wall_jumpV_force
			controlled_node.velocity.x = player.movement_stats.wall_jumpHL_force
			print("Salto en pared derecha:", controlled_node.velocity)
			state_machine.change_to(player.states.Fall)
	else:
		state_machine.change_to(player.states.Fall)

	if  not player.is_on_floor():
		player.velocity.y += gravity * delta
	
	if player.velocity.y >= 0 and player.is_on_floor(): 
		
		state_machine.change_to(player.states.Idle)
	if Input.get_axis("left", "right") and player.is_on_floor(): 
		
		state_machine.change_to(player.states.Move)
	if controlled_node.velocity.y > 0:
		state_machine.change_to(player.states.Fall)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
