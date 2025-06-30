extends PlayerStateGravityBase

func 	on_physics_process(delta):
	player.velocity.x=0
	if player.velocity.x < 0 and player.is_on_floor(): 
		state_machine.change_to(player.states.Move)
		
	if controlled_node.velocity.y > 0:
		state_machine.change_to(player.states.Fall)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	if Input.get_action_strength("left") or Input.get_action_strength("right"):
		state_machine.change_to(player.states.Move)
	elif Input.is_action_just_pressed("jump"):
			state_machine.change_to(player.states.Jump)
###
###
