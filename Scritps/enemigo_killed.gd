extends CharacterBody2D

@export var speed: float = 60.0
@export var gravity: float = 1000.0
@export var bounce_force: float = 300.0

@onready var player_node:CharacterBody2D=get_parent().get_node("Player")

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var stomp_detector: Area2D = $StompDetector
@onready var timer_dead: Timer = $TimerDead

var direction: Vector2 = Vector2.LEFT
var is_dead: bool = false

func _ready() -> void:
	# Conectar señales
	stomp_detector.body_entered.connect(_on_stomp_detector_body_entered)
	
	# Orientación inicial del sprite
	if direction.x < 0:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	if is_dead:
		# Movimiento después de morir
		velocity.y += gravity * delta
		move_and_slide()
		return
	
	# Aplicar gravedad
	velocity.y += gravity * delta
	
	# Movimiento horizontal
	velocity.x = direction.x * speed
	
	# Mover y detectar colisiones
	move_and_slide()
	
	# Cambiar dirección al chocar con paredes
	if is_on_wall():
		_change_direction()
	
	# Cambiar dirección al llegar al borde de una plataforma
	if not _is_floor_ahead():
		_change_direction()

func _change_direction() -> void:
	direction.x *= -1
	sprite.flip_h = not sprite.flip_h

func _is_floor_ahead() -> bool:
	# Crear un rayo para detectar suelo adelante
	var ray_position = position
	ray_position.y += 16  # Bajar el origen del rayo
	ray_position.x += direction.x * 16  # Adelantar en la dirección
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		ray_position,
		ray_position + Vector2(0, 20),
		collision_mask
	)
	var result = space_state.intersect_ray(query)
	
	return result != null

func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	collision_shape.set_deferred("disabled", true)
	stomp_detector.set_deferred("monitoring", false)
	
	# Aplicar pequeño rebote
	velocity = Vector2.ZERO
	velocity.y = -bounce_force * 0.3
	
	# Hacer el sprite más pequeño (simular muerte)
	sprite.scale = Vector2(1.0, 0.5)
	
	# Esperar y eliminar
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_stomp_detector_body_entered(body: Node) -> void:
	# Solo reaccionar al jugador
	if body == player_node: #Este parametro solo coge el nombre del objecto, debe ser por la capa
		# Si el jugador está cayendo sobre el Goomba
		if body.global_position.y < global_position.y - 10:
			die()
			
			# Hacer rebotar al jugador
			if body.has_method("bounce"):
				body.bounce(bounce_force)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player_node:
		timer_dead.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
