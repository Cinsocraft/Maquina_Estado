extends PlayerStateGravityBase



func on_process(_delta):
	controlled_node.movement_stats.bulletDirection = controlled_node.movement_stats.input_direction
	
	if controlled_node.movement_stats.can_shoot:
			controlled_node.movement_stats.can_shoot=false
			var bulletnode=player.bullet.instantiate() as Node2D
			get_parent().add_child(bulletnode)
			bulletnode.global_position = player.shoot_point.global_position
			if player.body.scale.x < 0:
				player.shoot_point.rotation_degrees = 180
			if player.body.scale.x > 0:
				bulletnode.direction = Vector2(2,0)
				bulletnode.rotation_degrees = 0
				
			else:
				bulletnode.direction = Vector2(-2,0)
				bulletnode.rotation_degrees = 180
###Meter que se imulse lo suficiente adaptandose a la velocidad del personaje

func on_physics_process(delta):
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
	if !player.jumper_buffer.is_stopped() and player.buffer_control.is_colliding():
		if Input.is_action_pressed("Shoot"):
			state_machine.change_to(player.states.ShootBuffer)
		else:
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

func on_input(_event):
	if Input.is_action_pressed("Shoot"):
		controlled_node.movement_stats.can_shoot = true
		state_machine.change_to(player.states.ShootFall)
