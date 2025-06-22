extends PlayerStateGravityBase

#coyote_timer
#coyote_time_actived

func 	on_physics_process(delta):
	player.velocity.x = \
	Input.get_axis("left", "right") * player.movement_stats.move_speed
	
	# si esta en el suelo y esta parado sobre él, podemos darle impulso de salto
	if controlled_node.is_on_floor() and controlled_node.velocity.y >= 0: 
		if player.movement_stats.coyote_time_actived:
			player.movement_stats.coyote_time_actived=false
			controlled_node.coyote_timer.stop()
	else:
		if player.movement_stats.coyote_time_actived:
			controlled_node.coyote_timer.start()
			player.movement_stats.coyote_time_actived=true
	
	if controlled_node.coyote_timer.is_stopped():
		state_machine.change_to(player.states.Fall)
		
	handle_gravity(delta)
	controlled_node.move_and_slide()
	
func on_input(_event):
	if Input.is_action_just_pressed("jump") and (!controlled_node.coyote_timer.is_stopped() or controlled_node.is_on_floor()):
				controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
				controlled_node.coyote_timer.stop()
				player.movement_stats.coyote_time_actived=true
				state_machine.change_to(player.states.Fall)
