extends PlayerStateGravityBase

#controlled_node.movement_stats.
#@export var coyote_time_actived = false
#@export var was_on_ground: bool = false
#player.
#@export var is_on_ground = coyote_control_l.is_colliding() and coyote_control_r.is_colliding()

func 	on_physics_process(delta):
	var is_on_ground = player.coyote_control_l.is_colliding() and player.coyote_control_r.is_colliding()
	#region
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
	#endregion

	if is_on_ground:
		player.movement_stats.coyote_time_actived = false
	else:
		player.movement_stats.coyote_time_actived = true
	controlled_node.movement_stats.was_on_ground = is_on_ground
	# Cambio de estado si el Coyote Time expira
	if player.movement_stats.coyote_time_actived and controlled_node.coyote_timer.time_left <=0:
		player.movement_stats.coyote_time_actived = false
		state_machine.change_to(player.states.Fall)
	#region Cambio de State
	if is_on_ground:
		if !Input.is_anything_pressed():
			state_machine.change_to(player.states.Idle)
		elif Input.get_action_strength("left") or Input.get_action_strength("right"):
			state_machine.change_to(player.states.Move)
	elif !is_on_ground:
		if player.movement_stats.coyote_time_actived and controlled_node.coyote_timer.time_left <=0:
			state_machine.change_to(player.states.Fall)
		elif Input.is_action_pressed("Shoot"):
			state_machine.change_to(player.states.ShootFall)
	if player.wall_controller_r.is_colliding() and player.wall_controller_rc.is_colliding():
			state_machine.change_to(player.states.WallSlide)
	elif player.wall_controller_l.is_colliding() and player.wall_controller_lc.is_colliding():
			state_machine.change_to(player.states.WallSlide)
	#endregion
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	##Input Coyote
	var is_on_ground = player.coyote_control_l.is_colliding() and player.coyote_control_r.is_colliding()
	if Input.is_action_just_pressed("jump"):
		if player.movement_stats.coyote_time_actived:
				print("Linea 64")
				controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
				player.movement_stats.coyote_time_actived=false
				print("Coyote Time iniciado →", controlled_node.coyote_timer.time_left, "s")
				controlled_node.coyote_timer.stop()
				state_machine.change_to(player.states.Fall)
