extends PlayerStateGravityBase

func on_physics_process(delta):
	# Movimiento horizontal por input
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
	if player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider() or player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
		controlled_node.velocity.y = player.movement_stats.wall_slide_speed * delta
		player.movement_stats.jump_wall_actived=true
		# Salto en pared derecha → hacia la izquierda
		if player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
			player.movement_stats.jump_wall_actived=true
			player.movement_stats.was_wall_R = true
			player.movement_stats.was_wall_L = false
		elif player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
			player.movement_stats.jump_wall_actived=true
			player.movement_stats.was_wall_R = false
			player.movement_stats.was_wall_L = true
		else:
			player.movement_stats.jump_wall_actived=false
			player.movement_stats.was_wall_R = false
			player.movement_stats.was_wall_L = false
	# Aplicar gravedad
	if not player.is_on_floor():
		controlled_node.velocity.y += gravity * delta
	# Transiciones de estado
	if !player.wall_controller_r.get_collider() and not player.wall_controller_rc.get_collider() and !player.wall_controller_l.get_collider() and not player.wall_controller_lc.get_collider():
		if controlled_node.velocity.y >= 0 and player.is_on_floor():
			state_machine.change_to(player.states.Idle)
		elif Input.get_axis("left", "right") and player.is_on_floor():
			state_machine.change_to(player.states.Move)
		elif controlled_node.velocity.y > 0:
			state_machine.change_to(player.states.Fall)

	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	if Input.is_action_just_pressed("jump") and player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
		controlled_node.velocity.x = player.movement_stats.wall_jumpHL_force
		state_machine.change_to(player.states.Fall)
	elif Input.is_action_just_pressed("jump") and player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
		controlled_node.velocity.x = player.movement_stats.wall_jumpH_force
		state_machine.change_to(player.states.Fall)
	if player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
		if Input.is_action_just_pressed("right"):
			print(player.movement_stats.jump_wall_actived)
			state_machine.change_to(player.states.WallJump)
	elif  player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
		if Input.is_action_just_pressed("left"):
			print(player.movement_stats.jump_wall_actived)
			state_machine.change_to(player.states.WallJump)
		
