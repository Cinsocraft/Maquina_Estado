class_name PlayerStateGravityBase extends PlayerStateBase

var gravity:float = 1000
const bullet= preload("res://Assets/bullet.tscn")
func handle_gravity(delta):
	controlled_node.velocity.y += gravity * delta
