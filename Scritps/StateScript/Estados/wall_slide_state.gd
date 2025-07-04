extends PlayerStateGravityBase

func on_physics_process(delta):
	# Movimiento horizontal por input
	controlled_node.velocity.x = Input.get_axis("left", "right") * player.movement_stats.move_speed
	if !Input.is_action_just_pressed("jump"):
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
	if player.wall_controller_l.get_collider() and player.wall_controller_lc.get_collider():
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("jump"):
			print(player.movement_stats.jump_wall_actived)
			state_machine.change_to(player.states.WallJump)
	elif  player.wall_controller_r.get_collider() and player.wall_controller_rc.get_collider():
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("jump"):
			print(player.movement_stats.jump_wall_actived)
			state_machine.change_to(player.states.WallJump)
		
