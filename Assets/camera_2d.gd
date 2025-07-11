extends Camera2D

@onready var screen_size: Vector2 = get_viewport_rect().size
var player_node: Node2D

func _ready():
	# Obtener referencia al jugador de forma segura
	player_node = get_parent().get_node_or_null("body")
	
	if player_node:
		# Configurar suavizado
		position_smoothing_enabled = true
		position_smoothing_speed = 7.0
		
		# Posicionar inicialmente
		set_screen_position()
	else:
		push_error("No se encontró el nodo 'body' en el padre")

func _process(delta: float) -> void:
	if player_node:
		set_screen_position()

func set_screen_position():
	var player_pos = player_node.global_position
	
	# Cálculo correcto de posición centrada en el jugador
	var x = player_pos.x
	var y = player_pos.y
	
	# Ajustar posición al centro de la pantalla
	global_position = Vector2(x, y)
