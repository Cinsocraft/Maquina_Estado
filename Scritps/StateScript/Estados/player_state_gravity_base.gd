class_name PlayerStateGravityBase extends PlayerStateBase

var gravity:float = 1000

func handle_gravity(delta):
	controlled_node.velocity.y += gravity * delta
