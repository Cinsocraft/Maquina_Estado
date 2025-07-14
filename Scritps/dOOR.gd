extends Area2D
@onready var player_node:CharacterBody2D=get_parent().get_node("Player")

func _on_body_entered(body: Node2D) -> void:
	if body == player_node:
		get_tree().change_scene_to_file("res://Scene/Test.tscn")
