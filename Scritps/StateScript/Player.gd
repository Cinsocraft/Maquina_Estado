class_name Player
extends CharacterBody2D
#Es script del jugador con sus variables, en el vídeo original no explica una mierda esta parte
@export var movement_stats:CharacterMovementStats

var states:PlayerStateNames = PlayerStateNames.new()

@onready var coyote_timer: Timer = $"Coyote Timer"
@onready var jumper_buffer: Timer = $"Jumper Buffer"
@onready var body: Node2D = $body

func set_facing_direction(x:float) -> void:
	if abs(x) > 0:
		body.scale.x = -1 if (x < 0) else 1

func is_facing_right() -> bool:
	return body.scale.x > 0
	
func _process(_delta):
	set_facing_direction(velocity.x)
