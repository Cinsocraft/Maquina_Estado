extends PlayerStateGravityBase

#coyote_timer
#coyote_time_actived

func 	on_physics_process(delta):
	player.velocity.x = \
	Input.get_axis("left", "right") * player.movement_stats.move_speed
	
	# si esta en el suelo y esta parado sobre él, podemos darle impulso de salto
	if !player.coyote_control.get_collider() and controlled_node.velocity.y >= 0: 
		if player.movement_stats.coyote_time_actived:
			player.movement_stats.coyote_time_actived=false
			controlled_node.coyote_timer.stop()
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
		elif player.is_on_wall():
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
