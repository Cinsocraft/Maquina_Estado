extends PlayerStateGravityBase


func on_physics_process(delta):	
	player.velocity.x = \
		Input.get_axis("left", "right") * player.movement_stats.move_speed
	
	if player.velocity.y >= 0 and player.is_on_floor(): 
			state_machine.change_to(player.states.Idle)
	
	if Input.get_axis("left", "right") and player.is_on_floor(): 
			state_machine.change_to(player.states.Move)
	
	handle_gravity(delta)
	controlled_node.move_and_slide()
###
func on_input(_event):
	###
	if Input.is_action_just_pressed("jump"):
		if player.buffer_control.get_collider() and !player.jumper_buffer.is_stopped():
			state_machine.change_to(player.states.Buffer)
	###
