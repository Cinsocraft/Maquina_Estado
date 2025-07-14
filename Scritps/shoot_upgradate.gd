extends StaticBody2D

@onready var player_node:CharacterBody2D=get_parent().get_node("Player")
@onready var area_2d: Area2D = $Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if player_node.has_method("unlock_shoot"):
		player_node.unlock_shoot()
		print(player_node.unlock_shoot())
	queue_free()
