extends Sprite2D

var has_fallen:bool=false
@onready var reactiver_timer: Timer = $ReactiverTimer
@onready var player_node:CharacterBody2D=get_parent().get_node("Player")
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var fallen_timer: Timer = $FallenTimer

func _ready() -> void:
	modulate = Color(0, 1, 0, 1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player_node and !has_fallen:
		fallen_timer.start()

func _on_reactiver_timer_timeout() -> void:
	print("Timereactiver Completado")
	_enable_collider()
	has_fallen=false

func _on_fallen_timer_timeout() -> void:
	print("TimerFallen Completado")
	_disable_collider()
	has_fallen=true
	reactiver_timer.start()

func _disable_collider():
	static_body_2d.set_collision_layer_value(1,false)
	static_body_2d.set_collision_mask_value(1,false)
	print("Desactivo")
	modulate = Color(1, 0, 0, 0.5)

func _enable_collider():
	print("Activando colisiones")
	static_body_2d.set_collision_layer_value(1, true)
	static_body_2d.set_collision_mask_value(1, true)
	modulate = Color(0, 1, 0, 1)
