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
	#region Cambio de estado
	
	
	
	if player.velocity.x < 0 and player.is_on_floor(): 
		state_machine.change_to(player.states.Move)
		
	if controlled_node.velocity.y > 0:
		state_machine.change_to(player.states.Fall)
	#endregion
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	if Input.get_action_strength("left") or Input.get_action_strength("right"):
		state_machine.change_to(player.states.Move)
	elif Input.is_action_just_pressed("jump"):
			state_machine.change_to(player.states.Jump)
	elif Input.is_action_just_pressed("Shoot"):
		controlled_node.movement_stats.can_shoot = true
		state_machine.change_to(player.states.ShootIdle)
###
###
