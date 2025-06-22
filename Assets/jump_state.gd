extends PlayerStateGravityBase

func 	on_physics_process(delta):
	player.velocity.x = \
		Input.get_axis("left", "right") * player.movement_stats.move_speed
		
	# si esta en el suelo y esta parado sobre él, podemos darle impulso de salto
	if controlled_node.is_on_floor() and controlled_node.velocity.y >= 0: 
		controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
		
	# en otro caso, si está bajando, cambiamos al estado de cayendo
	elif controlled_node.velocity.y > 0: state_machine.change_to(player.states.Fall)
	###################
	
	
	if controlled_node.get_last_slide_collision() and controlled_node.velocity.y >= 0: 
		controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
		
	if controlled_node.is_on_floor():
		controlled_node.movement_stats.coyote_time_actived=false
	else:
		if controlled_node.coyote_timer.is_stopped():
			controlled_node.coyote_timer.start()
			controlled_node.movement_stats.coyote_time_actived=true
		
		
	
	#coyote_timer
	#coyote_time_actived
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
