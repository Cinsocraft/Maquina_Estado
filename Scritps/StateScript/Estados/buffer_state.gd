extends PlayerStateGravityBase

func 	on_physics_process(delta):
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
	if !player.jumper_buffer.is_stopped() and Input.is_action_pressed("jump"):
		if controlled_node.buffer_control.is_colliding():
			if controlled_node.is_on_floor():
				controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
				state_machine.change_to(player.states.Fall)
	elif controlled_node.buffer_control.is_colliding() or player.jumper_buffer.is_stopped():
		player.jumper_buffer.start()
		if controlled_node.velocity.y >= 0 and !Input.is_anything_pressed():
			state_machine.change_to(player.states.Idle)
		elif Input.is_anything_pressed() and controlled_node.velocity.y >= 0:
			state_machine.change_to(player.states.Move)
		elif player.jumper_buffer.is_stopped():
			state_machine.change_to(player.states.Fall)
	#region Corner Correction
	if !player.is_on_wall():
		if player.corner_left_control.is_colliding() and not player.corner_right_control.is_colliding():
			player.global_position.x += 10
		elif !player.corner_left_control.is_colliding() and player.corner_right_control.is_colliding():
			player.global_position.x -= 10
	#endregion

	if player.wall_controller_r.is_colliding() and player.wall_controller_rc.is_colliding():
			state_machine.change_to(player.states.WallSlide)
	elif player.wall_controller_l.is_colliding() and player.wall_controller_lc.is_colliding():
			state_machine.change_to(player.states.WallSlide)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
	###

func on_input(_event):
	if Input.is_action_pressed("Shoot") and player.power_shoot_actived==true:
		controlled_node.movement_stats.can_shoot = true
		state_machine.change_to(player.states.ShootBuffer)
