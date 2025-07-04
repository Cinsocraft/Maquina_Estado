extends PlayerStateGravityBase


func on_physics_process(delta):
	player.velocity.x = \
		Input.get_axis("left", "right") * player.movement_stats.move_speed
	if !player.jumper_buffer.is_stopped():
		state_machine.change_to(player.states.Buffer)
	if player.velocity.y >= 0 and player.is_on_floor(): 
			state_machine.change_to(player.states.Idle)
	if Input.get_axis("left", "right") and player.is_on_floor(): 
			state_machine.change_to(player.states.Move)
	
	if player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
			state_machine.change_to(player.states.WallSlide)
	elif player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
			state_machine.change_to(player.states.WallSlide)
	handle_gravity(delta)
	controlled_node.move_and_slide()
