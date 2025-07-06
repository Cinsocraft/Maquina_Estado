extends PlayerStateGravityBase

#coyote_timer
#coyote_time_actived


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
	# si esta en el suelo y esta parado sobre él, podemos darle impulso de salto
	if !player.coyote_control.get_collider() and controlled_node.velocity.y >= 0: 
		if player.movement_stats.coyote_time_actived:
			player.movement_stats.coyote_time_actived=false
			controlled_node.coyote_timer.stop()
			state_machine.change_to(player.states.Fall)
	else:
		if player.movement_stats.coyote_time_actived:
			controlled_node.coyote_timer.start()
			player.movement_stats.coyote_time_actived=true
	
	#region Cambio de State
	if player.coyote_control.get_collider():
		if !Input.is_anything_pressed():
			state_machine.change_to(player.states.Idle)
		elif Input.get_action_strength("left") or Input.get_action_strength("right"):
			state_machine.change_to(player.states.Move)
	if player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
			state_machine.change_to(player.states.WallSlide)
	elif player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
			state_machine.change_to(player.states.WallSlide)
	#endregion
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	##Input Coyote
	if Input.is_action_just_pressed("jump") :
			controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
			controlled_node.coyote_timer.stop()
			player.movement_stats.coyote_time_actived=true
			state_machine.change_to(player.states.Fall)
