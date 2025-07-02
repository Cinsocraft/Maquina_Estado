extends PlayerStateGravityBase

func 	on_physics_process(delta):
	player.velocity.x = \
	Input.get_axis("left", "right") * player.movement_stats.move_speed
	if !player.jumper_buffer.is_stopped() and Input.is_action_pressed("jump"):
		if controlled_node.is_on_floor():
			controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
			state_machine.change_to(player.states.Fall)
	elif controlled_node.is_on_floor() or player.jumper_buffer.is_stopped():
		player.jumper_buffer.start()
		if controlled_node.velocity.y >= 0 and !Input.is_anything_pressed():
			state_machine.change_to(player.states.Idle)
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			state_machine.change_to(player.states.Move)
		if player.jumper_buffer.is_stopped():
			state_machine.change_to(player.states.Fall)
	#region Corner Correction
	if !player.is_on_wall():
		if player.corner_left_control.is_colliding() and not player.corner_right_control.is_colliding():
			player.position.x += controlled_node.movement_stats.correct_corner
		elif !player.corner_left_control.is_colliding() and player.corner_right_control.is_colliding():
			player.position.x -= controlled_node.movement_stats.correct_corner
	#endregion
	if player.is_on_wall():
		state_machine.change_to(player.states.WallSlide)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
	###
