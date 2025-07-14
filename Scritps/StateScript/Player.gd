class_name Player
extends CharacterBody2D
#Es script del jugador con sus variables, en el vídeo original no explica una mierda esta parte
@export var movement_stats:CharacterMovementStats

var states:PlayerStateNames = PlayerStateNames.new()


const bullet = preload("res://Assets/Character/bullet.tscn")

@onready var coyote_timer: Timer = $"Coyote Timer"
@onready var jumper_buffer: Timer = $"Jumper Buffer"
@onready var wall_timer: Timer = $"WallTimer"

@onready var body: Node2D = $body
@onready var shoot_point: Marker2D = $body/ShootPoint
var power_shoot_actived:bool=false


@onready var buffer_control: RayCast2D = $Buffer_Control
###
@onready var wall_controller_r: RayCast2D = $Wall_ControllerR
@onready var wall_controller_l: RayCast2D = $Wall_ControllerL
@onready var wall_controller_rc: RayCast2D = $Wall_ControllerRc
@onready var wall_controller_lc: RayCast2D = $Wall_ControllerLc

@onready var corner_right_control: RayCast2D = $Corner_Right_Control
@onready var corner_left_control: RayCast2D = $Corner_Left_Control
###
@onready var shoot_cool_down: Timer = $ShootCoolDown
	
@onready var coyote_control_l: RayCast2D = $"Coyote_Control L"
@onready var coyote_control_r: RayCast2D = $"Coyote_Control R"



func set_facing_direction(x:float) -> void:
	if abs(x) > 0:
		body.scale.x = -1 if (x < 0) else 1
	
func is_facing_right() -> bool:
	return body.scale.x > 0
	
func _process(_delta):
	set_facing_direction(velocity.x)
	
func unlock_shoot() -> void:
	power_shoot_actived = true
	print(power_shoot_actived)
