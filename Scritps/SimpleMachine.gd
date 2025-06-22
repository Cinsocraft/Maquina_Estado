extends CharacterBody2D

# Estados del personaje
enum {
	IDLE,
	RUN,
	JUMP,
	FALL
}

# Configuración
@export var run_speed: float = 300.0
@export var jump_force: float = -600.0
@export var gravity: float = 1600.0

# Variables
var current_state: int = IDLE
var move_direction: float = 0.0
var can_jump: bool = true

func _physics_process(delta):
	# 1. Capturar entradas
	move_direction = Input.get_axis("left", "right")
	
	# 2. Aplicar gravedad siempre
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 3. Manejar transiciones de estado
	match current_state:
		IDLE:
			idle_state(delta)
		RUN:
			run_state(delta)
		JUMP:
			jump_state(delta)
		FALL:
			fall_state(delta)
	
	# 4. Aplicar movimiento
	move_and_slide()
	
	# 5. Transiciones entre estados
	update_state()

func idle_state(_delta):
	velocity.x = lerp(velocity.x, 0.0, 0.2)
	# Animación: play("idle")

func run_state(_delta):
	velocity.x = move_direction * run_speed
	# Animación: play("run") y flip_h según dirección

func jump_state(_delta):
	velocity.x = move_direction * run_speed * 0.8  # Menos control en aire
	# Animación: play("jump")

func fall_state(_delta):
	velocity.x = move_direction * run_speed * 0.8
	# Animación: play("fall")

func update_state():
	if is_on_floor():
		if move_direction != 0:
			current_state = RUN
		else:
			current_state = IDLE
	else:
		if velocity.y < 0:
			current_state = JUMP
		else:
			current_state = FALL
	print(current_state)

func _unhandled_input(event):
	# Manejo del salto
	if event.is_action_pressed("jump") and can_jump and is_on_floor():
		velocity.y = jump_force
		current_state = JUMP
		can_jump = false
	
	if event.is_action_released("jump"):
		can_jump = true
		# Salto variable (corta el salto si se suelta rápido)
		if velocity.y < jump_force / 2:
			velocity.y = jump_force / 2
