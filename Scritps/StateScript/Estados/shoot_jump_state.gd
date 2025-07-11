extends PlayerStateGravityBase

func on_process(delta):
	if controlled_node.movement_stats.can_shoot:
		controlled_node.movement_stats.can_shoot=false
		var bulletnode=player.bullet.instantiate() as Node2D
		bulletnode.global_position = player.shoot_point.global_position
		var bullet_direction: Vector2
		get_parent().add_child(bulletnode)
		
		if player.body.scale.x > 0:
			bulletnode.direction = Vector2(2,0)
			bulletnode.rotation_degrees = 0
			
		else:
			bulletnode.direction = Vector2(-2,0)
			bulletnode.rotation_degrees = 180

func 	on_physics_process(delta):
	#region Movimiento
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
	#endregion
	###Jumper Buffer
	player.jumper_buffer.start()
	###
	#region Salto
	if controlled_node.is_on_floor() and controlled_node.velocity.y >= 0: 
		controlled_node.velocity.y = controlled_node.movement_stats.jump_speed
	elif controlled_node.velocity.y > 0: 
		if Input.is_action_just_pressed("Shoot"):
			state_machine.change_to(player.states.ShootFall)
		
	#endregion
	#region Salto pared
	if player.wall_controller_r.is_colliding() and player.wall_controller_rc.is_colliding():
			state_machine.change_to(player.states.WallSlide)
	elif player.wall_controller_l.is_colliding() and player.wall_controller_lc.is_colliding():
			state_machine.change_to(player.states.WallSlide)
		
	#endregion
	#region Esquina de Correción
	if !player.is_on_wall():
		if player.corner_left_control.is_colliding() and not player.corner_right_control.is_colliding():
			player.global_position.x += 10
		elif !player.corner_left_control.is_colliding() and player.corner_right_control.is_colliding():
			player.global_position.x -= 10
	#endregion
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	if Input.is_action_pressed("Shoot"):
		controlled_node.movement_stats.can_shoot = true
		state_machine.change_to(player.states.ShootJump)
