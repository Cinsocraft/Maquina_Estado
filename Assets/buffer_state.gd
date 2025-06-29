extends PlayerStateGravityBase

func 	on_physics_process(delta):
	player.velocity.x = \
	Input.get_axis("left", "right") * player.movement_stats.move_speed
	###
	if !controlled_node.is_on_floor() and controlled_node.velocity.y >= 0: 
		if player.jumper_buffer.is_stopped():
			state_machine.change_to(player.states.Fall)
		if !player.jumper_buffer.is_stopped() and Input.get_action_strength("jump"):
			controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
	
	if controlled_node.is_on_floor() and controlled_node.velocity.y >= 0:
		state_machine.change_to(player.states.Idle)
	handle_gravity(delta)
	controlled_node.move_and_slide()
	###
func on_input(_event):
	###
	if Input.get_action_strength("left") or Input.get_action_strength("right") and controlled_node.is_on_floor():
		state_machine.change_to(player.states.Move)
	###
