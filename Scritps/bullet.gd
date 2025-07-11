extends Node2D


@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var distance_off_timer: Timer = $DistanceOffTimer

var direction: Vector2 = Vector2.RIGHT

var speed: float = 600.0


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	

func _on_distance_timeout_timeout() -> void:
	queue_free()
