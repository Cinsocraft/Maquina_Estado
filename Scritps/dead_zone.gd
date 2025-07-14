extends Area2D

@onready var player_node:CharacterBody2D=get_parent().get_node("Player")


func _on_body_entered(body: Node2D):
	if body == player_node:
			print("Objeto detectado:", body.name)
			print("Esta muerta")
			get_tree().reload_current_scene()
