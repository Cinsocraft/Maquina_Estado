extends PlayerStateGravityBase

func 	on_physics_process(delta):
	controlled_node.velocity.x = Input.get_axis("left", "right") * controlled_node.movement_stats.move_speed
	
	if controlled_node.velocity.y > 0:
		state_machine.change_to(player.states.Coyote)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
	
func on_input(_event):
		if !Input.is_anything_pressed():
			state_machine.change_to(player.states.Idle)
		if Input.is_action_just_pressed("jump"):
			state_machine.change_to(player.states.Jump)
