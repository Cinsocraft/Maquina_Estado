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

func 	on_physics_process(delta):
	var is_on_ground = player.coyote_control_l.is_colliding() and player.coyote_control_r.is_colliding()
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
	#region Cambio de estado
	
	if controlled_node.velocity.y >= 0 and !is_on_ground:
		if controlled_node.coyote_timer.is_stopped():
			state_machine.change_to(player.states.Fall)
		state_machine.change_to(player.states.Coyote)
	
	if player.velocity.x < 0 and player.is_on_floor(): 
		state_machine.change_to(player.states.Move)
		
	if controlled_node.velocity.y > 0:
		state_machine.change_to(player.states.Fall)
	#endregion
	handle_gravity(delta)
	controlled_node.move_and_slide()

func on_input(_event):
	if Input.get_action_strength("left") or Input.get_action_strength("right"):
		if Input.is_action_just_pressed("Shoot"):
			controlled_node.movement_stats.can_shoot = true
			state_machine.change_to(player.states.ShootMove)
		state_machine.change_to(player.states.Move)
	elif Input.is_action_just_pressed("jump"):
		if Input.is_action_pressed("Shoot"):
			state_machine.change_to(player.states.ShootJump)
		else:
			state_machine.change_to(player.states.Jump)
	if !Input.is_action_just_pressed("Shoot"):
		state_machine.change_to(player.states.Idle)
