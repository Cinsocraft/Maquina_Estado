class_name PlayerStateGravityBase extends PlayerStateBase

var gravity:float = 1000
const BULLET = preload("res://Assets/Character/bullet.tscn")
func handle_gravity(delta):
	controlled_node.velocity.y += gravity * delta
